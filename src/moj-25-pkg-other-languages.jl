# Documentation on calling C and FORTRAN at http://julia.readthedocs.org/en/latest/manual/calling-c-and-fortran-code/.

# C ===================================================================================================================

# Calls to C functions are done via ccall(). You need to specify:
#
# - name of function and the library that it is in;
# - function return type;
# - function input types (as a tuple);
# - function arguments.
#
ccall((:sqrt, "libm"), Float64, (Float64,), 64.0)
ccall(:printf, Cint, (Ptr{Uint8},), "Hello World!")
#
# These are simple examples. More work is required for complex function calls.

# Calls to ccall() can also be wrapped in a function definition, of course.
#
csqrt(x) = ccall((:sqrt, "libm"), Float64, (Float64,), x);
csqrt(64.0)
sqrt(64.0)                          # You're right, I didn't need to call a function to confirm that!
#
# The resulting function is not vectorised by default.
#
csqrt([1, 4, 9, 16])
#
# But it can be vectorised very easily with a handy macro.
#
@vectorize_1arg Real csqrt;
methods(csqrt)
csqrt([1, 4, 9, 16])

# FORTRAN =============================================================================================================

# Another simple example, where the ccall() parameters follow the same rules as above.
#
ccall((:log10f, "libgfortran"), Float32, (Float32,), 100.0)
ccall((:log10, "libgfortran"), Float64, (Float64,), 100.0)

# Something slightly more complicated.
#
ccall((:clog, "libgfortran"), Complex{Float64}, (Complex{Float64},), 1.0+3.0im)
#
# And comparing to Julia result:
#
log(1.0+3.0im)

# FORTRAN function names can be mangled, so you might need to use the nm tool to interrogate the FORTRAN library.

# C++ =================================================================================================================

# Documentation can be found at https://github.com/timholy/Cpp.jl.
#
using Cpp

# This package defines the @cpp macro which handles the mangling of names by the C++ compiler and enables ccall() to
# be used for calling C++ functions. The scope of capabilites is somewhat limited at this time.
#
# There is another package, Cxx, which also facilitates running C++ code from Julia. This package is still under
# development but it appears to be the future of C++/Julia integration.

# PYTHON ==============================================================================================================

# Documentation can be found at https://github.com/stevengj/PyCall.jl.
#
using PyCall

# Which version of Python are we using?
#
pyversion

@pyimport datetime

datetime.MINYEAR
datetime.MAXYEAR

# This gets turned into a Julia Date class.
#
birthday = datetime.date(2016, 3, 16)

@pyimport math

math.cos(math.pi / 4)

@pyimport json

# Create a JSON encoder object.
#
encoder = json.JSONEncoder()
#
encoder[:encode](["foo" => 43, "bar" => 3.5])
pycall(encoder["encode"], PyAny, ["foo" => 43, "bar" => 3.5])

# Calling methods on Python objects has a somewhat obscure syntax (IMHO), but hell it works!
#
@pyimport hashlib as pyhash
#
# To call the .hexdigest() method on the md5 object you need to use [:hexdigest]().
#
md5 = pyhash.md5("Nobody inspects the spammish repetition")
#
md5[:hexdigest]()
pycall(md5["hexdigest"], PyAny)

# Converting Julia objects to Python objects.
#
PyObject(3)
PyObject(rand(3, 5))
PyVector([1:5])
PyDict(["foo" => 43, "bar" => 3.5])
#
pyeval("[x for x in dict.keys()]", dict = PyDict(["foo" => 43, "bar" => 3.5]))

# What about Julia functions? No problem.
#
cube = x -> x * x * x
pycube = PyObject(cube)
pycall(pycube, PyAny, 3)                # Evaluating the Julia function in Python.
#
# You can do the same thing with C (http://julialang.org/blog/2013/05/callback/).

# It's possible to pass Julia functions to Python routines which consume functions.

# R ===================================================================================================================

using DataArrays, DataFrames

# Documentation can be found at
#
# - https://github.com/JuliaStats/RCall.jl
# - https://rawgit.com/JuliaStats/RCall.jl/master/doc/RCall.html
#
using RCall
#
# Another means for accessing R from Julia is provided by the Rif package.

# You have direct access to the datasets package. Note that this only applied to data in the form of a data.frame. Time
# series, for example, obviously can't be accessed like this.
#
airquality = DataFrame(:airquality);
head(airquality)
#
# And for data from other packages...
#
birthwt = DataFrame("MASS::birthwt")

# RPRINT --------------------------------------------------------------------------------------------------------------

# rprint() applies R's print() functionality.

rprint(:HairEyeColor)

# RCOPY ---------------------------------------------------------------------------------------------------------------

# rcopy() provides a high-level interface to R.

rcopy("runif(1)")
"rnorm(1)" |> rcopy

# There are some limitations to rcopy() because it tries to transform the value returned by R into the equivalent data
# type in Julia. Sometimes there just isn't a reasonable translation.
#
"fit <- lm(bwt ~ ., data = MASS::birthwt)" |> rcopy
#
# You can still view the results via rprint().
#
rprint(:fit)
#
"coef(summary(fit))" |> rprint
rcopy("coef(summary(fit))")

# REVAL ---------------------------------------------------------------------------------------------------------------

# reval() is the low-level equivalent to rcopy(), returning objects with types like IntSxp, RealSxp, StrSxp and VecSxp.

reval("1:1000")
reval("runif(1)")
reval("'Hello!'")
reval("x <- list(a = 5)")

"fit <- lm(bwt ~ ., data = MASS::birthwt)" |> reval

# VARIABLES -----------------------------------------------------------------------------------------------------------

# Assigning to variables in R's global environment.
#
globalEnv[:x] = [1:100];
rcopy("ls()")
rprint(:x)

# MISSING VALUES ------------------------------------------------------------------------------------------------------

# RCall defines sentinels (RCall.R_NaReal and RCall.R_NaInt) to handle missing values represented by NA in R.

# rcopy() transforms NA to NaN.
#
rcopy("c(1:3, NA, 5)")
#
# The DataArrays package provides a direct implementation of NA.
#
reval("c(1:3, NA, 5)") |> DataArray

# PLOTTING ------------------------------------------------------------------------------------------------------------

# Base graphics.
#
reval("plot(1:10)");                # Will pop up a graphics window...
reval("dev.off()")                  # ... and close the window.
#
# You can send the graphics output to a file by first calling pdf(), png() or related via reval().

# ggplot2 graphics.
#
reval("library(ggplot2)");
rprint("ggplot(MASS::birthwt, aes(x = age, y = bwt)) + geom_point() + theme_classic()")
reval("dev.off()");

# Plotting Julia objects is possible (but possibly messy!).
#
x = [0:0.01:pi]
y = sin(x)
rprint(rcall(:plot, x, y))      # A little contaminated by text!
reval("dev.off()");
rprint(rcall(:plot, x, y, xlab = "x", ylab = "y"))
reval("dev.off()");


# CALCULUS ============================================================================================================

# JuliaDiff project [http://www.juliadiff.org/] is aggregating resources for differentiation in Julia.

# https://github.com/johnmyleswhite/Calculus.jl

using Calculus

# NUMERICAL DIFFERENTIATION -------------------------------------------------------------------------------------------

# Evaluate the derivative at a specifid point.
#
derivative(x -> sin(x), pi)
derivative(sin, pi, :central)       # Options: :forward, :central or :complex
#
# Compared to "theoretical" result (remembering that this is the NUMERICAL derivative!).
#
cos(pi)

# There is also a Prime Notation which can be used on univariate functions.
#
f(x) = sin(x);
f'(0.0)                             # cos(x)
f''(0.0)                            # -sin(x)
f'''(0.0)                           # -cos(x)

# Partial derivatives (for a multivariate function).
#
gradient(x -> sin(x[1]) + cos(x[2]) + exp(x[3]), [0.0, 0.0, 0.0])

# Second derivative.
#
second_derivative(x -> x^3, 1.0)

# Hessian matrix of a multivariate function.
#
hessian(x -> x[1] + x[1] * x[2]^2 + x[2] * x[3]^3, [1.0, 1.0, 1.0])

# Numerical derivative functions: derivative() can also return a function which evaluates the numerical derivative.
#
g1 = derivative(sin)
g1(0.0)
g1(pi)
map(g1, [0:0.1:pi])					# This is rather useful!
#
g2 = gradient(x -> sin(x[1]) + cos(x[2]) + exp(x[3]))
g2([0.0, 0.0, 0.0])
g2([pi, pi, 1])
#
# And similarly for second_derivative() and hessian().

# SYMBOLIC DIFFERENTIATION --------------------------------------------------------------------------------------------

# For functions expressed as strings.
#
differentiate("sin(x)", :x)
differentiate("sin(x) + exp(-y)", [:x, :y])

# For expressions.
#
differentiate(:(x^2 * y * exp(-x)), :x)
differentiate(:(sin(x) / x), :x)

# NUMERICAL INTEGRATION -----------------------------------------------------------------------------------------------

integrate(x -> 1 / (1 - x), -1 , 0)
#
# Compare with analytical limits.
#
diff(map(x -> - log(1 - x), [-1, 0]))

# Or using Monte Carlo method (:monte_carlo). The default is Simpson's method (:simpsons).
#
integrate(x -> 1 / (1 - x), -1 , 0, :monte_carlo)

# SYMPY ===============================================================================================================

# 1. You'll need to have a working Python installation.
# 2. You'll need to install SymPy (http://docs.sympy.org/latest/install.html).

# http://mth229.github.io/symbolic.html

# It might be an idea to restart your Julia session before loading this because there is some potential for overlap
# with Calculus package.
#
using SymPy

# SYMBOLIC INTEGRATION ------------------------------------------------------------------------------------------------

# Definite integral.
#
integrate(1 / (1 - x), (x, -1, 0))
convert(Float64, ans)

# Indefinite integral.
#
x = Sym("x");                       # Creating a "symbolic object"
typeof(x)
sin(x) |> typeof                    # Functions of symbolic objects are also symbolic objects
#
f(x) = cos(x) - sin(x) * cos(x);
integrate(f(x), x)
#
k = Sym("k");
integrate(1 / (x + k), x)

# FORWARDDIFF =========================================================================================================

using ForwardDiff

# REVERSEDIFFSOURCE ===================================================================================================

using ReverseDiffSource

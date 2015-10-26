# VARIABLES & EXPRESSIONS =============================================================================================

x = 3
x^2

# Chained and simultaneous assignments.
#
a = b = c = 5;
d, e = 3, 5

# LISTING VARIABLES ---------------------------------------------------------------------------------------------------

# Get a list of global variables.
#
whos()
#
# List exported variables from another module.
#
whos(Base)

# COMPOUND EXPRESSIONS ------------------------------------------------------------------------------------------------

# A compound expression consists of a series of expressions and will return the value of the final expression.

# Verbose form.
#
x = begin
	p = 2
	q = 3
	p + q
end

# Compact form.
#
x = (p = 2; q = 3; p + q)

# SHELL VARIABLES -----------------------------------------------------------------------------------------------------

ENV["SHELL"]

# DATA TYPES ==========================================================================================================

# Julia is dynamically typed, so it is not necessary to specify the types of variables. However in many circumstances,
# being specific about types can lead to more robust and efficient code.

# TYPE HIERARCHY ------------------------------------------------------------------------------------------------------

# Type is associated with the value stored in a variable and not with the variable itself.
#
x = 3.5;
typeof(x)
x = 8;
typeof(x)
#
# The data types of used in the assignments above were inferred implicity by the interpreter. It is also possible to
# explicitly specify the data type.
#
int32(8)
float64(8)

typeof(Int64)						# Data types are also types. Tautology? No doubt.

# Type tests.
#
isa(8, Int64)
isa(8, Number)
isa(8, String)

# The type hierarchy can be reconstructed using super() and subtypes().
#
super(Float64)
super(super(Float64))
subtypes(FloatingPoint)
#
super(Int64)
super(Signed)
super(Integer)
super(Real)
Int64 <: Signed <: Integer <: Real <: Number

# Subtype relationships can be queried.
#
Float64 <: FloatingPoint
Float64 <: Integer
Int64 <: Int						# Int64 is a subtype of Int
ASCIIString <: Int					# ASCIIString is not a subtype of Int
issubtype(Float64, FloatingPoint)

# ANNOTATIONS & CONVERSIONS -------------------------------------------------------------------------------------------

# Type assertions are of the form x::Type where x is a literal and Type is a type name.
#
3.5::Float64
3.5::Int64						# Will generate an assertion error.
3.5::Number
#
# Note that abstract types can be used in annotations.

# The annotation operator can be used for type declaration in a local scope (for example, within a function).

# Type conversion.
#
convert(Float64, 3)
float64(3)
#
# Whereas convert() will check for loss of precision, converting with a type name will not.
#
convert(In64, 3.5)
int64(3.5)

# Converting values to a common type.
#
promote(3.5, 2, 1+1im)
promote_type(Float64, Int64, Complex{Int64})
promote_type(Float64, Int64, Complex{Int64}, String)

# More information on type conversion at http://julia.readthedocs.org/en/latest/manual/conversion-and-promotion/.

# NUMERICAL TYPES -----------------------------------------------------------------------------------------------------

# Partial numeric type hierachy:
#
#   Number				<- Abstract
#     Real				<- Abstract
#       FloatingPoint			<- Abstract
#         BigFloat
#         Float16
#         Float32
#         Float64
#       Integer				<- Abstract
#         BigInt			<- Abstract
#         Signed			<- Abstract
#           Int32
#           Int64
#         Unsigned			<- Abstract
#           Uint32
#           Uint64
#       Rational
#     Complex
#
# The granddaddy of all types is Any.
#
# Abstract types have subtypes but cannot be instantiated. Conversely, concrete types do not have subtypes and can
# be instantiated.

# Imaginary numbers
#
(4 + 3im)^2

# Rational numbers
#
1//2
float(1//2)
12//8                               # Fractions always expressed in simplest form.

# Numerical precision
#
sqrt(2)
big(sqrt(2))

with_rounding(Float64,RoundNearest) do
	sqrt(2)
end

# Single and Double precision constants are specified using special syntax.
#
1.23f-1						        # Single precision
1.23e-1						        # Double precision

# Arbitrary precision numbers are facilitated by BigInt and BigFloat.

# Complex and rational types are parametric.
#
Complex{Float32}
Rational{Int64}
#
typeof(3+4im)
typeof(3.0+4im)
typeof(3//4)

# MATHEMATICAL OPERATIONS ---------------------------------------------------------------------------------------------

srand(5);

# All of the "normal" operations are supported. These are some novel ones.

# Clip array to maximum and minimum values.
#
clamp(rand(10), 0.1, 0.5)

# BITWISE OPERATIONS --------------------------------------------------------------------------------------------------

~5						# NOT
3 & 1						# AND
3 | 4						# OR
3 $ 2						# XOR
5 >> 1						# right shift
5 << 1						# left shift

bits(359)					# Binary representation as a String.

# STRINGS & CHARACTERS ------------------------------------------------------------------------------------------------

# Strings are immutable and indexable (starting from 1) sequences of characters.
#
# More information at http://julia.readthedocs.org/en/latest/manual/strings/.

s1 = "This is a string.";			# type: ASCIIString. Strings are enclosed in double quotes.
s2 = "β is a Unicode character.";		# type: UTF8String.
c = 'a'						# type: Char. Characters are enclosed in single quotes.
#
"a" != 'a'					# Strings and characters are not equivalent.
#
"""
This
is a
multi-line
string.
"""

# ASCII and Unicode strings are different types.
#
typeof(s1)
typeof(s2)

# Integer code for a character.
#
int('a')
#
# Integer arithmetic works on characters.
#
'a' + 3
'd' - 'a'

# Concatenation and replication.
#
string("Hello", " ", "World", '!')
"Hello" * " " * "World!"
#
"xxx "^5
#
# A builtin function for joining strings (with handy bells and whistles!).
#
join(["a", "b", "c", "d"], ", ", " and ")

# Indexing and length.
#
name = "Julia"
name[1]
name[end]
name[2:4]
name[1:2:end]
length(name)

# String interpolation. Expressions must be enclosed in ().
#
"My name is $name and I'm $(2015-2012) years old."

# Case transformations.
#
uppercase("abcde")
lowercase("AbCdE")
ucfirst("abcde")
lcfirst("AbCdE")

# STRING COMPARISONS --------------------------------------------------------------------------------------------------

# https://github.com/samuelcolvin/JellyFish.jl
# https://github.com/sunlightlabs/sausagedog

using JellyFish

@show jaro_winkler("sausagedog", "sausageflog")
@show hamming_distance("sausagedog", "sausageflog")
@show levenshtein_distance("sausagedog", "sausageflog")

@show metaphone("sausagedog")           # https://en.wikipedia.org/wiki/Metaphone
@show soundex("sausagedog")             # https://en.wikipedia.org/wiki/Soundex

@show match_rating_comparison("sausagedog", "sausageodg")
@show match_rating_comparison("sausagedog", "sussageodg")

# REGULAR EXPRESSIONS -------------------------------------------------------------------------------------------------

# Regular expressions are denoted by a 'r' prefix.
#
r1 = r"s[^ ]"
#
typeof(r1)
#
username_regex = r"^[a-z0-9_-]{3,16}$"
hex_regex = r"#?([a-f0-9]{6}|[a-f0-9]{3})"i		# Suffix indicates that case-insensitive.

# Splitting.
#
split(s1)
split(s1, 's')
split(s1, r1)						# Splitting on a regular expression.

# Searching.
#
search(s1, r1)						# Returns indices which match.

# Replacing.
#
replace(s1, "trin", "pri")

# Matching.
#
ismatch(username_regex, "my-us3r_n4m3")
ismatch(username_regex, "th1s1s-wayt00_l0ngt0beausername")
#
m1 = match(hex_regex, "I like the color #c900b5.")	# Returns a first match as type RegexMatch.
m1.match						# Matched substring.
m1.offset						# Index of match.
m1.captures						# Type which would be matched.
#
colours = "#c900b5 yellow #FFe green #636363 blue"
m2 = matchall(hex_regex, colours)
#
for rgb in eachmatch(hex_regex, colours)
	println("I like the colour $(rgb.match).")
end

# UNICODE -------------------------------------------------------------------------------------------------------------

# Unicode characters can be freely used in variable names.
#
α = 3
β = 0.5
μ = "This is the mean"
★ = 7					# \bigstar

'\u2660'				# Unicode character using 4-digit hexadecimal code.
'\U1f0de'				# Unicode character using more than 4-digit hexadecimal code.

# Generating the Unicode characters is fairly simple too using LaTeX. To get α, type \alpha and hit [Tab].
#
# Mapping table at https://github.com/JuliaLang/julia/blob/master/doc/manual/unicode-input-table.rst.

# DATES & TIMES -------------------------------------------------------------------------------------------------------

# More information at https://en.wikibooks.org/wiki/Introducing_Julia/Working_with_dates_and_times.

using Dates

vandag = today()			# Today's date			-> Date class
nou = now()				# Now! (date and time)		-> DateTime class

time()					# UNIX time, which can be formatted with strftime()

# Date and time from string in arbitrary format.
#
Dates.Date("2015-08-17", "yyyy-mm-dd")
Dates.DateTime("2015-08=17 12,23]59", "yyyy-mm=dd HH,MM]SS")
#
# And formatting to a string. 
#
Dates.format(nou, "yy/mm/dd HH:MM:SS.ss")
#
# For repeated formatting, define DateFormat object to avoid repeated parsing.
#
fmt = Dates.DateFormat("yy/mm/dd HH:MM:SS.ss");
Dates.format(nou, fmt)

year(vandag)
month(vandag)
day(vandag)
#
# There is a range of other functions including dayofweek(), dayname(), monthname(), yearmonth(), yearmonthday() and
# isleapyear().
#
hour(nou)
minute(nou)
second(nou)

firstdayofweek(vandag)
firstdayofmonth(vandag)

# What is date next Monday?
#
Dates.tonext(d -> Dates.dayofweek(d) == Dates.Monday, vandag)
#
# There are also toprev(), tofirst() and tolast() functions.

# Arithmetic.
#
now() - nou
vanday + Dates.Year(1) + Dates.Month(3) + Dates.Day(2)

# Ranges.
#
[Date(2015,1,1):Day(7):Date(2016,1,1)]	# One week intervals

# Timing execution.
#
tic(); sleep(5); toc()
@elapsed sleep(2)

# CONSTANTS -----------------------------------------------------------------------------------------------------------

const lucky = 13
#
lucky = 7					# Will generate a Warning. You can change the value of a constant...
lucky = "Not so very lucky!"			# ... but you can't change its type.

# UNIONS --------------------------------------------------------------------------------------------------------------

# A Union is a single alias for multiple types.

Numeric = Union(Int64, Float64)
#
4::Numeric					# Both integers...
3.5::Numeric					# ... and floats are Numeric.
"Hello!"::Numeric				# But a string is not!

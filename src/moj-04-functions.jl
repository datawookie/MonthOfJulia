# FUNCTIONS ===========================================================================================================

# Verbose form.
#
function square(x)
    return x^2                  # The return keyword is redundant, but still a good idea.
end

# One-line form.
#
square(x) = x^2
hypotenuse(x, y) = sqrt(x^2 + y^2)
x² = x -> x*x                   # To get x² type x\^2 followed by Tab in the REPL.

# Anonymous (lambda) form.
#
x -> x^2
#
anonsquare = function (x)       # Creates an anonymous function and assigns it to anonsquare.
    x^2
end

# Optional (positional) arguments.
#
rectangle(x, y = x) = x * y             # If only one dimension specified it must be a square.
rectangle(3, 5)
rectangle(3)

# Keyword arguments come after positional arguments and are separated by a ';'.
#
function rectangle(x, y = x; color = "black", θ = pi / 2)
    (x * y * sin(θ), color)                     # Return multiple values as a tuple.
end
rectangle(2, 3)                                 # Only positional arguments.
rectangle(2, 3; color = "red")                  # Positional and keyword arguments.
rectangle(2, 3; θ = pi / 3, color = "red")

# Operators as functions with arguments in infix notation (https://en.wikipedia.org/wiki/Infix_notation).
#
3 + 7
+(3, 7)
#
# Examples from J. Bezanson, A. Edelman, S. Karpinski, and V. B. Shah, “Julia: A Fresh Approach to Numerical Computing,”
# arXiv, vol. 1411.1607v, 2014.
#
*(a::Number, g::Function)= x->a*g(x)            # Scale output
*(f::Function, t::Number) = x->f(t*x)           # Scale argument
*(f::Function, g::Function)= x->f(g(x))         # Function composition
#
(sin^2)(pi/4) == sin(sin(pi/4))                 # Works as a result of function composition with *

# Relational operators.
#
≪(x,y) = x < y / 10
≦(x,y) = !(x > y)
(10 ≪ 100, 9 ≪ 100)
(3 ≦ 5, 5 ≦ 5, 6 ≦ 5)

# VARARGS -------------------------------------------------------------------------------------------------------------

# What about functions with variable number of arguments?

function itemlist(x...)                         # The "..." is known as a "splat". x is passed as a tuple.
    length(x) == 0 ? "Nothing." : return join(x, ", ", " and ") * "."
end

# A splat can also be used when calling a function, in which case it will expand the splatted array into the argument
# list.
#
/(3, 4)
/([3, 4])                                       # This won't work.
/([3, 4]...)                                    # Equivalent to /(3, 4)
#
# Also works with variables
#
x = [3, 4]
/(x...)

# Interesting application of the splat.
#
[rand(2,2) for n in 1:5]                        # A 5-element 1D array of 2x2 arrays.
[[rand(2,2) for n in 1:5]...]                   # A 10x2 array.
[[[rand(2,2) for n in 1:5]...]...]              # A 20-element 1D array.

# MULTIPLE DISPATCH ---------------------------------------------------------------------------------------------------

# You might have noticed that when a new function is defined in Julia the REPL states somethings like
#
#   funky (generic function with 4 methods)
#
# This is because there can be multiple implementations of a function with a single name. This allows a function to
# have different behaviours depending on the types of its arguments.
#
2 * 3                                           # * -> integer multiplication
"a" * "b"                                       # * -> string concatenation
#
# This feature is known as "multiple dispatch".

# n.method(x, y)                - Object Oriented languages
# method(n, x, y)               - Julia 
#
# Traditional Object Oriented programming languages implement single dispatch where method calls are attached to a
# particular object (n in the examples above), which is then in some sense "special". Julia's multiple dispatch selects
# the appropriate function based on the types of all of the arguments (all n, x and y in the examples above).

# Each of these calls will result in the JIT compiler creating code for a particular argument type.
#
square(2)
square(3.5)
square(3 + 5im)
x²(2)
x²(3.5)

function foo(x)
    y::Float64 = 3                              # Type declarations can occur within function body.
    return(x + y)
end

# Functions can return multiple values packed into a tuple.
#
function divide(n, m)
    div(n,m), n%m
end
#
# This function is inherently generic (or polymorphic) and can be used on arguments of various types.
#
divide(6, 4)
divide(3.5, 2.0)

# Now we can define a new method for the same function (effectively "overloading" the function) specialised for
# FloatingPoint types. Effectively this new function acts like a filter: if there is no function defined for a
# particular combination of types then the generic function is used.
#
function divide(x::FloatingPoint, y::FloatingPoint)
    x / y
end
#
# When overloading a function it is a good idea to use an abstract type rather than a concrete type. For example, we
# could have used Float64 in the definition above, but this would have constrained the range of applicability.
#
# Assuming that you are on a 64 bit machine, this will generate a different result to the same call above.
#
divide(3.5, 2.0)

# To get a list of the methods associated with a function or operator...
#
methods(divide)
methods(/)

# The @which macro will indicate which method is called for a particular function invocation. Note that only the third
# call below uses the specialised version of the function.
#
@which divide(4, 2)
@which divide(4.5, 2)
@which divide(4.5, 2.3)

# The first time that a function is called it takes a little longer to execute due to the overhead of JIT compilation.
# On subsequent invocations the cached version of the function is used.
#
@time factorial(10)
@time factorial(10)

# Example (courtesy of the Julia documentation).
#
methods(*)
"Hello" * "World!"                                  # "*" is a concatenation operator for strings...
"Hello" + "World!"                                  # ... but "+" does not handle strings by default.
#
import Base.+
+(x::String, y::String) = x * " " * y
#
"Hello" + "World!"
sum(["Hello", "World!"])                            # Functions that depend on "+" also work now.

# Example: multiply strings.
#
4 * "xxx"                                           # Doesn't work.
#
function *(n::Unsigned, txt::String)
    txt^n
end
4 * "xxx"

# PARAMETRIC TYPES ----------------------------------------------------------------------------------------------------

function sametype{T}(x::T, y::T)
    println("$x and $y are of the same type")
end
sametype(1, 2)
sametype("foo", "bar")
sametype(1, "bar")                                  # This won't work because it doesn't conform to function signature.

# Restricting possible types.
#
function samereal{T<:Real}(x::T, y::T)
    println("$x and $y are both real numbers of the same type")
end
samereal(1, 2)
samereal(1.3, 2.7)
samereal(1, 2.7)                                    # This won't work because arguments are Int64 and Float64.

# PIPELINING ==========================================================================================================

1:10 |> (x -> x.^2) |> mean

# SCOPE ===============================================================================================================

# Functions each have their own local scope. You can differentiate between variables in the local and global scope
# though.
#
n = 5
function foo()
    n = 1                                           # This is local within the function
    for i = 1:10
        local n                                     # This is local within the function and the for loop
    end
    global n = 12                                   # This accesses the global variable
end
#
# In practice though you should try to avoid this style of coding because multiple uses of the same variable name makes
# things rather confusing.

# REFLECTION / INTROSPECTION ==========================================================================================

code_lowered(divide, (Int, Int))

code_typed(divide, (Int, Int))

# Bytecode generated by the LLVM JIT compiler.
#
code_llvm(sqrt, (Float64,))
code_llvm(divide, (Int, Int))
code_llvm(square, (Int64,))

# Native assembly code.
#
code_native(divide, (Int, Int))
code_native(square, (Int64,))
code_native(square, (Float32,))

# These are more of an interesting oddity to me. The chances that I will actually use any of them is vanishingly
# small.

# FUNCTION GUIDELINES =================================================================================================

# * Be as specific as possible with argument types. Rather have more methods to cover multiple types.
#   -> Better performance.
#   -> Functions are self-documenting.
# * A collection of compact functions is better than a single function behemoth!
#   -> Better performance.
#   -> Easier to maintain.
# * Time your functions with @time.
#   -> Both timing and memory consumption.
#   -> Run your functions once before timing though so that JIT compiler can do its work.

# EXAMPLE FUNCTIONS ===================================================================================================

# A function to guess possible email address given first and last names along with domain. If these options fail then
# an alternative would be to seach for other email addresses from the same domain and try to extract a pattern. If the
# the domain is gmail.com then you are not going to find this very fruitful, but most corporates have a well defined
# scheme for email addresses.
#
# If you are wondering, then yes, I am a closet spam kingpin and this sort of thing interests me. ;-)
#
function guessEmail(first, last, domain)
    [join([x, domain], '@') for x in [first, last, "$first\_$last", "$first.$last", "$(first[1])$last", "$(first[1]).$last"]]
end
println(guessEmail("andrew", "collier", "exegetic.biz"))

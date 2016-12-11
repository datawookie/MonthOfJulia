# CONDITIONALS ========================================================================================================

n = 8;

if (n > 7)                          # The parentheses are optional.
    println("high")
elseif n < 3
    println("low")
else
    println("medium")
end

# The argument of the conditional MUST be a Boolean (true or false). Unlike other languages 0 does not pass for false
# and 1 will not be interpreted as true.

# Standard comparisons operators: ==, !=, <, >, <=, >=.
#
2 == 2
isequal(1, 2)
#
# Grouped comparisons.
#
1 < π && π < 4                      # Logical AND
1 < π || 4 < π                      # Logical OR
#
# Chained comparisons.
#
1 < π < 4 >= 3

# Checking whether a symbols has been defined.
#
isdefined(:n)                       # The : means we pass the symbol and not its value
#
# Other checks.
#
isfinite(Inf)

# The conditional structure has a return value too (this would have been nothing above since that's what println()
# returns.
#
if n > 3 0 else 1 end
#
# The same result can be achieved with the ternary operator (see below).

# Notes on comparisons.
#
Inf == Inf                          # true
Inf > NaN                           # false
NaN == NaN                          # false
isequal(NaN, NaN)                   # true

# TERNARY OPERATOR ====================================================================================================

if n > 3 0 else 1 end               # Conditional.
n > 3 ? 0 : 1                       # Ternary conditional.
#
# Note that multiple comparisons may be made simultaneously.
#
3 <= n < 7 ? 1 : 0

# Recursive functions and ternary operator
#
fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)
fib(5)
#
# And a factorial operator (well, close enough to the correct notation!)
#
import Base:!
!(n) = n < 2 ? 1 : n * !(n-1)
!10
# Compare with builtin
factorial(10)

# ITERATION ===========================================================================================================

# A for loop can iterate over the elements of any collection. You can use "=" in place of "in".
#
for n in 1:10
    println("number $n.")
end

# Note that there is a distinction between the following two code fragments:
#
#   for n in collect(1:10)
#   for n in 1:10
#
# The first allocates an array while the second uses a Range object. Use the second because it's more efficient.

# The enumerate() function is useful if you need to know where you are in the collection.
#
text = "This is a string."
for (i, c) in enumerate(text)
    println("Character $i is '$c'.")
end

# There is a compact notation for nested loops.
#
for n = 1:5, m = n:5
    println("The sum of $n and $m is $(n+m).")
end

# Iterating over a dictionary.
#
for (key, value) in Dict("a" => 1, "b" => 2, "c" => 7)
    println("$key maps to $value")
end

# The while loop repeats as long as its condition is true. Note that continue and break statements are used here as
# well. These are also applicable in for loops.
#
# Consider the following shortcut uses:
#
#   condition && break
#   condition && continue
#
a = 0
while a < 20
    a += rand(-5:5)
    if a < 0
        println("Sorry, we don't print negative numbers!")
        continue
    end

    println("The next random number is $a.")
    if a == 7
        println("Bingo! You hit the magic number.")
        break
    end
end

# The for and while blocks each introduce their own local scope.

# EXCEPTIONS ==========================================================================================================

# Functions throw exceptions under abnormal conditions.
#
factorial(-1)
#
# All exceptions are derived from the Exception type.
#
supertype(DomainError)
supertype(ArgumentError)

# Raise exceptions with throw().
#
!(n) = n < 0 ? throw(DomainError()) : n < 2 ? 1 : n * !(n-1)
!10
!0
!-1
#
# error() generates an ErrorException. The info() and warn() functions are less aggressive.
#
!(n) = n < 0 ? error("argument must be >= 0") : n < 2 ? 1 : n * !(n-1)
!-1
info("Are you sure you want to do that?")
warn("That might not be a good idea...")

# Catching any old exception.
#
try
    !-1
catch
    println("Well, that did't work!")
end

# Catching any old exception and storing the exception object.
#
try
    error("Something went horribly wrong!")
catch e
    # rethrow(), backtrace() and catch_backtrace() could be useful here.
    #
    println("We got an exception of type ", typeof(e), " [", e, "]")
finally
    println("You'll see me even when there is no exception thrown!")
end

# The catch clause is not actually required.
#
try sqrt(-1) end

# Update our divide() function to handle zero division with an exception.
#
function divide(n, m)
    if m == 0
        throw(DivideError())
    end
    div(n,m), n%m
end
#
# Note that the exception type needs to be called to generate an exception object. For some exception types this call
# will accept an argument.
#
throw(UndefVarError(undefinedvariable))

# This does not end well...
#
divide(1, 0)

# ... whereas the outcome here is a little more elegant.
#
try
    divide(1, 0)
catch e
    if isa(e, DivideError)
        println("You shouldn't even THINK about dividing by zero!")
    else
        println("Something else went wrong...")
    end
    showerror(STDOUT, e)
finally
    println("This code will always run, exception or not!")
end
#
# The finally clause is important for implementing any cleanup code.

# Note that, as with other languages, exceptions in Julia are quite inefficient and it is better to make a preemptive
# check before calling a function which could throw an exception.

# The try block introduces its own local scope.

# Custom exceptions: roll your own.
#
type CustomException <: Exception
end

type VerboseCustomException <: Exception
    txt::String
end

# PATTERN MATCHING ====================================================================================================

# https://github.com/kmsquire/Match.jl
# https://matchjl.readthedocs.org/en/latest/

# The Match package provides a sophisticated interpretation of the switch construct.

using Match

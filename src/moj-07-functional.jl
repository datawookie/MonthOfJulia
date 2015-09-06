# FUNCTIONAL PROGRAMMING ==============================================================================================

# There are a number of "higher order" functions which accept other functions as arguments. Generally these functions
# are applied to collections of other objects.

# Writing a "higher order" function is simple.
#
function higher(f, x)               # Function passed as first argument.
    f(x)
end
higher(sqrt, 4)
higher(x -> x^2, 3)
higher(-, 3)                        # Operators are functions too.

# Functions can return functions too.
#
pow(n) = x -> x^n
g = pow(3)
g(2)

# MAP -----------------------------------------------------------------------------------------------------------------

# map(F, collection) applies function F to every element of collection. F is often an anonymous function.
#
map(x -> x^2, [1:5])                # Univariate function
map(/, [16, 9, 4], [8, 3, 2])       # Multivariate function (actually operator!)
#
# There's another way to write these using a do block, which is another way to create an anonymous function but allows
# you to make the contents of the function more complicated.
#
map([-3:3]) do x
    x^3
end

# A comprehension can generally do the same work as map().
#
[x^2 for x in 1:5]

# FILTER --------------------------------------------------------------------------------------------------------------

# filter(F, collection) returns only those elements of collection for which function F returns true.
#
filter(n -> n %3 == 0, [0:10])

filter(isprime, [1:100])                # Find values (not indices!) which are prime.
#
# filter!() will modify its argument in place, applying the filter.

# REDUCE --------------------------------------------------------------------------------------------------------------

reduce(+, [1, 2, 3])                    # See also foldl() and foldr().
reduce(/, 1:4)

foldl(/, 1:4)
((1 / 2) / 3) / 4
foldr(/, 1:4)
1 / (2 / (3 / 4))

reduce(max, [1, 2, 3])
#
# There are aliases for common operations: maximum(), minimum(), sum(), prod(), any() and all().

# MAPREDUCE -----------------------------------------------------------------------------------------------------------

# Map and Reduce.
#
mapreduce(x -> x^2, +, [1:5])               # See also mapfoldl() and mapfoldr().
(((1^2 + 2^2) + 3^2) + 4^2) + 5^2

# ZIP -----------------------------------------------------------------------------------------------------------------

# zip() is not a high-level function. But it is handy for using with other functional programming constructs. zip()
# takes collections as arguments and then combines corresponding elements from those collections into tuples.
#
map(x -> sum(x), zip(1:4, 5:8))

# LIST COMPREHENSION --------------------------------------------------------------------------------------------------

# A list comprehension populates an array via an implicit loop.
#
[x^3 - 1 for x in [1:4]]
#
# This will create a 3x3 array. By default the type of the array would be Float, but we can force it to be an integer.
#
Int64[x / y for x in [16, 8, 4], y in [4, 2, 1]]


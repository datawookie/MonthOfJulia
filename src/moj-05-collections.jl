# COLLECTIONS =========================================================================================================

# ARRAYS --------------------------------------------------------------------------------------------------------------

# Characteristics of Arrays:
#
#   - elements are indexable (with [] notation, where indices begin at 1);
#   - elements are mutable;
#   - order is important (same contents in different order will not equate);
#   - duplicates are permitted.
#
# Array{T,N} is an N-dimensional array of subtype T.

# -> 1D Arrays.
#
x = [-7, 1, 2, 3, 5]                # This is a "column vector"
typeof(x)
eltype(x)
y = [3, "foo", 'a']                 # Elements can be of mixed type
typeof(y)                           # Type of the Array itself
eltype(y)                           # Type of the elements in the Array
#
# Indexing into an array.
#
x[1]                                # First element
getindex(x, [1, 3])                 # Alternative syntax
x[end]                              # Last element
x[end-1]                            # Penultimate element
x[2:4]                              # Slicing
x[2:4] = [1, 5, 9]                  # Slicing with assignment
setindex!(x, [0, 4, 8], [2:4])

# Unpacking arrays.
#
a, b, c = x[2:4]

# Array functions.
#
pop!(x)                             # Returns last element and remove it from array.
push!(x, 12)                        # Append value to end of array.
append!(x, 1:3)                     # Append one array to the end of another array.
#
shift!(x)                           # Returns first element and remove it from array.
unshift!(x, 0)                      # Prepend value to front of array.
#
splice!(y, 2)                       # Remove an element from an array.

# Ranges.
#
range(0, 0.5, 11)                   # FloatRange <: FloatRange
0:10                                # UnitRange <: FloatRange
typeof(0:10)
#
[range(0, 0.5, 11)]                 # Range interpreted into an array
[0:0.5:5]
[0:10]
typeof([0:10])

# Searching.
#
in(1, x)                            # Check if an element is in a collection.
#
findfirst(x, 1)                     # Find index of first occurrence of 1.
findfirst(isodd, x)                 # Find index of first odd element. Note reversed order of arguments.
#
find([0, 1, 0, 5, 0, 1, 0, true])   # Find indices of all non-zero elements
#
find(isodd, x)                      # Find indices of all odd elements.
#
findnext(x, 1, 3)
findnext(isprime, x, 4)             # Find next prime element, starting at index 4.

# Counting.
#
count(isprime, x)

# Sorting.
#
sort(x)
sort(x, by = abs, rev = true)           # Sort using absolute value in reverse order.
#
# You can specify the sort algorithm.
#
# You can also sort in place using sort!().

# Quantifiers.
#
all(x .< 3)
all(x .< 15)
any(x .< 3)

# -> Multidimensional Arrays.
#
# A (column) vector is a special case of an array with type Array{Int64,1} or Vector{Int64}.
#
[7, -1, 3]
[7; -1; 3]
#
# But we can also make a row vector with type Array{Int64,2} or Matrix{Int64}. Julia regards this as a two dimensional
# object.
#
[7 -1 3]

# A 2D array.
#
M = [1 2 3; 4 5 6; 7 8 9]
N = [1 2; 2 3; 3 4]

# Indexing and slicing a 2D array.
#
M[2,2]                      # [row,column]
M[1:end,1]
M[1,:]                      # : is the same as 1:end
#
# Slicing works with assignment too.
#
M[1:2,1:2] = [1 0; 0 1]

# Transpose.
#
M'
transpose(M)

# Matrix inverse.
#
inv(M)

# Matrix multiplication.
#
M * N
M * M'
M * inv(M)
#
# Element-wise multiplication.
#
M .* M'

# Creating arrays.
#
ones(3, 2)
zeros(5)
trues(3)
falses(3)
eye(3)                      # Identity matrix (specified size)
zeros(3, 3) + I                 # I is identity matrix which scales to be same size as other argument.
SymTridiagonal(ones(5), -ones(4))       # Something a little more exotic.
fill("xxx", 3)
fill(5, (3, 2))
#
[i^2 for i in 1:10]             # Array from a comprehension.
[1//(i+j) for i = 1:4, j = 1:4]

# Identity matrix.
#
eye(4)

# Random matrices.
#
rand(4, 4)

# Dimension, number of rows and columns.
#
ndims(N)
size(N, 1)                  # Number of rows
size(N, 2)                  # Number of columns
size(N)
#
# You can also change the shape of a matrix.
#
reshape(N, (2, 3))

# Concatenating matrices.
#
hcat(M, M)
[M M]
#
vcat(M, M)
[M; M]
[M, M]
#
cat(2, M, N)

# Solving a linear system. For example,
#
#   2a + 3b = 1
# - 4a - 5b = 1
#
[2 3; -4 -5] \ ones(2)

# Making copies:
#
# copy() - create a "shallow" copy [new array referring to the same elements as original]
# deepcopy() - create a completely independent collection consisting of independent copies of each of the elements

# TUPLES --------------------------------------------------------------------------------------------------------------

# A tuple is a set of values (possibly of mixed type) separated by commas and optionally enclosed by parentheses.

# Characteristics of Tuples:
#
#   - elements are indexable;
#   - elements are immutable.

# Tuple assignment.
#
a, b, x, text = 1, 2, 3.5, "Hello"
a, b, x, text = (1, 2, 3.5, "Hello")
#
a, b = b, a                         # I never get tired of this!

# Type annotation and assertion.
#
(1, "zap!")::(Int64, String)
(1, "zap!")::(Int64, Real)

# Tuple types enumerate the types of each element in the tuple.
#
typeof((1, "zap!"))

# Indexing and slicing.
#
fibtuple = (1, 1, 2, 3, 5, 8)
fibtuple[4]
fibtuple[4:5]
fibtuple[4:end]

# Tuples are immutable.
#
fibtuple[4] = 9                 # This will generate an error!

# Tuples support iteration.
#
for n in (1, 1, 2, 3, 5, 8)
    println(n)
end

# Tuple unpacking. Note that the number of variables on the left does not need to match the length of the tuple.
#
a, b = fibtuple[4:end]

# DICTIONARIES --------------------------------------------------------------------------------------------------------

# Characteristics of Dictionaries:
#
#   - key-value pairs;
#   - associative (elements are accessed via a unique key);
#   - not indexable;
#   - order does not matter;
#   - keys are unique but values may be duplicates ("one-to-many");
#   - mutable.

# The Dict type stores (key, value) tuples.

# Typed dictionaries (where all keys have same type) are created with [].
#
ages = ["Andrew" => 43, "Claire" => 35]

# Dynamic dictionaries (with keys of various types) are created with {}. These are typically less efficient than typed
# dictionaries.
#
stuff = {"number" => 43, 1 => "zap!", 2.5 => 'x'}

# Symbol dictionaries.
#
[:andrew => 43, :claire => 35]

# Retrieving values.
#
ages["Andrew"]                      # This can also be used for assignment.
ages["Patrick"]                     # This will generate an error because the key is not defined.
get(ages, "Patrick", 23)                # Default value if the key is not defined.
get!(ages, "Patrick", 23)               # Default value and modify original dictionary.
pop!(ages, "Patrick")

# Merging.
#
merge(ages, {"Matilda" => 13})              # There's also a merge!().

# Iterating over a Dict.
#
for (k, v) in ages
    println("$k is $v years old.")
end

# Lists of keys and values.
#
keys(ages)                      # Returns an iterator over the keys.
"Andrew" in keys(ages)
haskey(ages, "Claire")
#
values(ages)

# Checking for key/value pairs.
#
in(("Andrew", 43), ages)
("Andrew", 43) in ages

# Removing keys.
#
delete!(ages, "Andrew")

# Constructing dictionaries.
#
Dict()                          # Empty dictionary with key/value of arbitrary type.
Dict{String, Float64}()                 # Empty dictionary with key/value of specific type.
Dict(["Andrew", "Claire"], [43, 35])            # Zip creation (old).
Dict(zip(["Andrew", "Claire"], [43, 35]))       # Zip creation (new).
[i => i^2 for i = 1:10]                 # Note that the result is unordered.

# Dictionaries use a hashing function to derive unique values from keys.
#
hash(1)
hash("foo!")

# SETS ----------------------------------------------------------------------------------------------------------------

# Characteristics of Sets:
#
#   - values are unique;
#   - unordered;
#   - not indexable;
#   - not associative;
#   - effectively immutable (hard to access elements to change them).

# Duplicates are eliminated.
#
Set({1, 3, 5, 3, 9, 3, 17})
Set(1, 2, 2, 2, 3)

S1 = Set([1, 2, 3, 4, 5])           # Set{Int64}
S2 = Set({3, 4, 5, 6, 7})           # Set{Any}

# Set operations.
#
union(S1, S2)
union!(S1, [13])
intersect(S1, S2)
setdiff(S2, S1)
setdiff!(S2, 6)
symdiff(S1, S2)                     # The same as symdiff(S2, S1).
#
issubset(Set({2, 3, 4}), S1)
⊆([2, 3], [1:4])

# Adding elements.
#
push!(S1, 19)                       # The ! indicates that the first argument is modified.

# Testing for membership. This operation is independent of the size of the set.
#
19 in S1
in(19, S1)

# Constructing sets.
#
Set()                               # Empty set of arbitrary type.
Set{Int64}()                        # Empty set of specific type.

# OPERATIONS ==========================================================================================================

# Some of these have already been used above. Check out stuff on Functional Programming for other ways to operate
# on collections.

isempty([])
#
# empty!() will remove all elements from a collection.

length([1, 2, 3])

in(2, [1:3])

eltype([3:5])

indexin([1, 3, 5, 7], rand(1:10, 5))            # See also findin().

unique([1, 2, 2, 2, 3])

extrema([1, -5, 3, -3, 9])

indmax([1, -5, 3, -3, 9])               # See also indmin().
findmax([1, -5, 3, -3, 9])              # See also findmin().

maxabs([9, -13, 5, -1])                 # See also minabs().

count(x -> x > 3, [1, 2, 3, 4, 5])
any(x -> x > 3, [1, 2, 3, 4, 5])
all(x -> x > 3, [1, 2, 3, 4, 5])

first([1:9])
last([1:9])

# ITERATORS ===========================================================================================================

x = [5:8]
y = ['a', 'b', 'c', 'd']

# zip() - combines iterables into tuples.
#
for d in zip(x, y)
    println(d)
end

# enumerate() - generates tuples of form (index, value).
#
for d in enumerate(y)
    println(d)
end

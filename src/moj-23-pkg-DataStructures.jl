# DATA STRUCTURES =====================================================================================================

using DataStructures

# This package implements a number of data structures including:
#
# - Deque
# - Stack
# - Queue
# - Accumulators and Counters
# - Disjoint Sets
# - Binary Heap
# - Mutable Binary Heap
# - Ordered Dicts and Sets
# - Dictionaries with Defaults
# - Trie
# - Linked List
# - Sorted Dict, Sorted Multi-Dict and Sorted Set

# DEQUE ---------------------------------------------------------------------------------------------------------------

# Julia's builtin Vector type provides the same functionality as Deque but the latter grows more efficiently.

x = Deque{Int}()
#
push!(x, 4)				# Add to back
push!(x, 7)
push!(x, 9)
unshift!(x, 1)				# Add to front
#
isempty(x)
length(x)
#
pop!(x)					# Remove from back
shift!(x)				# Remoce from front
#
front(x)				# Peek at item at front
back(x)					# Peek at item at back

# STACK ---------------------------------------------------------------------------------------------------------------

# Stack() implements push!(), top() and pop!().

# QUEUE ---------------------------------------------------------------------------------------------------------------

# Queue() implements enqueue!(), front(), back() and dequeue().

# COUNTER -------------------------------------------------------------------------------------------------------------

cnt = counter(ASCIIString)

push!(cnt, "dogs")			# Add 1 dog
push!(cnt, "cats", 3)			# Add 3 cats
push!(cnt, "cats", 2)			# Add another 2 cats

cnt["cats"]				# How many cats do we have now?

pop!(cnt, "dogs")

# TRIE ----------------------------------------------------------------------------------------------------------------

# More information at https://en.wikipedia.org/wiki/Trie.

trie = Trie{Int}()

trie["amy"]   = 56
trie["ann"]   = 15
trie["emma"]  = 30
trie["rob"]   = 27
trie["roger"] = 52

keys(trie)

# Alternative constructor.
#
trie = Trie(["amy", "ann", "emma", "rob", "roger"], [56, 15, 30, 27, 52])

# SORTED CONTAINERS ---------------------------------------------------------------------------------------------------

# SortedDict, SortedMultiDict, or SortedSet implement a wide range of functionality. They will have to wait for another
# time though!

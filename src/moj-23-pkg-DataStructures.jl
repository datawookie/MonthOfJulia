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

# STACK ---------------------------------------------------------------------------------------------------------------

# Stack() implements push!(), top() and pop!().

stack = Stack(ASCIIString)
#
push!(stack, "First in.")
for n in [2:4]; push!(stack, "... $n"); end
push!(stack, "Last in.")
#
isempty(stack)
length(stack)
#
top(stack)                          # Look at item on top of the stack
#
length(stack)
pop!(stack)                         # Remove item from top of stack
length(stack)

# QUEUE ---------------------------------------------------------------------------------------------------------------

# Queue() implements enqueue!(), front(), back() and dequeue().

queue = Queue(Any);
#
# Items are always added to the back of the queue.
#
enqueue!(queue, "First in.")
for n in [2:4]; enqueue!(queue, n); end
enqueue!(queue, "Last in.")
#
front(queue)                        # Look at item at front of the queue
back(queue)                         # Look at item at back of queue
#
# Items can only be removed from the front of the queue.
#
dequeue!(queue)

# DEQUE ---------------------------------------------------------------------------------------------------------------

# Julia's builtin Vector type provides the same functionality as Deque but the latter grows more efficiently.

x = Deque{Int}()
#
# Items can be added to the front and back of a deque.
#
push!(x, 4)                         # Add to back
push!(x, 7)
push!(x, 9)
unshift!(x, 1)                      # Add to front
#
# Items can be removed from front and back of a deque.
#
pop!(x)                             # Remove from back
shift!(x)                           # Remoce from front
#
front(x)                            # Look at item at front
back(x)                             # Look at item at back

# COUNTER -------------------------------------------------------------------------------------------------------------

cnt = counter(ASCIIString)

push!(cnt, "dog")                   # Add 1 dog
push!(cnt, "cat", 3)                # Add 3 cats
push!(cnt, "cat")                   # Add another cat
push!(cnt, "mouse", 5)              # Add 5 mice

cnt

pop!(cnt, "cat")

cnt["cat"]                          # How many cats do we have now?
cnt["mouse"]                        # But we still have a handful of mice.

# TRIE ----------------------------------------------------------------------------------------------------------------

# More information at https://en.wikipedia.org/wiki/Trie.

trie = Trie{Int}()

trie["amy"]   = 56
trie["ann"]   = 15
trie["emma"]  = 30
trie["rob"]   = 27
trie["roger"] = 52

keys(trie)
haskey(trie, "roger")

get(trie, "roger")
get(trie, "robert")
get(trie, "robert", nothing)

# Alternative constructor.
#
trie = Trie(["amy", "ann", "emma", "rob", "roger"], [56, 15, 30, 27, 52])

# SORTED CONTAINERS ---------------------------------------------------------------------------------------------------

# SortedDict

# SortedMultiDict

# SortedSet

# HEAPS ---------------------------------------------------------------------------------------------------------------

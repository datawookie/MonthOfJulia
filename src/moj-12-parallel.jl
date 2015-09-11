# COROUTINES ==========================================================================================================

# Julia's coroutines are similar to Python's generators. They allow operations to be suspended and then resumed later.
# Coroutines do not run in a separate thread and only one coroutine can be active at any given time. Switching between
# tasks consumes minimal overhead.
#
# Task objects are managed by produce() and consume().

# Since a producer for the Fibonacci Sequence has been used as an example elsewhere, we'll instead us the Lucas
# Sequence (https://en.wikipedia.org/wiki/Lucas_number).
#
function lucas_producer(n)
	a, b = (2, 1)
	for i = 1:n
		produce(a)
		a, b = (b, a + b)
	end
end

# The producer function itself is not very useful, you need to wrap it in a Task, which produces a runnable object.
#
lucas_task = Task(() -> lucas_producer(10))

# Check task state (can be one of :runnable, :waiting, :queued, :done or :failed).
#
lucas_task.state

# The function is activated every time we consume an item from the task, but sleeps in between.
#
consume(lucas_task)
consume(lucas_task)
consume(lucas_task)

# Consuming the output from a producer is easier in a loop. The Task is iterable.
#
for n in lucas_task
	println(n)
end

# The output from a producer need not be bounded and it can offer up a continuous stream of values.
#
function random_producer()
	while true
		produce(rand())
	end
end

# There is also a @task macro for generating tasks.
#
random_task = @task random_producer()

consume(random_task)
consume(random_task)
consume(random_task)

# PARALLEL PROCESSING =================================================================================================

# Information on Parallel Computing in Julia at http://docs.julialang.org/en/latest/manual/parallel-computing/.

# To start julia with multiple workers/processes:
#
# $ julia -p 4
#
# This will create one more process than specified, which corresponds to the main Julia instance. The processes do not
# share memory.
#
nprocs()

workers()                           # Identifiers for the worker processes.
#
# ID 1 is the "main" instance.
#
# More processes can be added using addprocs(), which can actually launch processes on remote machines via SSH.

W1 = workers()[1];

# Launch a process on the first worker. This call returns immediately.
#
P1 = remotecall(W1, x -> factorial(x), 20)

# Retrieve the result. This will block until the worker is finished.
#
fetch(P1)
#
# fetch() and remotecall() can be rolled into one with remotecall_fetch().

# Alternative syntax.
#
P2 = @spawnat W1 factorial(20)
wait(P2)
fetch(P2)
#
# Or, more flexibly, where the worker is chosen by the system.
#
P3 = @spawn factorial(20)
fetch(P3)

# Launching multiple jobs.
#
P4 = [@spawnat w rand() for w in workers()]
map(fetch, P4)
#
# Execute across all available processes. Note that this will use the "main" process as well.
#
@everywhere p = 5
@everywhere println(@sprintf("ID %d: %f %d", myid(), rand(), p))
#
# Since the processes are persistent you can assign variables and define functions in them which retain their values
# between calls. It's good practice to define functions in a separate file, which is then loaded into each of the
# processes.

# INTER_PROCESS COMMUNICATION -----------------------------------------------------------------------------------------

# Communication between processes can be done through a Channel, which is a shared queue of objects. Tantalising as
# this sounds, it'll have to wait for another day.

# PARALLEL LOOP -------------------------------------------------------------------------------------------------------

# Function to estimate Pi by dropping random points onto unit square.
#
function findpi(n)
	inside = 0
	for i = 1:n
		x, y = rand(2)
		if (x^2 + y^2 <= 1)
			inside +=1
		end
	end
	4 * inside / n
end

@time findpi(10000)
@time findpi(100000000)
@time findpi(1000000000)

# The parallel version uses the @parallel macro which takes as its first argument a reduction function.
#
function parallel_findpi(n)
	inside =  @parallel (+) for i = 1:n
		x, y = rand(2)
		x^2 + y^2 <= 1 ? 1 : 0
	end
	4 * inside / n
end

@time parallel_findpi(10000)
@time parallel_findpi(100000000)
@time parallel_findpi(1000000000)

# PARALLEL MAP --------------------------------------------------------------------------------------------------------

pmap(x -> x^2, 1:100)

# CLUSTER COMPUTING ===================================================================================================

# A ClusterManager provides the high level functionality for coordinating tasks across a cluster of Julia instances.

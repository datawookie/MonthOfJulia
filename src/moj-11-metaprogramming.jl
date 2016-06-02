# METAPROGRAMMING =====================================================================================================

# Julia suscribes to the "code is data and data is code" philosophy of Lisp. Data and functions have similar internal
# representations and code can actually just be treated like data (see https://en.wikipedia.org/wiki/Homoiconicity).
#
# metaprogramming = code that writes code.

# SYMBOLS -------------------------------------------------------------------------------------------------------------

# Symbols are a way of referring to variables without actually evaluating the variable. So we are talking about the
# variable itself rather than its value. The concept of symbols is central to metaprogramming, which we'll get to
# later.

n = 5                               # Assign to variable n.
n                                   # Refer to the contents of variable n.
typeof(n)
:n                                  # Refer to the variable n itself (a Symbol is denoted the quote operator, :).
typeof(:n)
eval(:n)

:(n = 7)
n
eval(:(n = 7))
n

# Symbols can be created from strings.
#
symbol("foo")

# EXPRESSIONS ---------------------------------------------------------------------------------------------------------

# This is an expression of type Int64...
1 + 2
# ... but this is an unevaluated expression of type Expr. The quote operator, :, treats its argument as data not code.
:(1 + 2)
# Similarly neither x nor y need to be defined in order for this to be a valid expression.
:(x + y)

# Symbols can also be built from strings.
#
parse("1 + 2")

# Compound quotes.
#
quote
    x = 3.5
    y = pi
    x + y
end
:(x = 3.5; y = pi; x + y)

# Parts of an Expr.
#
E1 = :(2x + y - x^2)
typeof(E1)
#
names(E1)
E1.head
E1.args
E1.typ
#
# The expression consists of some sub-expressions.
#
E1.args[2].args
E1.args[3].args

# Accessing the Abstract Syntax Tree for an Expr.
#
dump(E1)

# An expressions which makes an assignment.
#
E2 = :(x = 7)

# EVALUATING EXPRESSIONS ----------------------------------------------------------------------------------------------

# This produces an error because some of the symbols are not defined.
#
eval(E1)

# But if we define the required symbols, then it works fine.
#
x = 1;
y = 3;
eval(E1)

# Now evaluate expression which does assignment (and hence has side effects).
#
eval(E2)
eval(E1)

# The interpolation operator, $, evaluates components of an expression immediately.
#
E3 = :($x + y)
#
# This is effectively :(7 + y).

# To summarise: quotation operator, :, evaluates when passed to eval; interpolation operator, $, evaluates at
# definition.

# MANIPULATING EXPRESSIONS --------------------------------------------------------------------------------------------

# The magic of metaprogramming is that we can change the contents of the expression programmatically.
#
E1
eval(E1)
E1.args[2].args[1] = :-
E1.args[3] = 5
E1                                  # Note how the expression itself has been modified in two places...
eval(E1)                            # ... and this, of course, affects the result when evaluated.

# We can also build more complex expressions.
#
Expr(:call, :-, E1, 5)

# What about manipulating a function?
#
F = :(x -> x^2)
eval(F)(2)                          # Evaluate x -> x^2 for x = 2
F.args[2].args[2].args[3] = 3       # Change function to x -> x^3
eval(F)(2)                          # Evaluate x -> x^3 for x = 2

# MACROS --------------------------------------------------------------------------------------------------------------

# Macros in Julia...
#
# - are functions which consume expressions;
# - are evaluated during parsing (before compilation);
# - are analogous to C macros which are evaluated by the preprocessor;
# - can producec code which has serious performance advantages over function evaluation.

# Defining macros.
#
macro square(x)
    :($x * $x)
end
#
# Macros are invoked by an @ followed by the macro name.
#
@square(5)
@square 5

# Looking at the expression produced by the macro.
#
macroexpand(:(@square(x)))
macroexpand(:(@square(5)))

# Macro arguments can specify types too.
#
macro number(T)
    quote
        local x = rand($T)
        local y = rand($T)
        x + y
    end
end
@number(Float64)
@number(Int64)

# Useful builtin macros:
#
# @test                             -- Test exact equality.
# @test_approx_eq                   -- Test approximate equality (with variable tolerance).
# @which                            -- Find source code for a method.
# @show                             -- Ouput value of expression and return value of expression.
# @time                             -- Time and memory allocation for expression; return value.
@time sleep(2)
# @timed                            -- Value, time and memory as a tuple.
# @elapsed                          -- Time taken to evaluate expression; discard value. See also tic(), toc() and toq().
@elapsed sleep(2)
# @allocated                        -- Amount of memory allocated in evaluating expression.
# @timed                            -- Results from @time as a tuple
# @async                            -- Execute a task/coroutine asynchronously.
# @task                             -- Convenience macro for creating Tasks.
@task while true; produce(rand()); end
# @spawnat                          -- Evaluate an expression on a specific (parallel) process.
# @spawn                            -- Evaluate an expression on an automatically selected (parallel) process.
# @parallel                         -- Parallel looping.
# @schedule                         -- Convert expression to Task and add to scheduler queue.
# @sync                             -- Wait for other processes (like those spawned by @async) to complete.
# @async                            -- Schedule expression evaluation.
# @vectorize_1arg                   -- Vectorise function with 1 argument.
# @vectorize_2arg                   -- Vectorise function with 2 arguments.
# @printf
# @assert
@assert 1 == 1
# @eval
# @generated
# @code_native
# @unix_only                        -- begin/end block of code only for UNIX environment
# @windows_only                     -- begin/end block of code only for Windows environment
# @inbounds
# @fastmath

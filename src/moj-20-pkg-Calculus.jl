# CALCULUS ============================================================================================================

using Calculus

# NUMERICAL DIFFERENTIATION -------------------------------------------------------------------------------------------

# Evaluate the derivative at a specifid point.
#
derivative(x -> sin(x), pi)
derivative(sin, pi)
#
# Compared to "theoretical" result (remembering that this is the NUMERICAL derivative!).
#
cos(pi)

# There is also a Prime Notation which can be used on univariate functions.
#
f(x) = sin(x)
f'(0.0)
f''(0.0)
f'''(0.0)

# Partial derivatives (for a multivariate function).
#
gradient(x -> sin(x[1]) + cos(x[2]) + exp(x[3]), [0.0, 0.0, 0.0])

# Second derivative.
#
second_derivative(x -> x^3, 1.0)

# Hessian matrix of a multivariate function.
#
hessian(x -> x[1] + x[1] * x[2]^2 + x[2] * x[3]^3, [1.0, 1.0, 1.0])

# Numerical derivative functions.
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

differentiate("sin(x)", :x)
differentiate("sin(x) + exp(-y)", [:x, :y])

# NUMERICAL INTEGRATION -----------------------------------------------------------------------------------------------

integrate(x -> 1 / (1 - x), -1 , 0)
#
# Compare with analytical limits.
#
map(x -> - log(1 - x), [-1, 0])

# Or using Monte Carlo method (:monte_carlon). The default is Simpson's method (:simpsons).
#
integrate(x -> 1 / (1 - x), -1 , 0, :monte_carlo)

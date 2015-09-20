# NLOPT ===============================================================================================================

# This package is based on the NLopt library. Tutorial at http://ab-initio.mit.edu/wiki/index.php/NLopt_Tutorial.

using NLopt

# MATHPROGBASE --------------------------------------------------------------------------------------------------------

# Using MathProgBase interface which gives compatibility with other optimisation packages.

count = 0 # keep track of # function evaluations

# The objective function. The gradient is only required for gradient-based algorithms.
#
# We'll attempt to optimise the function
#
# x[2] / x[1] * sin(x[3]) * cos(x[3])
#
# which characterises the range efficiency of a Trebuchet with
#
#   x[1] = counterweight mass,
#   x[2] = projectile mass and
#   x[3] = initial angle of projectile.
#
function range(x::Vector, grad::Vector)
    if length(grad) > 0
        grad[1] = - sin(x[3]) * cos(x[3]) * x[2] / x[1]^2 
        grad[2] = sin(x[3]) * cos(x[3]) / x[1]
        grad[3] = (2 * cos(x[3])^2 - 1) * x[2] / x[1]
    end

    global count
    count::Int += 1
    println("f_$count($x)")

    sin(x[3]) * cos(x[3]) * x[2] / x[1]
end

# The constraint function is interpreted as ... <= 0.
#
# We'll apply the following constraints to the projectile and counterweight masses:
#
# x[1] / x[2] >= 1          - Counterweight is at least as heavy as projectile
# x[1] / x[2] <= 100        - Counterweight mass is not more than 100x projectile mass
#
# These are transformed to
#
# 0 >= 1 - x[1] / x[2]    = a + b * x[1] / x[2] for a = 1 and b = -1,
# 0 >= -100 + x[1] / x[2] = a + b * x[1] / x[2] for a = -100 and b =  1.
#
function mass_constraint(x::Vector, grad::Vector, a, b)
    if length(grad) > 0
        grad[1] = b / x[2]
        grad[2] = - b * x[1] / x[2]^2
        grad[3] = 0
    end
    a + b * x[1] / x[2]
end

opt = Opt(:LD_MMA, 3)                           # Algorithm and dimension of problem
ndims(opt)
algorithm(opt)
algorithm_name(opt)                             # Text description of algorithm

lower_bounds!(opt, [10, 0.5, 0.])               # Lower bounds on optimisation parameters
upper_bounds!(opt, [1000, 10, pi/2])            # Upper bounds on optimisation parameters

xtol_rel!(opt, 1e-4)                            # Relative tolerance on optimisation parameters

max_objective!(opt, range)                      # Specify objective function

# Apply the inequality constraints (using values for a and b mentioned above).
#
inequality_constraint!(opt, (x, g) -> mass_constraint(x, g,    1, -1), 1e-8)
inequality_constraint!(opt, (x, g) -> mass_constraint(x, g, -100,  1), 1e-8)

initial = [20, 1, pi/8];                        # Initial guess

(maxf,maxx,ret) = optimize(opt, initial)        # Perform optimisation
println("got $minf at $minx after $count iterations (returned $ret)")

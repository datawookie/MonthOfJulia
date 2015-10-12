# OPTIMISATION ========================================================================================================

# Options for optimisation are:
#
# Optim [https://github.com/JuliaOpt/Optim.jl]
# NLopt [https://github.com/JuliaOpt/NLopt.jl]
# JuMP [https://github.com/JuliaOpt/JuMP.jl]
# JuMPeR [https://github.com/IainNZ/JuMPeR.jl]
# Gurobi [https://github.com/JuliaOpt/Gurobi.jl]    --- interface to commercial package [http://www.gurobi.com/]
# CPLEX [https://github.com/JuliaOpt/CPLEX.jl]      --- interface to commercial package
# DReal [https://github.com/dreal/dReal.jl]
# CoinOptServices [https://github.com/JuliaOpt/CoinOptServices.jl]
# OptimPack [https://github.com/emmt/OptimPack.jl]

# NLOPT ===============================================================================================================

# This package is based on the NLopt library. Tutorial at http://ab-initio.mit.edu/wiki/index.php/NLopt_Tutorial.
#
# Algorithms: http://ab-initio.mit.edu/wiki/index.php/NLopt_Algorithms

# https://github.com/JuliaOpt/NLopt.jl
#
using NLopt

count = 0;

# The objective function. The gradient is only required for gradient-based algorithms.
#
# We'll attempt to optimise the function
#
#   sin(x[1]) * cos(x[2])               [sin(α) * cos(β)]
#
function objective(x::Vector, grad::Vector)
    if length(grad) > 0
        grad[1] = cos(x[1]) * cos(x[2])
        grad[2] = - sin(x[1]) * sin(x[2])
    end

    global count
    count::Int += 1
    println("Iteration $count: $x")

    sin(x[1]) * cos(x[2])
end

# The constraint function is interpreted as ... <= 0.
#
# We'll apply the following constraints
#
#   2 * x[1] <= x[2]                    [2α <= β]
#   x[2] <= pi / 2                      [β <= pi/2]
#
# These are transformed to
#
#   0 >= 2 * x[1] - x[2] = a * x[1] + b * x[2] - c     for a = 2, b = -1, c = 0 and
#   0 >= x[2] - pi / 2   = a * x[1] + b * x[2] - c     for a = 0, b = 2, c = pi.
#
function constraint(x::Vector, grad::Vector, a, b, c)
    if length(grad) > 0
        grad[1] = a
        grad[2] = b
    end
    a * x[1] + b * x[2] - c
end

# DERIVATIVE-FREE -----------------------------------------------------------------------------------------------------

opt = Opt(:LN_COBYLA, 2);                       # Algorithm and dimension of problem
ndims(opt)
algorithm(opt)
algorithm_name(opt)                             # Text description of algorithm

lower_bounds!(opt, [0., 0.])                    # Lower bounds on optimisation parameters
upper_bounds!(opt, [pi, pi])                    # Upper bounds on optimisation parameters

xtol_rel!(opt, 1e-6)                            # Relative tolerance on optimisation parameters

max_objective!(opt, objective)                  # Specify objective function

# Apply the constraints.
#
inequality_constraint!(opt, (x, g) -> constraint(x, g, 2, -1, 0), 1e-8)
inequality_constraint!(opt, (x, g) -> constraint(x, g, 0, 2, pi), 1e-8)

initial = [0, 0];                               # Initial guess

(maxf, maxx, ret) = optimize(opt, initial)      # Perform optimisation
println("got $maxf at $maxx after $count iterations.")

# GRADIENT-BASED ------------------------------------------------------------------------------------------------------

count = 0

opt = Opt(:LD_MMA, 2);
ndims(opt)
algorithm(opt)
algorithm_name(opt)

# This time we'll remove the second inequality constraint and replace it with a restrictive upper bound.
#
lower_bounds!(opt, [0., 0.])
upper_bounds!(opt, [pi, pi / 2])

xtol_rel!(opt, 1e-6)

max_objective!(opt, objective)

inequality_constraint!(opt, (x, g) -> constraint(x, g, 2, -1, 0), 1e-8)

(maxf, maxx, ret) = optimize(opt, initial)
println("got $maxf at $maxx after $count iterations.")

# OPTIM ===============================================================================================================

using Optim

function himmelblau(x::Vector)
    (x[1]^2 + x[2] - 11)^2 + (x[1] + x[2]^2 - 7)^2
end

function himmelblau_gradient!(x::Vector, gradient::Vector)
    gradient[1] = 4 * x[1] * (x[1]^2 + x[2] - 11) + 2 * (x[1] + x[2]^2 - 7)
    gradient[2] = 2 * (x[1]^2 + x[2] - 11) + 4 * x[2] * (x[1] + x[2]^2 - 7)
end

function himmelblau_hessian!(x::Vector, hessian::Matrix)
    hessian[1, 1] = 4 * (x[1]^2 + x[2] - 11) + 8 * x[1]^2 + 2
    hessian[1, 2] = 4 * x[1] + 4 * x[2]
    hessian[2, 1] = 4 * x[1] + 4 * x[2]
    hessian[2, 2] = 4 * (x[1] + x[2]^2 -  7) + 8 * x[2]^2 + 2
end

optimize(himmelblau, [2.5, 2.5], method = :nelder_mead)

optimize(himmelblau, [2.5, 2.5], method = :simulated_annealing)

# Using finite difference approximation to the gradient.
#
optimize(himmelblau, [2.5, 2.5], method = :l_bfgs)

# Using analytical gradient.
#
optimize(himmelblau, himmelblau_gradient!, [2.5, 2.5], method = :l_bfgs)

# Finite difference approximations to the Hessian are not considered because they are generally not accurate.
#
optimize(himmelblau, himmelblau_gradient!, himmelblau_hessian!, [2.5, 2.5], method = :newton)

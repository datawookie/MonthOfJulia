# GENETIC ALGORITHMS ==================================================================================================

# Packages to consider:
#
#	- Evolutionary
#	- GeneticAlgorithms

# Source of Evolutionary at https://github.com/wildart/Evolutionary.jl.
# Documentation on Evolutionary at http://evolutionaryjl.readthedocs.org/en/latest/index.html.

# Documentation on GeneticAlgorithms at https://github.com/forio/GeneticAlgorithms.jl.

# EVOLUTIONARY --------------------------------------------------------------------------------------------------------

using Evolutionary

utility = [10, 20, 15, 2, 30, 10, 30, 45, 50];
mass = [1, 5, 10, 1, 7, 5, 1, 2, 10];

# Utility per unit mass.
#
utility ./ mass

function summass(n::Vector{Bool})
    sum(mass .* n)
end

function objective(n::Vector{Bool})
    (summass(n) <= 20) ? sum(utility .* n) : 0
end

# Test total mass and objective functions.
#
summass([false, false, true, false, false, false, false, false, true])
objective([false, false, true, false, false, false, false, false, true])

best, invbestfit, generations, tolerance, history = ga(
    x -> 1 / objective(x),                  # Function to MINIMISE
    9,                                      # Length of chromosome
    initPopulation = collect(randbool(9)),
    selection = roulette,                   # Options: sus
    mutation = inversion,                   # Options:
    crossover = singlepoint,                # Options:
    mutationRate = 0.2,
    crossoverRate = 0.5,
    ɛ = 0.1,                                # Elitism
    debug = false,
    verbose = false,
    iterations = 200,
    populationSize = 50,
    interim = true)

summass(best)
objective(best)
1 / invbestfit

# GENETICALGORITHMS ---------------------------------------------------------------------------------------------------

# Find integers a, b, c and d such that a + 2b + 3c +4d is as close to 30 as possible.
#
# There are obviously numerous solutions to the above problem. A more interesting problem would introduce additional
# constraints on a, b, c and d. However, incorporating these constraints into the GA framework is not trivial. But
# there are ways to do it. See, for example,
#
# - http://www.cs.ru.nl/~elenam/cspga.pdf;
# - "Handling Constraints in Genetic Algorithms using Dominance-Based Tournaments", C. A. Coello and E. Mezura-Montes.

module equalityga

using GeneticAlgorithms

type EqualityEntity <: Entity
    x::Array
    fitness

    EqualityEntity() = new(Array(Int, 4), nothing)
    EqualityEntity(x) = new(x, nothing)
end

# Since we are wanting to minimise fitness, reverse sense of < so that scores closer to zero are better.
#
import Base.isless
#
isless(lhs::EqualityEntity, rhs::EqualityEntity) = lhs.fitness > rhs.fitness

# Initialise a chromosome. For simplicity constrain genes to be between -100 and 100.
#
MODULUS = 101
#
function create_entity(num)
    EqualityEntity(rand(Int, 4) % MODULUS)
end

function fitness(entity)
    score = entity.x[1] + 2 * entity.x[2] + 3 * entity.x[3] + 4 * entity.x[4]
    abs(score - 30)
end

# Generate groups which can be passed to crossover(). Can terminate execution by returning no groups.
#
function group_entities(population)
    println("BEST: ", population[1])

    if population[1].fitness == 0
        return
    end

    # Pair every entity with the best entity.
    for i in 1:length(population)
        produce([1, i])
    end
end

# CROSSOVER
#
function crossover(group)
    child = EqualityEntity()

    nparents = length(group)
    for i in 1:length(group[1].x)
        parent = (rand(Uint) % nparents) + 1
        child.x[i] = group[parent].x[i]
    end

    child
end

# MUTATE
#
PMUTATE = 0.2
#
function mutate(entity)
    rand(Float64) > PMUTATE && return

    element = rand(Uint) % 4 + 1
    entity.x[element] = rand(Int) % MODULUS
end
end

using GeneticAlgorithms

model = runga(equalityga; initial_pop_size = 16)

population(model)

# POSTSCRIPT: A lengthy discussion of various applications of GA can be found here:
#
# http://stackoverflow.com/questions/1538235/what-are-good-examples-of-genetic-algorithms-genetic-programming-solutions.
#
# If I had some time on my hands then I would like to try out a problem like this (http://www.benjoffe.com/holdem), although
# possibly looking at Blackjack or Baccarat rather than Texas Hold'em Poker.

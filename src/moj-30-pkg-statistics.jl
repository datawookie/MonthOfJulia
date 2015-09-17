# STATISTICS ==========================================================================================================



# MAKE MENTION OF http://juliastats.github.io/



# STATSBASE ===========================================================================================================

# The StatsBase package implements further statistical capabilities.

using StatsBase

# Sampling.
#
sample(['a':'z'], 5)                # Sampling (with replacement).
wsample(['T', 'F'], [5, 1], 10)     # Weighted sampling (with replacement).

# INCREMENTAL STATISTICS ==============================================================================================

# Calculating statistics for an (incomplete) stream of data that is being continuously updated.

using StreamStats

average = StreamStats.Mean()
variance = StreamStats.Var()

for x in rand(10)
	update!(average, x)
	update!(variance, x)
	@printf("x = %3.f -> mean = %.3f | variance = %.3f\n", x, state(average), state(variance))
end

# The StreamStats package provides methods for calculating incremental versions of min(), max() and cov(). It also 
# can be used to calculate incremental confidence intervals for Bernoulli and Poisson processes.

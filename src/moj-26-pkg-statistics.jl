# STATISTICS ==========================================================================================================

# Julia Statistics: http://juliastats.github.io/

# There is some builtin support for statistics.
#
x = rand(10);
mean(x)
std(x)

# STATSBASE ===========================================================================================================

# The StatsBase package implements further statistical capabilities.
#
# http://statsbasejl.readthedocs.org/en/latest/

using StatsBase

# Summary statistics.
#
summarystats(x)
describe(x)

# Weighted Statistics.
#
w = WeightVec(rand(1:10, 10));      # A weight vector.
mean(x, w)                          # Weighted mean.
var(x, w)                           # Weighted variance.
std(x, w)                           # Weighted standard deviation.
mean_and_std(x, w)
skewness(x, w)
kurtosis(x, w)

# Quantiles.
#
median(x)                           # Median.
median(x, w)                        # Weighted median.
quantile(x)
nquantile(x, 8)
iqr(x)                              # Inter-quartile range.

# Ranking.
#
ordinalrank(x)
#
# There's also competerank(), denserank() and tiedrank().

# Sampling.
#
sample(['a':'z'], 5)                # Sampling (with replacement).
wsample(['T', 'F'], [5, 1], 10)     # Weighted sampling (with replacement).

# STATSFUNS ===========================================================================================================

using StatsFuns

logistic(-5)
logistic(5)
logit(0.25)
logit(0.75)

softmax([1, 3, 2, 5, 3])

normpdf(0);                         # PDF of Normal distribution
normlogpdf(0);                      # log PDF of Normal distribution
normcdf(0);                         # CDF of Normal distribution
normccdf(0);                        # Complementary CDF of Normal distribution
normlogcdf(0);                      # log CDF of Normal distribution
normlogccdf(0);                     # log Complementary CDF of Normal distribution
norminvcdf(0.5);                    # inverse-CDF of Normal distribution
norminvccdf(0.99);                  # inverse-Complementary CDF of Normal distribution
norminvlogcdf(-0.693147180559945);  # inverse-log CDF of Normal distribution
norminvlogccdf(-0.693147180559945); # inverse-log Complementary CDF of Normal distribution

# INCREMENTAL STATISTICS ==============================================================================================

# Calculating statistics for an (incomplete) stream of data which is being continuously updated.

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

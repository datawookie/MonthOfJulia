# DISTRIBUTIONS =======================================================================================================

# There is builtin functionality for random number generation.
#
srand(359)                          # Set random number seed.
rand()                              # Random number on [0, 1)
rand(3, 4)                          # 3 x 4 matrix of random numbers on [0, 1)
rand(1:10, 3)                       # Sample 3 items from the range 1, ..., 10.
randn(2, 2)                         # 2 x 2 matrix of random numbers from standard Normal

# More information available at http://distributionsjl.readthedocs.org/en/latest/.

using Distributions

# Distribution hierarchy (incomplete!):
#
# Univariate
#   Discrete
#       Bernoulli
#       Binomial
#       Categorical
#       DiscreteUniform
#       Poisson
#   Continuous
#       Beta
#       Cauchy
#       Exponential
#       Normal
#       Uniform
# Multivariate
#   Discrete
#       Multinomial
#   Continuous
#       MvNormal
# Matrixvariate
#   Discrete
#   Continuous
#       Wishart
#
# This is really just a small subset of the MANY distributions which are catered for.

# Methods for the distributions:
#
# length()  - length of each sample
# size()    - shape of each sample
# eltype()  - default data type of each sample
# rand()    - generate one or more samples
# rand!()   - generate one of more samples into pre-allocated space

# Set the RNG seed so that this is reproducible
#
srand(659)

# NORMAL DISTRIBUTION -------------------------------------------------------------------------------------------------

# Required parameters for a Normal Distribution
#
names(Normal)

# Where it fits into the hierarchy
#
super(Normal)

# Create a Normal Distribution object
#
d1 = Normal(1.0, 3.0)
params(d1)
d1.μ
d1.σ

# Generate a vector of samples
#
x = rand(d1, 1000);

# Visual inspection
#
using Gadfly
plot(x = x, Geom.histogram(bincount = 100))

# Generate an array of samples
#
rand(d1, (2, 3))

# Quantiles
#
quantile(d1, [0.05, 0.5, 0.95])
median(d1)

# Mean and Variance
#
mean(d1)
var(d1)
std(d1)

# Evaluating the PDF and CDF...
#
pdf(d1, 1.0)
logpdf(d1, 1.0)
cdf(d1, 1.0)
logcdf(d1, 1.0)
#
# ... and the complementary CDF.
#
ccdf(d1, 1.0)
logccdf(d1, 1.0)

# Log Likelihood (for a set of samples)
#
loglikelihood(d1, [-1 0 0 1 1 1 1 2 2 3])

# TRUNCATED DISTRIBUTIONS ---------------------------------------------------------------------------------------------

# A truncated distribution is derived from another distribution
#
d2 = Truncated(d1, -4.0, 6.0)

x = rand(d2, 1000);

plot(x -> pdf(d2, x), -10, 10)

# Probability of the truncated portion of the distribution
#
d2.tp
#
# And the CDF of the lower and upper bounds.
#
d2.lcdf
d2.ucdf

# UNIFORM DISTRIBUTION ------------------------------------------------------------------------------------------------

d3 = Uniform(0.0, 10.0)

location(d3)
scale(d3)
maximum(d3)
minimum(d3)

# BERNOULLI DISTRIBUTION ----------------------------------------------------------------------------------------------

# Bernoulli Distribution with a success rate of 25%.
#
d4 = Bernoulli(0.25)

rand(d4, 10)

succprob(d4)
failprob(d4)

mean(rand(d4, 1000))

# BINOMIAL DISTRIBUTION -----------------------------------------------------------------------------------------------

# Binomial Distribution with a success rate of 25% for 100 independent trials.
#
d5 = Binomial(100, 0.25)

rand(d5, 10)

ntrials(d5)
succprob(d5)

rand(d5, 100)

# POISSON DISTRIBUTION ------------------------------------------------------------------------------------------------

super(Poisson)

d6 = Poisson(10.0)

rand(d6, 10)

rate(d6)
mean(d6)
var(d6)

# EXPONENTIAL DISTRIBUTION --------------------------------------------------------------------------------------------

d7 = Exponential(0.1)

scale(d7)
rate(d7)
skewness(d7)
kurtosis(d7)

plot(x -> cdf(d7, x), 0, 1)

# BETA DISTRIBUTION ---------------------------------------------------------------------------------------------------

d8 = Beta(10, 1)

plot(x -> pdf(d8, x), 0, 1)

# MULTIVARIATE NORMAL -------------------------------------------------------------------------------------------------

# There are numerous avenues to construct a Multivariate Normal Distribution.
#
d9 = MvNormal([1.0; 2.0], [4.0 -0.5; -0.5 1.0])

length(d9)
size(d9)

mean(d9)
var(d9)
cov(d9)
cor(d9)

pdf(d9, [0; 0])

rand(d9, 10)

# PARAMETER ESTIMATION ------------------------------------------------------------------------------------------------

x = rand(d1, 10000);
#
# Fit distribution to data using Maximum Likelihood.
#
fit(Normal, x)

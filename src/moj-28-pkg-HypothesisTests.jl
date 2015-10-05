# HYPOTHESIS TESTS ====================================================================================================

# https://github.com/JuliaStats/HypothesisTests.jl

using HypothesisTests

# In addition to the functionality used below, the package also implements a Power Divergence Test with a special
# case for the Chi-squared test.

# CREATE DATA ---------------------------------------------------------------------------------------------------------

using Distributions

srand(357)

x1 = rand(Normal(), 1000);
x2 = rand(Normal(0.5, 1), 1000);

x3 = rand(Binomial(100, 0.25), 1000);   # 25% success rate on samples of size 100
x4 = rand(Binomial(50, 0.50), 1000);    # 50% success rate on samples of size 50

x5 = rand(Bernoulli(0.25), 100) .== 1;

# Example data from https://en.wikipedia.org/wiki/Chi-squared_test. Columns are neighbourhoods and rows represent
# numbers of white, blue and no collar workers.
#
x6 = [90 60 104 95; 30 50 51 20; 30 40 45 35];

# Example from https://en.wikipedia.org/wiki/Fisher%27s_exact_test. Columns are genders and rows represent "dieting"
# and "non-dieting".
#
x7 = [1 9; 11 3];

# TESTS ---------------------------------------------------------------------------------------------------------------

# -> One Sample t-Test
#
t1 = OneSampleTTest(x1)
t2 = OneSampleTTest(x2)

t1.t                    # Value of the test statistic.
t1.df                   # Number of Degrees of Freedom.

# -> Two-Sample Block Test

# -> Chi-Squared Test

# -> Binomial Test
#
t3 = BinomialTest(25, 100, 0.25)
t4 = BinomialTest(40, 100, 0.25)
#
t5 = BinomialTest(x5, 0.25)
t6 = BinomialTest(x5, 0.5)

# -> Fisher Exact Test
#
t7 = FisherExactTest(x7[1,1], x7[1,2], x7[2,1], x7[2,2])

# -> Kolmogorov–Smirnov Test

# -> Kruskal-WallisRank Sum Test

# -> Mann Whitney U Test

# -> Sign Test

# -> Wilcoxon Signed Rank Test

# P-VALUES ------------------------------------------------------------------------------------------------------------

# The mean of x1 is not significantly different from zero...
#
pvalue(t1)
#
# ... but the mean of x2 very certainly is!
#
pvalue(t2)

pvalue(t2, tail = :left)            # Not significant.
pvalue(t2, tail = :right)           # Very significant indeed!

pvalue(t5)
pvalue(t6)

pvalue(t7)

# CONFIDENCE INTERVALS ------------------------------------------------------------------------------------------------

# Confidence Interval for t-Test
#
ci(t1, 0.01)                        # α = 0.01
ci(t2)                              # α = 0.05 by default
#
ci(t2, tail = :both)                # Two-sided 95% confidence interval by default
ci(t2, tail = :left)                # One-sided 95% confidence interval (left)
ci(t2, 0.01, tail = :right)         # One-sided 99% confidence interval (right)

# Confidence Interval for Binomial Proportions
#
ci(t5, tail = :both)
ci(t6, 0.01, method = :jeffrey)     # There are numerous options for method

# Confidence Interval for Fisher Exact Test
#
ci(t7)

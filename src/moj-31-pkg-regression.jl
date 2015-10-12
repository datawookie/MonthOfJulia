# REGRESSION ==========================================================================================================

# https://github.com/lindahua/Regression.jl

# Haven't had a look at this package yet, but it looks very promising.

using Regression

# GLM =================================================================================================================

using GLM

# Family	Canonical Link Function
# ------	-----------------------
# Normal	IdentityLink
# Binomial	LogitLink
# Poisson	LogLink

# CREATE DATA ---------------------------------------------------------------------------------------------------------

using Distributions
using DataFrames

points = DataFrame();
points[:x] = rand(Uniform(0.0, 10.0), 500);
points[:y] = 2 + 3 * points[:x] + rand(Normal(1.0, 3.0) , 500);
points[:z] = rand(Uniform(0.0, 10.0), 500);
points[:valid] = 2 * points[:y] + points[:z] + rand(Normal(0.0, 3.0), 500) .> 35;
head(points)

using Gadfly

plot(points, x = :x, y = :y, color = points[:valid], Geom.point())

# LINEAR REGRESSION ---------------------------------------------------------------------------------------------------

# family = Normal()
# link   = IdentityLink()
#
model = glm(y ~ x, points, Normal(), IdentityLink())

# Estimates for coefficients
#
coef(model)

# Standard errors of coefficients
#
stderr(model)

# Covariance of coefficients
#
vcov(model)

# RSS
#
deviance(model)

# Shortcut calls for linear models
#
model = lm(y ~ x, points)
#
# or
#
model = fit(LinearModel, y ~ x, points)

# Plot points along with fitted model
#
plot(points, layer(x = :x, y = predict(model), Geom.line(), Theme(default_color = colorant"black")),
             layer(x = :x, y = :y, color = points[:valid], Geom.point()), Guide.colorkey("Valid"))

# LOGISTIC REGRESSION -------------------------------------------------------------------------------------------------

# Logistic regression using a Probit link function
#
model = glm(valid ~ x + y + z, points, Binomial(), ProbitLink())

# Logistic regression using a Logistic link function
#
model = glm(valid ~ x + y + z, points, Binomial(), LogitLink())

# POISSON REGRESSION --------------------------------------------------------------------------------------------------

# FIND SUITABLE DATA IN RDATASETS

# GLMNet ==============================================================================================================

# GLMNet is a package for fitting generalised linear models via penalised maximum likelihood.
#
# The shrinkage method is selected via parameter α, where
#
# 	α = 0 -> Ridge regression
# 	α = 1 -> Lasso regression (the default).
#
# The strength of the penalty is determined by the (output) parameter λ.
#
# More information on GLMNet can be found at http://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html.
# Mode information on GLMNet package is at https://github.com/simonster/GLMNet.jl.
#
using GLMNet

using RDatasets
#
# Using data for Housing Values in suburbs of Boston.
#
boston = dataset("MASS", "Boston");

# Convert data to an Array.
#
X = array(boston[:,1:13]);
y = array(boston[:,14]);			# Median value of houses in units of $1000

# Fit model for varying values of λ.
#
path = glmnet(X, y)

# Intercepts for each model.
#
path.a0

# Coefficients for each model.
#
path.betas

# Now have we models for a variety of λ, how do we know which one is best? Cross-validation!
#
path = glmnetcv(X, y)

# Extract the average loss across cross-validation runs for each model.
#
path.meanloss

# Which of these gives the smallest loss...
#
indmin(path.meanloss)
#
# ... and what are the corresponding coefficients?
#
path.path.betas[:,indmin(path.meanloss)]

# Put the results together neatly in a DataFrame.
#
DataFrame(variable = names(boston)[1:13], beta = path.path.betas[:,indmin(path.meanloss)])

# RIDGE REGRESSION ----------------------------------------------------------------------------------------------------

# α = 1 by default, but we can select α = 0 (or any other value between 0 and 1 for that matter!).
#
path = glmnet(X, y, alpha = 0)

# OTHER OPTIONS -------------------------------------------------------------------------------------------------------

# There are a range of other optional parameters which allow you to fine tune the performance of GLMNet. Amongst these
# are:
#
# - dfmax and pmax (maximum number of predictors);
# - nlambda, lambda_min_ratio and lambda (values of λ);
# - constraints (upper and lower bounds on each predictor);
# - weights (weight vector for samples).

# LASSO ===============================================================================================================

using Lasso

# LARS ================================================================================================================

# Least angle regression.

using LARS

# KNN =================================================================================================================

using kNN

# REGRESSION TREES ====================================================================================================

using DecisionTree

features = array(points[:, [1, 3]]);
labels = array(points[:,2]);

model = build_tree(labels, features)

predictions = apply_tree(model, features)

nfoldCV_tree(labels, features, 10)

model = build_forest(labels, features, 1, 50)

predictions = apply_forest(model, features)

nfoldCV_forest(labels, features, 1, 50, 10)

# LOESS ===============================================================================================================

using Loess

# RANDOMFERNS =========================================================================================================

using RandomFerns

# NONLINEARREGRESSION =================================================================================================

# Non-linear regression.

using NLreg

# REGTOOLS ============================================================================================================

using RegTools

# OTHER REGRESSION PACKAGES ===========================================================================================

# These packages also have regression functionality:
#
# - Regression (provides a variety of solvers);
# - LinearLeastSquares.

# LOSS ================================================================================================================

# Functions for evaluating various loss metrics.

using Loss

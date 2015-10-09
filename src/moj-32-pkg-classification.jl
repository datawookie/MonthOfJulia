# CLASSIFICATION ======================================================================================================

# The MachineLearning package aims to consolidate present a consistent API to common machine learning algorithms. It is
# in the early stages of development and documentation is sparse.

# The MLBase package provides some handy functionality for machine learning, specifically:
#
#	- data preprocessing;
#	- performance evaluation;
#	- cross-validation; and
#	- model tuning.
#
# Find out more at http://mlbasejl.readthedocs.org/en/latest/index.html
#
using MLBase

# CHOOSE DATA ---------------------------------------------------------------------------------------------------------

using RDatasets
using Distributions

iris = dataset("datasets", "iris");

# Identifier for train/test split.
#
train = rand(Bernoulli(0.75), nrow(iris)) .== 1;

features = convert(Array, iris[:,1:4]);
labels = [n == "versicolor" ? 1 : 0 for n in iris[:Species]];

# LOGISTIC REGRESSION -------------------------------------------------------------------------------------------------

# See file for regression.

# NEURAL NETWORK ------------------------------------------------------------------------------------------------------

# There are at least two packages which implement Neural Networks (BackpropNeuralNet and NeuralNets). Documentation
# for both of these packages is pretty sparse.

# using BackpropNeuralNet
# using NeuralNets

# DECISIONTREE ========================================================================================================

# An extensive introduction to decision trees with Julia at http://bensadeghi.com/decision-trees-julia/.
#
# http://github.com/bensadeghi/DecisionTree.jl

using DecisionTree

# Fit a Decision Tree Classifier.
#
model = build_tree(labels[train], features[train,:]);

# Print tree structure.
#
print_tree(model)

# Prune the tree, merging leaves which have more than 70% combined purity.
#
model = prune_tree(model, 0.7)

# Predict with model and generate performance metrics.
#
predictions = apply_tree(model, features[!train,:])
#
ROC = roc(labels[!train], convert(Array{Int32,1}, predictions))
true_positive_rate(ROC)
true_negative_rate(ROC)
precision(ROC)
recall(ROC)

# Cross Validation.
#
# Run 10-fold cross-validation, pruning trees at 70% combined purity.
#
nfoldCV_tree(labels[train], features[train,:], 0.7, 10)
#
# We can do this more systematically for a range of purities.
#
accuracy_cv = DataFrame();
accuracy_cv[:purity]   = [0.1:0.025:1.0];
accuracy_cv[:accuracy] = map(x -> mean(nfoldCV_tree(labels[train], features[train,:], x, 10)), accuracy_cv[:purity])

using Gadfly

plot(accuracy_cv, x = :purity, y = :accuracy, Geom.point)

# RANDOM FOREST -------------------------------------------------------------------------------------------------------

model = build_forest(labels[train], features[train,:], 3, 50)

predictions = apply_forest(model, features[!train,:])
#
ROC = roc(labels[!train], convert(Array{Int32,1}, predictions))
true_positive_rate(ROC)
true_negative_rate(ROC)

# Cross Validation.
#
nfoldCV_forest(labels[train], features[train,:], 3, 50, 10)

# ADABOOST ------------------------------------------------------------------------------------------------------------

model, coeff = build_adaboost_stumps(labels[train], features[train,:], 5)

predictions = apply_adaboost_stumps(model, coeff, features[!train,:])
#
ROC = roc(labels[!train], convert(Array{Int32,1}, predictions))
true_positive_rate(ROC)
true_negative_rate(ROC)

# Cross Validation.
#
nfoldCV_stumps(labels[train], features[train,:], 5, 10)

# KNN =================================================================================================================

# https://github.com/johnmyleswhite/kNN.jl

using kNN

# SVM =================================================================================================================

# Documentation on SVM package is at https://github.com/JuliaStats/SVM.jl.

using SVM

# The SVM package expects samples in columns and features in rows...
#
X = features';
#
# ... and output variable should be mapped to +-1.
#
y = [n == 1 ? +1 : -1 for n in labels];

# Create SVM model.
#
model = svm(X[:,train], y[train])

# Evaluate the model.
#
predictions = predict(model, X[:,~train]);
ROC = roc(y[~train], convert(Array{Int32,1}, predictions))
true_positive_rate(ROC)
true_negative_rate(ROC)
#
# What about the accuracy?
#
countnz(predict(model, X[:,~train]) .== y[~train]) / sum(!train)

# GRADIENTBOOSTML =====================================================================================================

using GradientBoost

# XGBOOST =============================================================================================================

# https://github.com/antinucleon/XGBoost.jl

using XGBoost
#
# There might be a conflict between predict() in XGBoost and another method, in which case you'll need to restart
# your Julia session and only load XGBoost.

nrounds = 2;

model = xgboost(features[train,:], nrounds, label = labels[train], eta = 1, max_depth = 2)

predictions = predict(model, features[!train,:]);

using Gadfly

plot(x = labels[!train], y = predictions, Geom.boxplot)

# Apply naive threshold
#
predictions = predictions .> 0.5;

ROC = roc(labels[!train], convert(Array{Int32,1}, predictions))
precision(ROC)
recall(ROC)

# ENSEMBLE LEARNING ---------------------------------------------------------------------------------------------------

# Facilities for using a heterogeneous ensemble of learning methods are provided by the Orchestra package.

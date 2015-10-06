# DISTANCES ===========================================================================================================

# Documentation at https://github.com/JuliaStats/Distances.jl

# The package supports a range of distance metrics, amongst which are Euclidean, Cityblock ("Manhattan"), Cosine and
# Mahalanobis.

using Distances

# VECTORS -------------------------------------------------------------------------------------------------------------

x = [1., 2., 3.];
y = [-1., 3., 5.];

# You can calculate the Euclidean distance two ways:
#
evaluate(Euclidean(), x, y)
euclidean(x, y)
#
# The first uses a type name and the evaluate() function, while the second uses a shortcut syntax.

# For a different metric you would then have:
#
evaluate(Cityblock(), x, y)
cityblock(x, y)
#
evaluate(CosineDist(), x, y)
evaluate(Chebyshev(), x, y)

# COLUMNS -------------------------------------------------------------------------------------------------------------

X = [0 1; 0 2; 0 3];
Y = [1 -1; 1 3; 1 5];

# Compute distances between corresponding columns of matrices.
#
colwise(Euclidean(), X, Y)
colwise(Hamming(), X, Y)
colwise(Chebyshev(), X[:,1], Y)
#
# If one of the matrices has only a single column then it is evaluated against each of the columns of the other matrix.

# The column-wise implementations are significantly faster than using a loop.

# PAIR-WISE -----------------------------------------------------------------------------------------------------------

# Compute distances between all pairs of columns from matrices X and Y, producing a matrix where R[i,j] is distance
# between X[:,i] and Y[:,j].
#
pairwise(Euclidean(), X, Y)
pairwise(Euclidean(), X)

# Using different metrics.
#
pairwise(Mahalanobis(eye(3)), X, Y)     # Effectively just the Euclidean metric
pairwise(WeightedEuclidean([1.0, 2.0, 3.0]), X, Y)

# The pair-wise implementations aree also significantly faster than using a loop. In some cases absurdly faster!

# IRIS EXAMPLE --------------------------------------------------------------------------------------------------------

using RDatasets

iris = dataset("datasets", "iris");

# Retain only numeric columns and convert to Array.
#
iris = convert(Array, iris[:,1:4]);
#
# Transpose (required for distance calculations).
#
iris = transpose(iris);

dist_iris = pairwise(Euclidean(), iris);
dist_iris[1:5,1:5]

using Plotly

data = [["z" => dist_iris, "type" => "heatmap"]];
Plotly.plot(data, ["filename" => "iris-heatmap", "fileopt" => "overwrite"])

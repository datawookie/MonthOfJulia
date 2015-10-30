# PACKAGES ============================================================================================================

# A list of registered Julia packages is maintained at http://pkg.julialang.org/.

# Pkg is the interface to the package manager.
#
# More information on it can be found at http://julia.readthedocs.org/en/latest/manual/packages/.

# Update package metadata. This will also update versions of installed packages.
#
Pkg.update()

# List all packages which are available to install.
#
Pkg.available()

# Install a selection of useful packages.
#
Pkg.add("BackpropNeuralNet")
Pkg.add("Bokeh")
Pkg.add("Boltzmann")
Pkg.add("Cairo")
Pkg.add("Calculus")
Pkg.add("Clustering")
Pkg.add("Color")
Pkg.add("ColorBrewer")
Pkg.add("Cpp")
Pkg.add("DASSL")
Pkg.add("DataArrays")
Pkg.add("DataFrames")
Pkg.add("DataFramesMeta")
Pkg.add("DataStructures")
Pkg.add("DecisionTree")
Pkg.add("Distances")
Pkg.add("Distributions")
Pkg.add("Evolutionary")
Pkg.add("EvolvingGraphs")
Pkg.add("ForwardDiff")
Pkg.add("FTPClient")
Pkg.add("FunctionalCollections")
Pkg.add("Gadfly")
Pkg.add("GeneticAlgorithms")
Pkg.add("GeoIP")
Pkg.add("GeoInterface")
Pkg.add("GeoJSON")
Pkg.add("Geodesy")
Pkg.add("GLM")
Pkg.add("GLMNet")
Pkg.add("GoogleCharts")
Pkg.add("GradientBoost")
Pkg.add("GraphCentrality")
Pkg.add("Graphs")
Pkg.add("HDF5")
Pkg.add("HypothesisTests")
Pkg.add("IJulia")
Pkg.add("Images")
Pkg.add("ImageMagick")
Pkg.add("ImageView")
Pkg.add("JSON")
# Pkg.add("kNN")
# Pkg.clone("https://github.com/johnmyleswhite/NearestNeighbors.jl")
# Pkg.clone("https://github.com/johnmyleswhite/kNN.jl")
Pkg.add("Loss")
Pkg.add("LevelDB")
Pkg.add("LIBSVM")
Pkg.add("LightGraphs")
Pkg.add("MachineLearning")
Pkg.add("MLBase")
Pkg.add("MultivariateStats")
Pkg.clone("https://github.com/anj1/NeuralNets.jl")
Pkg.add("NLopt")
Pkg.add("ODBC")
Pkg.add("ODE")
Pkg.add("OpenStreetMap")
Pkg.add("Orchestra")
Pkg.add("PiecewiseAffineTransforms")
Pkg.clone("https://github.com/plotly/Plotly.jl")
Pkg.add("PyCall")
Pkg.add("PyPlot")
Pkg.add("Quandl")
Pkg.add("QuickShiftClustering")
Pkg.add("RandomFerns")
Pkg.add("RCall")
Pkg.add("RDatasets")
Pkg.add("Regression")
Pkg.clone("https://github.com/joemliang/RegTools.jl")
Pkg.add("Requests")
Pkg.add("ReverseDiffSource")
Pkg.add("Rif")
Pkg.add("SIUnits")
Pkg.add("SQLite")
Pkg.add("StatsBase")
Pkg.add("StatsFuns")
Pkg.add("StreamStats")
Pkg.add("Sundials")
Pkg.add("SymPy")
Pkg.add("TestImages")
Pkg.add("TimeSeries")
Pkg.add("Twitter")
Pkg.add("ValidatedNumerics")
Pkg.add("XGBoost")
Pkg.add("Yelp")

# LOADING -------------------------------------------------------------------------------------------------------------

# The using directive will load a package, making all of the exported symbols available in the global namespace.
#
using StatsBase

# INTERROGATING -------------------------------------------------------------------------------------------------------

# List of symbols exported by a package.
#
whos(StatsBase)

# Pkg.installed() returns a dictionary with values giving installed package versions.
#
Pkg.installed()["JSON"]
Pkg.installed("JSON")

# Pkg.status() is similar to Pkg.installed() but breaks the packages down into "required" and "additional" packages.

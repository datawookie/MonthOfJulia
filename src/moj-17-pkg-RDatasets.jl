# RDATASETS ===========================================================================================================

# Documentation at https://github.com/johnmyleswhite/RDatasets.jl.

using RDatasets

# Get a list of supported R packages.
#
RDatasets.packages()

# Get a list of all datasets.
#
sets = RDatasets.datasets();
size(sets)
head(sets)

# Find out what's available in the "vcd" package.
#
RDatasets.datasets("vcd")

# List of packages.
#
sort(unique(sets[:Package]))

# Get a particular data set.
#
women = dataset("datasets", "women")

# RDATASETS ===========================================================================================================

# THIS SHOULD BE ONE OF FIRST!!!

# Documentation at https://github.com/johnmyleswhite/RDatasets.jl.

sets = RDatasets.datasets()

# List of packages.
#
sort(unique(sets[:Package]))

# Find out what's available in the "datasets" package.
#
RDatasets.datasets("datasets")

# Get a particular data set.
#
dataset("datasets", "women")

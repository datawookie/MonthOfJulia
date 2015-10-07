# DATA FRAMES =========================================================================================================

# DataFrame in Julia is analogous to similar contructs in Python/pandas and R.
#
# Documentation at http://dataframesjl.readthedocs.org/en/latest/.

using DataFrames

# Constructing a DataFrame
#
people = DataFrame();
people[:name]   = ["Andrew", "Claire", "Bob", "Alice"];
people[:gender] = [0, 1, 0, 1];
people[:age]    = [43, 35, 27, 32];
people
#
# This could also have been done by passing each column to the constructor.

# Information.
#
names(people)
eltypes(people)
describe(people)                    # Analogous to summary() in R

# Accessing columns and rows.
#
people[:age]
people[2]
people[:,2]
people[1,:]
head(people, 1)
tail(people)

# Changing column data.
#
people[:gender] = ifelse(people[:gender] .== 1, 'F', 'M');
people

# Column operations.
#
people[:age] .<= 40                 # .<= is the element-wise operator
people[:gender] .== 'M'             # .== is the element-wise operator

# Converting to an Array
#
convert(Array, people)
array(people)

# Grouping.
#
by(people, :gender, d -> mean(d[:age]))

# Construcing a DataFrame from a delimited file.
#
passwd = readtable("/etc/passwd", separator = ':', header = false);
names!(passwd, [symbol(i) for i in ["username", "passwd", "UID", "GID", "comment", "home", "shell"]]);
passwd[1:5,:]
#
# Writing to a delimited file is done with writetable().

# A package which provides functionality for missing (NA) data
#
using DataArrays
#
# DataArrays are column vectors generated with @data().
#
x = @data([1, 2, 3, 4, NA, 6])

# Removing columns: use delete!(df, colname) where colname specified as a symbol.

# Deal with missing data by dropping it...
#
dropna(x)
#
# ... or replacing it with another value.
#
convert(Array, x, -1)

# Tests.
#
anyna(x)
allna(x)

# A DataFrame also supports NA.
#
people[:age][2] = NA;
people
mean(people[:age])
mean(dropna(people[:age]))

# METAPROGRAMMING -----------------------------------------------------------------------------------------------------

using DataFramesMeta

# Reference columns using symbols.
#
@with(passwd, maximum(:UID))
#
@with people begin
    :age+3
end

# Let's replace that missing item (with a flattering value).
#
people[:age][2] = 30;

# Select rows and/or columns.
#
@ix(people, :age .> 40)
@ix(people, :age .> 40, [:name, :gender])
#
@where(people, :age .> 40)

# Select and/or transform columns.
#
@select(people, :gender)
@select(people, x = 2 * :age, :name)

# Add columns.
#
@transform(people, x = 2 * :age)

# There are some other features too, like chaining of operations, which appear to still be in a state of development.

# RELATED PACKAGES ====================================================================================================

# JSON     -> JSON data
# LightXML -> XML data
# HDF5     -> HDF5 data


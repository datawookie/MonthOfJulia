# TIMESERIES ==========================================================================================================

using TimeSeries

# GET DATA ------------------------------------------------------------------------------------------------------------

# We'll use data from Quandl. Another option would be the MarketData package.
#
using Quandl

# By default this returns a TimeArray. You can get the data as a DataFrame by using the format = "DataFrame" argument.
#
google = quandl("YAHOO/GOOGL");                     # GOOGL at (default) daily intervals
apple = quandl("YAHOO/AAPL", frequency = :weekly);  # AAPL at weekly intervals
mmm = quandl("YAHOO/MMM", from = "2015-07-01");     # MMM starting at 2015-07-01
rht = quandl("YAHOO/RHT", format = "DataFrame");    # As a DataFrame

# TIMEARRAY -----------------------------------------------------------------------------------------------------------

google

# Fields in the TimeArray type.
#
names(google)

# Time stamps.
#
google.timestamp

# Values.
#
google.values

# Column names.
#
google.colnames

# INDEXING DATA -------------------------------------------------------------------------------------------------------

# Indexing. Numerical indices return rows; alphabetical indices return columns.
#
google[1:5]
google["High"]
google["High","Low"]

# Accessing rows via date.
#
google[Date(2015,8,7)]
google[[Date(2015,8,7), Date(2015,8,12)]]
google[[Date(2015,8,7):Date(2015,8,12)]]
#
# Or another approach.
#
from(google, 2015, 8, 4)        # Data after particular date
to(google, 2015, 8, 4)          # Data before particular date

# Indexing rows and columns together.
#
google["Close"][3:5]

# Identify records for which condition satisfied.
#
findwhen(google["Close"] .> 680)    # Returns Date
findall(google["Close"] .> 680)     # Returns record number

# ELEMENT-WISE OPERATIONS ---------------------------------------------------------------------------------------------

# Operations are applied between records which share the same timestamp.
#
google["Close"] .+ google["Open"]
google["Close"] .- google["Open"]   # Also supported are .* and ./
#
google["Close"] .> google["Open"]   # Also supported are .<, .==, .>= and .<=

# COLUMN-WISE OPERATIONS ----------------------------------------------------------------------------------------------

# Lagging (observations moved forward one day: day N+1 now refers to data from day N. A day is lost off the "old" end
# of the data.
#
lag(google[1:5])

# Leading (observations moved backward one day: day N now refers to data from day N+1. A day is lost off the "new" end
# of the data.
#
lead(google[1:5])
#
# Can shift by more than one day. Same applies to lag().
#
lead(google[1:5], 3)

# Fractional change between successive days. The function percentchange() is something of a misnomer since the values
# have not been converted to %. This is a good thing though because generally you would want a fraction not a %.
#
percentchange(google["Close"])
#
# Can also get log changes.
#
percentchange(google["Close"], method = "log")

# Moving window.
#
moving(google["Close"], mean, 10)
moving(google["Close"], median, 5)

# Accumulation (apply operation on all data up to and including each day).
#
upto(google["Close"], mean)

# MERGING -------------------------------------------------------------------------------------------------------------

# Merge two TimeArray structures using common timestamps.
#
merge(google, mmm)

# COLLAPSING ----------------------------------------------------------------------------------------------------------

# Convert data to longer time frames.
#
collapse(google["Close"], last, period = month)     # Collapse to monthly, using last value for month
collapse(google["Close"], mean, period = week)      # Collapse to weekly, using average value for week

# READING FROM A CSV FILE ---------------------------------------------------------------------------------------------

# readtimearray() is a wrapper around readcsv() which returns a TimeArray structure.

# TIMEARRAY DISPLAY SETTINGS ------------------------------------------------------------------------------------------

# The configuration file .timeseriesrc can be used to set variables DECIMALS and SHOWINT which control the number of
# decimal places to display and whether or not to display integral floats as integers.

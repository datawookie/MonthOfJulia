# SQLITE ==============================================================================================================

using SQLite

# Open a database connection (in this case, create a new database).
#
db = SQLiteDB("passwd.sqlite")

# Create a table and populate it with data.
#
create(db, "passwd", readdlm("/etc/passwd", ':'), ["username", "password", "UID", "GID", "comment", "homedir", "shell"])

# Execute a query on that table.
#
query(db, "select username, homedir from passwd;")

# Close the database.
#
close(db)

# ODBC ================================================================================================================

# https://github.com/quinnj/ODBC.jl

# You'll probably need to restart your Julia session otherwise there will be a clash between query() in ODBC and
# query() in SQLite.
#
using ODBC

# What drivers are available?
#
listdrivers()

# List available DSNs.
#
listdsns()

# Connect to a database using ODBC.connect() where the argument is the DSN for the database.
#
db = ODBC.connect("passwd")

# Get metadata for query.
#
querymeta("select * from passwd limit 5", db)

# Execute query. This currently doesn't work. See https://github.com/quinnj/ODBC.jl/issues/96.
#
query("select * from passwd limit 5", db)

# Close the database.
#
disconnect(db)

# JDBC ================================================================================================================

# https://github.com/aviks/JDBC.jl

# LEVELDB =============================================================================================================

# https://github.com/jerryzhenleicai/LevelDB.jl
# https://github.com/google/leveldb

# Before you can use LevelDB in Julia, you'll need to install the required system library. On Ubuntu this is done using
#
# $ sudo apt-get install libleveldb-dev

using LevelDB

# This creates a database directory.
#
db = open_db("test-database.db", true);

# Insert data
#
db_put(db, "key_string", "Hello!", 6)
#
float_array = Float64[1:4];
db_put(db, "key_float_array", pointer(float_array), length(float_array) * 8)

# Retrieve data
#
db_get(db, "key_string")            # Returns an array of bytes
bytestring(db_get(db, "key_string"))
#
db_get(db, "key_float_array")       # Returns an array of bytes
reinterpret(Float64, db_get(db, "key_float_array"))

close_db(db)

# LMDB ================================================================================================================

# https://github.com/wildart/LMDB.jl

# CLEANUP =============================================================================================================

rm("test-database.db")
rm("passwd.sqlite")

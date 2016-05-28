# Running the contents of this file is not going to be too interesting, I'm afraid.

# STANDARD INPUT AND OUTPUT ===========================================================================================

# Simple output.
#
print(3, " blind "); print("mice!\n")
println("Hello World!")

# Simple input.
#
response = readline();
response

# STDIN, STDOUT and STDERR are defined constant streams.

# Read a character from STDIN.
#
read(STDIN, Char)

# But this will probably not do what you expect... because data read in "canonical binary representation".
#
read(STDIN, Int64)

# Read a full line from a stream.
#
readline(STDIN)
#
# And readbytes() will read a specified number of bytes.

# Output the string "Hello!" along with the length of the string.
#
write(STDOUT, "Hello!")
#
# And now without the string length. This is probably what you want anyway.
#
write(STDOUT, "Hello!")

# FILES ===============================================================================================================

# Opening a file.
#
fid = open("/etc/passwd")
typeof(fid)

# Reading contents of file into an Array of strings.
#
lines = readlines(fid)
#
# To read everything into a single String, use readall().

# We're done, so we close the file.
#
close(fid)

# You can also use eachline() to create a file iterator. Alternatively, read from the file until eof() returns true.

# Shorthand for opening and reading from file. This construct appears to act like a context manager in Python.
#
open("/etc/passwd") do fid
    readlines(fid)
end
#
# Use of eachline() is much more efficient if an operation is to be applied to each line in a file. It avoids the
# burden of having to load every line of the file into memory at once.
#
open("/etc/passwd") do fid
	for line in eachline(fid)
		print("$line")
	end
end

# Writing to a file.
#
filename = tempname()
fid = open(filename, "w")
write(fid, "Some arb text getting shoved into a file for no purpose whatsoever.\n")
println(fid, "More pointless text.")
close(fid)

# DELIMITED FILES =====================================================================================================

# Reading from a delimited file.
#
passwd = readdlm("/etc/passwd", ':');
passwd[1,:]
#
# If it is really a CSV file then you can use readcsv(). Use header==true if there is a header record.

# Writing delimited data is just as easy.
#
writecsv("abbreviated-passwd.csv", passwd[:,[1,6]])
#
# You can use writedlm() for greater control.

# FILE MANIPULATION ===================================================================================================

# Home directory.
#
homedir()

# Current working directory.
#
pwd()
#
# Can use cd() to change the working directory.

# List of files in a directory.
#
readdir()

# Path concatenation.
#
joinpath(homedir(), ".julia")

# Moving and removing.
#
mv(filename, "renamed-temporary-file.txt")
rm("renamed-temporary-file.txt")
rm("abbreviated-passwd.csv")

# There are a host of other file manipulation methods, most of which have names congruent with the UNIX equivalent.
# See http://julia.readthedocs.org/en/latest/stdlib/file/

# EXAMPLE USER TYPE ===================================================================================================

type UserDetails
	username::AbstractString
	password::AbstractString
	UID::Unsigned
	GID::Unsigned
	comment::AbstractString
	homedir::AbstractString
	shell::AbstractString
end

# Note the use of the ... operator to "splat" the array into the constructor arguments.
#
rootuser = UserDetails(passwd[1,:]...)
rootuser.shell

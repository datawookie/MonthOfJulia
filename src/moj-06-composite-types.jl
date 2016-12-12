# COMPOSITE TYPES =====================================================================================================

# Defining a composite type.
#
type GeographicLocation
    latitude::Float64
    longitude::Float64
    altitude::Float64
end

# List default constructors.
#
methods(GeographicLocation)
#
# More information on constructors to be found at http://julia.readthedocs.org/en/latest/manual/constructors/.

# Construct an instance of this type.
#
g1 = GeographicLocation(-30, 30, 15)
typeof(g1)                              # Interrogate type
g2 = typeof(g1)(5, 25, 165)             # Create another object of the same type.

# Define another constructor.
#
GeographicLocation(latitude::Real, longitude::Real) = GeographicLocation(latitude, longitude, 0)
#
g3 = GeographicLocation(-30, 30)

# List and access fields of composite type.
#
fieldnames(g1)
g1.latitude
g1.longitude
g1.latitude = -25                       # Attributes are mutable

# Collections of composite types.
#
locations = [g1, g2, g3]

# Defining an immutable type. Computationally these are more efficient because the code is easier to optimise.
#
immutable PersonData
    firstName::AbstractString
    lastName::AbstractString
    idNumber::BigInt
end

# Attempt to modify immutable type.
#
phil = PersonData("Phillip", "Adams", 7304155126083)
phil.firstName = "Phil"

# Types of fields in type. This is complimentary to names().
#
PersonData.types

# Type aliases.
#
typealias Person PersonData

# Create instance of aliased type.
#
edna = Person("Edna", "Castle", 8005134129081)

# Subtypes can only be derived from abstract types.
#
abstract Mammal
type Cow <: Mammal
end

Mammal()                            # You can't instantiate an abstract type!
Cow()

# PARAMETRIC TYPES ----------------------------------------------------------------------------------------------------

# Complex is an example of a parametric type since it can be composed of elements of different types.
#
typeof(1+2im)                       # Complex{Int64}
typeof(1.0+2.0im)                   # Complex{Float64}

# A parametric type declaration effectively introduces an entire family of types. Note that the parametric type
# definition produces an abstract type, which is then used to create concrete types.
#
# We could restrict the range of applicable types using {T <: Integer}, for example, rather then {T}.
#
type Stack{T}
    stack::Array{T, 1}
    Stack() = new(Array(T, 0))
end

# By analogy, we can also create parametric methods.
#
divide{T}(x::T, y::T) = x / y
#
divide(2, 3)
divide(2, 3.0)          # This won't work because definition takes arguments of same type
#
# And we can specialise to particular types.
#
divide{T <: Integer}(x::T, y::T) = (div(x, y), x % y)

# We can make out GeographicLocation type a little more flexible.
#
type ParametricGeographicLocation{T<:Real}
    latitude::T
    longitude::T
    altitude::T
end

ParametricGeographicLocation(-30, 30, 15)       # T is a Int64
ParametricGeographicLocation(-30.0, 30.0, 15.0)     # T is a Float64

# EXAMPLE: DOCUMENT TYPES =============================================================================================

# Defining an abstract type.
#
abstract Document

# Now define a (concrete) subtype. The more specific one can be with the type constraints, the more efficient this
# type will be. Avoid leaving attributes without a type because then they will default to Any, which is the least
# efficient.
#
type JournalArticle <: Document
    author::Array{AbstractString, 1}
    title::AbstractString
    DOI::String
    journal::String
    year::Unsigned
    volume::Unsigned
    number::Unsigned
end
#
# Two implicit (default) constructors are created automatically.

# Create an additional "outer" constructor.
#
JournalArticle(author, title, journal) = JournalArticle(author, title, "xxx/xxx", journal, 0, 0, 0)

# Create instances of JournalArticle.
#
sunspots = JournalArticle(["Quirin Schiermeier"], "Declining solar activity linked to recent warming", "Nature")
sunspots.DOI = "10.1038/news.2010.519"
networks = JournalArticle(["István A. Kovács", "Albert-László Barabási"], "Destruction perfected", "10.1038/524038a", "Nature", 2015, 0, 524)

# A second subtype. The Book type defines an "inner" constructor which accepts a String (rather than an Array of
# String) for author. An inner constructor creates a new instance of the type using new().
#
# If inner constructors are defined then no default constructors are created.
#
# Inner constructors can be used to enforce additional constraints as illustrated below where it checks that the year
# is a non-negative number.
#
# Outer constructors can be created at any time after a new type has been defined. Inner constructors must all be
# specified when the type is defined. An outer constructor must call one of the inner constructors in order to
# instantiate a new object.
#
type Book <: Document
    author::Array{AbstractString, 1}
    title::AbstractString
    publisher::AbstractString
    year::Int
    #
    # Inner constructor
    #
    function Book(author,title,publisher,year)
        if (year < 0)
            warn("Negative year!")
        end
        new(author, title, publisher, year)
    end
    #
    # This could also be done in short form using the ternary operator.
end

# Create an additional "outer" constructor which accepts a single author name.
#
Book(author::AbstractString, title::AbstractString, publisher::AbstractString, year::Int64) = Book([author], title, publisher, year)

# Create an instance of Book.
#
book = Book("Yann Martel", "Life of Pi", "Knopf Canada", 2001)
Book("Unknown", "Unknown", "Unknown", -57)

# Methods for citations.
#
function citation(doc::JournalArticle)
    @sprintf("%s, '%s', %s, %d.", join(collect(doc.author), ", "), doc.title, doc.journal, doc.year)
end
function citation(doc::Book)
    @sprintf("'%s' by %s (%s, %d)", doc.title, join(collect(doc.author), ", "), doc.publisher, doc.year)
end

# Type display.
#
book                        # The "industrial" look...
function Base.show(io::IO, doc::Document)
    print(io, citation(doc))
end
book                        # ... replaced by a "pretty" look.

# String representation. This is analogous to __str__ in Python.
#
string(doc::Document) = citation(doc)

# The Book and JournalArticle types have many commonalities and we might want to define functions that work on
# both types.
#
DocumentUnion = Union{Book, JournalArticle}

function authors(doc::DocumentUnion)
    join(collect(doc.author), ", ")
end
authors(book)
authors(sunspots)

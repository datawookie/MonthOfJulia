# HTTP ================================================================================================================

# Following some of the examples in the documentation (https://github.com/JuliaWeb/Requests.jl).
#
using Requests

# For a list of APIs which do not require authentication, look at http://tinyurl.com/p63tsnv.

# GET -----------------------------------------------------------------------------------------------------------------

# Look up "Getting started with Julia Programming Language" on Amazon.
#
r1 = get("https://www.googleapis.com/books/v1/volumes"; query = {"q" => "isbn:178328479X"})

r1.status
r1.headers
r1.data
r1.finished

r2 = get("https://maps.googleapis.com/maps/api/geocode/json"; query = {"address" => "Oxford University", "sensor" => "false"})

URL = "https://www.quandl.com/api/v1/datasets/EPI/8.csv"
#
population = readtable(IOBuffer(get(URL).data), separator = ',', header = true);
#
names(population)
#
names!(population, [symbol(i) for i in ["Year", "Industrial", "Developing"]])

# POST ----------------------------------------------------------------------------------------------------------------

# How many times has a URL been posted on Twitter?
#
# Adding some (unnecessary) text data.
#
r3 = post("http://urls.api.twitter.com/1/urls/count.json"; query = {"url" => "http://julialang.org/"}, data = "Quite a few times!")

# Add JSON data payload.
#
r4 = post("http://httpbin.org/post"; json = {"name" => "Claire", "gender" => 'F'})

# There is a selection of means for uploading a file via POST.

# TWITTER =============================================================================================================

# This is much higher level networking.

using Twitter

consumer_key = ENV["CONSUMER_KEY"];
consumer_secret = ENV["CONSUMER_SECRET"];
oauth_token = ENV["OAUTH_TOKEN"];
oauth_secret = ENV["OAUTH_SECRET"];

twitterauth(consumer_key, consumer_secret, oauth_token, oauth_secret)

# THIS CURRENTLY DOES NOT WORK!!!

get_mentions_timeline()

# FTP =================================================================================================================

using FTPClient

ftp_init()
#
# Connect to an anonymous FTP server that allows upload and download.
#
ftp = FTP(host = "speedtest.tele2.net", user = "anonymous", pswd = "hiya@gmail.com")

readdir(ftp)

binary(ftp)                                 # Change transfer mode to BINARY
download(ftp, "1KB.zip", "local-1KB.zip")

cd(ftp, "upload")
ascii(ftp)                                  # Change transfer mode to ASCII
upload(ftp, "papersize", open("/etc/papersize"))

ftp_cleanup()
close(ftp)

# HTTP CLIENT =========================================================================================================

# Other packages for HTTP methods:
#
# HTTPClient (https://github.com/JuliaWeb/HTTPClient.jl)

# Following some of the examples in the documentation (https://github.com/JuliaWeb/Requests.jl).
#
using Requests

# For a list of APIs which do not require authentication, look at http://tinyurl.com/p63tsnv.

# GET -----------------------------------------------------------------------------------------------------------------

# Look up "Getting started with Julia Programming Language" on Amazon.
#
# https://www.googleapis.com/books/v1/volumes?q=isbn:178328479X
#
r1 = get("https://www.googleapis.com/books/v1/volumes"; query = {"q" => "isbn:178328479X"})

r1.status
r1.headers
r1.finished

typeof(r1.data)
Requests.text(r1)                               # Text of JSON payload
Requests.json(r1)["items"][1]["volumeInfo"]     # Parsed JSON

r2 = get("https://maps.googleapis.com/maps/api/geocode/json"; query = {"address" => "Oxford University", "sensor" => "false"})

Requests.json(r2)["results"][1]["geometry"]["location"]

using DataFrames

URL = "https://www.quandl.com/api/v1/datasets/EPI/8.csv"
#
population = readtable(IOBuffer(get(URL).data), separator = ',', header = true);
#
names(population)
#
names!(population, [symbol(i) for i in ["Year", "Industrial", "Developing"]]);
#
head(population)

using Plotly

data = [
  [
    "x" => map(string, population[:Year]),
    "y" => population[:Industrial],
    "type" => "scatter"
  ]
]
Plotly.plot(data, ["filename" => "population-time-series", "fileopt" => "overwrite"])



# POST ----------------------------------------------------------------------------------------------------------------

# How many times has a URL been posted on Twitter?
#
# Adding some (unnecessary) text data.
#
r3 = post("http://urls.api.twitter.com/1/urls/count.json"; query = {"url" => "http://julialang.org/"}, data = "Quite a few times!")

Requests.json(r3)

# Add JSON data payload.
#
r4 = post("http://httpbin.org/post"; json = {"name" => "Reginald", "gender" => 'M'})

# There is a selection of means for uploading a file via POST.

# STREAMING -----------------------------------------------------------------------------------------------------------

# HTTP SERVER =========================================================================================================

using HttpServer

using Mux

# Check out http://iaindunning.com/blog/sudoku-as-a-service.html

# YELP ================================================================================================================

using Yelp

# TWITTER =============================================================================================================

# This is much higher level networking.

using Twitter

consumer_key = ENV["CONSUMER_KEY"];
consumer_secret = ENV["CONSUMER_SECRET"];
oauth_token = ENV["OAUTH_TOKEN"];
oauth_secret = ENV["OAUTH_SECRET"];

twitterauth(consumer_key, consumer_secret, oauth_token, oauth_secret)

mentions = get_mentions_timeline();
mentions = DataFrame(mentions);

names(mentions)

retweets = DataFrame(get_retweets_of_me());

# AWS =================================================================================================================

using AWS

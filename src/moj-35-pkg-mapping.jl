# OPENSTREETMAP =======================================================================================================

# http://github.com/tedsteiner/OpenStreetMap.jl

using OpenStreetMap
using Requests

minLon = 30.8821;
maxLon = minLon + 0.05;
minLat = -29.8429;
maxLat = minLat + 0.05;

const MAPFILE = "map.osm";
const PNGFILE = "map.png";

URL = "http://overpass-api.de/api/map?bbox=$(minLon),$(minLat),$(maxLon),$(maxLat)"

osm = get(URL)
save(osm, MAPFILE)

# Read the map file and display some statistics.
#
nodes, highways, buildings, features = getOSMData(MAPFILE);
println("Number of nodes: $(length(nodes))")
println("Number of highways: $(length(highways))")
println("Number of buildings: $(length(buildings))")
println("Number of features: $(length(features))")

bounds = getBounds(parseMapXML(MAPFILE))

# By default the coordinates are in Latitude-Longitude-Altitude (LLA) system.

# Convert to East-North-Up (ENU) coordinates. This will give a map with coordinates in metres.
#
# reference = center(bounds);
# nodes = ENU(nodes, reference);
# bounds = ENU(bounds, reference);

roads = roadways(highways);
building_class = classify(buildings)
feature_class = classify(features)

fieldnames(OpenStreetMap.Feature)
features                                        # Dictionary of features.
highways                                        # Dictionary of roads.
highways[41571088]                              # Data for specific road.

const WIDTH = 800;

plotMap(nodes,
        highways = highways,
        buildings = buildings,
        features = features,
        bounds = bounds,
        width = WIDTH,
        roadways = roads)

aspect = (bounds.max_y - bounds.min_y) / (bounds.max_x - bounds.min_x);

Winston.savefig(PNGFILE, width = WIDTH, height = int(WIDTH * aspect))

rm(MAPFILE)                                     # Cleanup

# GEOIP ===============================================================================================================

# https://github.com/JuliaWeb/GeoIP.jl

# using GeoIP

# GEOINTERFACE ========================================================================================================

# https://github.com/JuliaGeo/GeoInterface.jl

# using GeoInterface

# GEOJSON =============================================================================================================

# https://github.com/JuliaGeo/GeoJSON.jl

# using GeoJSON

# GEODESY =============================================================================================================

# https://github.com/JuliaGeo/Geodesy.jl

# using Geodesy

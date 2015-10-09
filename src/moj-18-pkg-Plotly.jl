# PLOTLY ==============================================================================================================

# Documented at https://plot.ly/julia/ and https://github.com/plotly/Plotly.jl.

using Plotly

# The first time that you use the API you can configure your plot.ly credentials using
#
# Plotly.set_credentials_file({"username" => "your_username", "api_key" => "0smxffp7z3"})
#
# This will store them for future sessions in ~/.plotly/.credentials.
#
# You can find your API key at https://plot.ly/settings/api.

# Plotly has support for a wide range of plot types, a sample of which are considered below.

# BASIC LINE PLOT -----------------------------------------------------------------------------------------------------

p1 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "markers"];
p2 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "lines"];
p3 = ["x" => 1:10, "y" => rand(0:20, 10), "type" => "scatter", "mode" => "lines+markers"];

Plotly.plot([p1, p2, p3], ["filename" => "basic-line", "fileopt" => "overwrite"])
#
# You can manually open the URL returned by the previous command or do it automatically.
#
Plotly.openurl(ans["url"])
#
# Note: That will only work in the interactive terminal. It will fail with an error if this is run as a script.

# There are many more bells and whistles which can be applied to these plots like:
#
# - colouring and style for markers;
# - various line shapes (linear, spline, steps and others);
# - text for mouseover tooltips.

# POLAR CHARTS --------------------------------------------------------------------------------------------------------

θ = [0:100] / 50 * pi
cardiod = [
  "r" => 2 * (1 + cos(θ)),
  "t" => θ / pi * 180,
  "mode" => "lines",
  "name" => "Cardiod",
  "marker" => ["color" => "none", "line" => ["color" => "peru"]],
  "type" => "scatter"
]
θ = [0:150] / 50 * pi
sextic = [
  "r" => 4 * cos(θ/3).^3,
  "t" => θ / pi * 180,
  "mode" => "lines",
  "name" => "Cayley's Sextic",
  "marker" => ["color" => "none", "line" => ["color" => "orangered"]],
  "type" => "scatter"
]
layout = [
  "title" => "Polar Curves",
  "font" => [
    "family" => "Arial, sans-serif;",
    "size" => 12,
    "color" => "#000"
  ],
  "showlegend" => true,
  "width" => 500,
  "height" => 400,
  "margin" => ["l" => 40, "r" => 40, "b" => 20, "t" => 40, "pad" => 0],
  "paper_bgcolor" => "rgb(255, 255, 255)",
  "plot_bgcolor" => "rgb(255, 255, 255)",
  "orientation" => -90
]
Plotly.plot([cardiod, sextic], ["layout" => layout, "filename" => "polar-curves", "fileopt" => "overwrite"])

# TIME SERIES ---------------------------------------------------------------------------------------------------------

using Quandl

google = quandl("YAHOO/GOOGL", format="DataFrame")

data = [
  [
    "x" => map(string, google[:Date]),
    "y" => google[:Adjusted_Close],
    "type" => "scatter"
  ]
]
Plotly.plot(data, ["filename" => "google-time-series", "fileopt" => "overwrite"])

# BUBBLE CHARTS -------------------------------------------------------------------------------------------------------

using ColorBrewer
using Colors
using StatsBase

accent = map(n -> "#"*hex(n), palette("Accent", 8));

npoints = 50 

blobs = [
  "x" => rand(npoints),
  "y" => rand(npoints),
  "mode" => "markers",
  "marker" => [
    "color" => sample(accent, npoints),
    "size" => rand(npoints) * 30,
    "opacity" => rand(npoints)
  ],
  "type" => "scatter"
]

Plotly.plot([blobs], ["layout" => ["showlegend" => false], "filename" => "bubblechart", "fileopt" => "overwrite"])

# 3D SCATTER PLOTS ----------------------------------------------------------------------------------------------------

# To get this working you will need to ensure that you have hardware acceleration enabled for your browser and that
# WebGL works.

using DataFrames

npoints = 200

sphere = DataFrame();
sphere[:theta] = rand(npoints) * pi;
sphere[:phi]   = rand(npoints) * 2pi;
sphere[:x]     = sin(sphere[:theta]) .* cos(sphere[:phi]);
sphere[:y]     = sin(sphere[:theta]) .* sin(sphere[:phi]);
sphere[:z]     = cos(sphere[:theta]);

p1 = [
    "x" => sphere[:x],
    "y" => sphere[:y],
    "z" => sphere[:z],
    "mode" => "markers",
    #
    # Markers are pale red circles with a blue border.
    #
    "marker" => [
        "color" => "rgb(220, 50, 50)",
        "size" => 12,
        "symbol" => "circle",
        "opacity" => 0.5,
        "line" => [
            "color" => "rgba(0, 0, 200, 0.5)",
            "width" => 2
        ],
    ],
    "type" => "scatter3d"
];
layout = ["margin" => ["l" => 0, "r" => 0, "b" => 0, "t" => 0]];

Plotly.plot([p1], ["layout" => layout, "filename" => "3D Scatter Plot", "fileopt" => "overwrite"])

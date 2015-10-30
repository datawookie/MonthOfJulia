# PLOTTING ============================================================================================================

# There are a number of packages for plotting in Julia:
#
#	- PyPlot (based on the Python matplotlib package which provides MATLAB-like functionality)
#	  https://github.com/stevengj/PyPlot.jl
#
#	- Winston
#	  https://github.com/nolta/Winston.jl
#
#	- Gadfly (based on principles of the Grammar of Graphics)
#	  http://gadflyjl.org/
#
#   - Bokeh
#
#   - Plotly
#
#   - Gaston

# GADFLY ==============================================================================================================

using Gadfly
using Cairo

# SIMPLE PLOTS --------------------------------------------------------------------------------------------------------

# Scatter plot in new browser window/tab.
#
plot(x = rand(10), y = rand(10))

# Random walk with smoothing
#
plot(x = 1:100, y = cumsum(rand(100) - 0.5), Geom.point, Geom.smooth)

# Plot functions.
#
plot(x -> x^3 - 9x, -5, 5)
plot([sin, cos], 0, 6)
#
damped_sin = plot([x -> sin(x) / x], 0, 50)

# Save as SVG and PNG files.
#
draw(SVG("damped-sin.svg", 12inch, 8inch), damped_sin)
draw(PNG("damped-sin.png", 800px, 400px), damped_sin)

# This is rather nice: unlike ggplot2 we do not have to pass in a data frame. We can simply use a vector.
#
plot(x = rand(1000), y = rand(1000), Geom.point)

# GET SOME DATA -------------------------------------------------------------------------------------------------------

# But, of course, for real data a DataFrame is better. We'll use data from RDatasets package.
#
using RDatasets

# POINTS --------------------------------------------------------------------------------------------------------------

# Plot points of language score versus IQ.
#
plot(dataset("MASS", "nlschools"), x="IQ", y="Lang", Geom.point)

# Colour points.
#
plot(dataset("MASS", "nlschools"), x="IQ", y="Lang", color="COMB", Geom.point)

# Add in linear fits.
#
plot(dataset("MASS", "nlschools"), x="IQ", y="Lang", color="COMB", Geom.point,
                                                                   Geom.smooth(method=:lm),
                                                                   Guide.colorkey("Multi-Grade Class"))

# Another example.
#
nuclear = dataset("boot", "nuclear");
plot(nuclear, x=:Date, y=:Cost, Geom.point)
#
# This doesn't do what we want.
#
plot(nuclear, x=:Date, y=:Cost, color=:CT, Geom.point)
#
# Redefine the column indicating presence of a Cooling Tower...
#
nuclear[:CT] = ifelse(nuclear[:CT] .== 1, "Y", "N");
#
# ... and try again, now changing colors and improving label on legend.
#
plot(nuclear, x=:Date, y=:Cost, color=:CT, Geom.point, Scale.color_discrete_manual("blue", "red"), Guide.colorkey("Cooling Tower"))

# BOX PLOT ------------------------------------------------------------------------------------------------------------

plot(dataset("ISLR", "Weekly"), x = :Year, y = :Today, Geom.boxplot)

# HISTOGRAM -----------------------------------------------------------------------------------------------------------

chemscore = dataset("mlmRev", "Chem97");

plot(chemscore, x="GCSEScore", color="Gender", Geom.histogram(bincount = 20))

# PLOTTING FUNCTIONS --------------------------------------------------------------------------------------------------

plot([sin, cos, tan], 0, 20, Scale.y_continuous(maxvalue = 1, minvalue = -1))

# PLOT LAYERS ---------------------------------------------------------------------------------------------------------

# Gadfly can plot multiple layers. You'll see more examples when we look at regression techniques.

plot(layer(x=0:10, y=rand(11), Geom.point),
     layer(x=[0:0.5:10], y=rand(21), Geom.line))

# HEATMAP -------------------------------------------------------------------------------------------------------------

# spy()

# CLEANUP -------------------------------------------------------------------------------------------------------------

for f in ["damped-sin.svg", "damped-sin.png"]
	rm(f)
end

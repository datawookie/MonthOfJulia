# BOKEH ===============================================================================================================

using Bokeh

# SIMPLE SINUSOID ----------------------------------------------------------------------------------------------------

# By default we will open plots in a browser.
#
autoopen(true)

x = linspace(0, pi);
y = cos(2 * x);
plot(x, y, title = "Cosine")

# COMPOSING PLOTS -----------------------------------------------------------------------------------------------------

# Plot a series of functions over a given domain.
#
# More information on glyphs can be gleaned from https://github.com/bokeh/Bokeh.jl/blob/master/src/glyphs.jl.
#
glyphs = [
	Glyph(:Line, linecolor = "red", linewidth = 2), 
	Glyph(:Circle, fillcolor = "rgba(0, 200, 200, 0.4)", size = 6, linecolor = "transparent"), 
	Glyph(:Square, fillcolor = "green", size = 8)
	]
plot([x -> x, x -> x^2, x -> x^3], -1:1, glyphs, title = "Polynomials")

# PLOT TO FILE --------------------------------------------------------------------------------------------------------

# Send output to a file.
#
plotfile("polynomial-functions.html")

# ro = red circle
#
plot(x -> x, -1:1, "ro")

# Keep original plot and just add the next plot to the same axes.
#
hold(true)

# bs = blue square
#
plot(x -> x^2, -1:1, "bs")

hold(true)

# g* = green star
#
plot(x -> x^3, -1:1, "g*")

# Now open that file.
#
showplot()

# CLEANUP =============================================================================================================

rm("polynomial-functions.html")

# PYPLOT ==============================================================================================================

# https://github.com/stevengj/PyPlot.jl

# Pyplot creates plots in a new window rather than the browser.

using PyPlot

θ = linspace(0, 2pi);

plot(θ, cos(2θ) + 1, linewidth = 2.0, linestyle = "--")
title("Cosine curve")
#
xlabel("theta")                     # Unicode symbols don't seem to be supported right now.
ylabel("f(theta)")

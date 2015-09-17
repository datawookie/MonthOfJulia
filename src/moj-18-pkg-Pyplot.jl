# PYPLOT ==============================================================================================================

# Pyplot creates plots in a new window rather than the browser.

using PyPlot

θ = linspace(0, 2pi);

plot(θ, cos(2θ) + 1, linewidth=2.0, linestyle="--")
title("Cosine curve")
#
# CAN WE GET UNICODE SYMBOLS (OR ANOTHER WAY TO GET SYMBOLS???) ONTO AXIS LABELS???
#
xlabel("x")
ylabel("f(x)")






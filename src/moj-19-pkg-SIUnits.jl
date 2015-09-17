# SIUNITS =============================================================================================================

# This package will bring joy to the hearts of all Physical Scientists. Or, acually, all Scientists.

# More documentation at https://github.com/Keno/SIUnits.jl.

using SIUnits
using SIUnits.ShortUnits

# Supports normal arithmetic operations.
#
1KiloGram + 2kg
4Meter / 2m					# Note that it only recognises the American spelling here.
#
# Compatible units can be mixed.
#
1m + 5cm
#
# But, thankfully, you cannot add/subtract incompatible units.
#
1m + 2kg

# Units are expressed in terms of the base SI units, specifically:
#
# A - Ampere
# cd - Candela
# K - Kelvin
# kg - kilogram
# m - metre
# mol - Mole
# s - second
#
1N						# Force
1N/m^2						# Pressure
1N*s						# Impulse

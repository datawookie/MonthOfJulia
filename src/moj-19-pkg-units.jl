# SIUNITS =============================================================================================================

# This package will bring joy to the hearts of all Physical Scientists. Or, actually, all Scientists.

# More documentation at https://github.com/Keno/SIUnits.jl.

using SIUnits
using SIUnits.ShortUnits

# Supports normal arithmetic operations.
#
1KiloGram + 2kg
4Meter / 2m                         # Note that it only recognises the American spelling (Meter not Metre!)
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
1N                                  # Force
1N/m^2                              # Pressure
1N*s                                # Impulse

# Defining new units.
#
Micron = SIUnits.NonSIUnit{typeof(Meter),:µm}()
import Base.convert
convert(::Type{SIUnits.SIQuantity},::typeof(Micron)) = Micro*Meter
1Micron + 1m
#
Angstrom = SIUnits.NonSIUnit{typeof(Meter),:Å}()
convert(::Type{SIUnits.SIQuantity},::typeof(Angstrom)) = Nano/10*Meter
5200Angstrom                        # Green light

# PHYSICAL ============================================================================================================

# Physical provides a slight different approach to units. It's not as performant as SIUnits but it provides a wider
# range of functionality.

using Physical

Inch = DerivedUnit("in", 0.0254*Meter)
Pound = DerivedUnit("lb", 0.45359237*Kilogram)

asbase(66Inch)
asbase(139Pound)

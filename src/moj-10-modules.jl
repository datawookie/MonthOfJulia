# MODULES =============================================================================================================

# A module is associated with a separate namespace.

# Default modules:
#
#	- Main
#	- Core
#	- Base

# Defining a new module.
#
module AfrikaansModule
__init__() = println("Initialising the Afrikaans module.")
greeting() = "Goeie môre!"
bonappetit() = "Smaaklike ete"
export greeting
end

module ZuluModule
greeting() = "Sawubona!"
bonappetit() = "Thokoleza ukudla"
end

# This will not work.
#
greeting()
#
# But these will.
#
AfrikaansModule.greeting()
ZuluModule.greeting()

# Find out which definitions are exported.
#
whos(AfrikaansModule)
whos(ZuluModule)
#
# Note that only AfrikaansModule has exported the greeting() function.

# Load exported definitions into global namespace.
#
using AfrikaansModule
greeting()

# Load functions which have not been exported.
#
import ZuluModule.bonappetit
bonappetit()

# MODULE FILES ========================================================================================================

# Modules are typically stored in a separate file which is then loaded explicitly via include() or require(), or
# implicitly via using.

# The variable LOAD_PATH is a list of directories which are searched for files.

# Modules are compiled when they are first loaded.

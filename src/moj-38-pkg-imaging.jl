# TESTIMAGES ==========================================================================================================

# https://github.com/timholy/TestImages.jl

using TestImages

# List of images in package.
#
readdir(joinpath(homedir(), ".julia/v0.4/TestImages/images/"))

# Load Lena.
#
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
# WHO THE HELL IS LENA???
#
lena = testimage("lena_color_256.tif")

# CHECK OUT THIS ARTICLE.
#
Needell, D., and Ward, R. "Stable image reconstruction using total variation minimization." SIAM Journal on Imaging Sciences 6.2 (2013): 1035-1058.

# IMAGEVIEW ===========================================================================================================

# https://github.com/timholy/ImageView.jl

using ImageView

view(lena)

# IMAGES ==============================================================================================================

# https://github.com/timholy/Images.jl

using Images

# IMAGEMAGICK =========================================================================================================

# https://github.com/JuliaIO/ImageMagick.jl

using ImageMagick

# PIECEWISEAFFINETRANSFORMATIONS ======================================================================================

# https://github.com/dfdx/PiecewiseAffineTransforms.jl

using PiecewiseAffineTransforms

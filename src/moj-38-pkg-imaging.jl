# TESTIMAGES ==========================================================================================================

# https://github.com/timholy/TestImages.jl

using TestImages

# List of images in package.
#
readdir(joinpath(homedir(), ".julia/v0.4/TestImages/images/"))

# Load Lena.
#
# The archetypical test image (Lena Söderberg, https://en.wikipedia.org/wiki/Lenna)
#
lena = testimage("lena_color_256.tif")

# IMAGEVIEW ===========================================================================================================

# https://github.com/timholy/ImageView.jl

using ImageView

view(lena)

# IMAGES ==============================================================================================================

# https://github.com/timholy/Images.jl

using Images
using Colors

earth = imread(joinpath(homedir(), ".julia/v0.4/TestImages/images/earth_apollo17.jpg"))
#
#
# Functions for writing images are imwrite() and writemime().

colorspace(earth)
height(earth)
width(earth)

earth_data = data(earth)

earth_rgb = separate(earth)
#
# Channels can be recombined as follows:
#
convert(Image{RGB}, earth_rgb);

earth_array = convert(Array, earth)

# Color conversion.
#
lena_gray = convert(Image{Gray}, lena)

# Kernel functions.
#
gaussian2d(1, [3, 5])
imaverage([3, 3])                                           # Like manual kernel above
#
# Numerous other kernels available.

# Filtering.
#
lena_smooth = imfilter(lena, imaverage([3, 3]))             # Kernel filter via FIR
#
# There is an optional argument which determines how the boundaries are handled. Options are "replicate" (default),
# "circular", "reflect" and "symmetric".
#
lena_very_smooth = imfilter_fft(lena, ones(10, 10) / 100)   # Kernel filter via FFT
#
lena_gauss_smooth = imfilter_gaussian(lena, [1, 2])         # Filter with multivariate Gaussian

# Edge detection. Various algorithms available: sobel, prewitt, ando3 etc.
#
(lena_sobel_x, lena_sobel_y) = imgradients(lena, "sobel");
#
lena_sobel_x                                                # Horizontal gradients
lena_sobel_y                                                # Vertical gradients

magnitude(lena_sobel_x, lena_sobel_y);                      # Magnitude of gradient images
phase(lena_sobel_x, lena_sobel_y);                          # Rotation angle of gradient images
orientation(lena_sobel_x, lena_sobel_y);
#
# imedge() is a convenience function which calculates many of these in a single call.

# Morphology.
#
lena_dilate = dilate(lena);
lena_erode = erode(lena);
#
# opening() and closing() are combinations of dilate() and erode().

# Need to clamp the values in the two Sobel arrays because some of them extend beyond the range [0, 1] which is used
# for image content.
#
imwrite(lena_sobel_x, "lena-sobel-x.png", mapi = mapinfo(Clamp, lena_sobel_x))
imwrite(lena_sobel_y, "lena-sobel-y.png", mapi = mapinfo(Clamp, lena_sobel_y))
imwrite(lena_dilate, "lena-dilate.png")
imwrite(lena_erode, "lena-erode.png")

# IMAGEMAGICK =========================================================================================================

# https://github.com/JuliaIO/ImageMagick.jl

using ImageMagick

# PIECEWISE AFFINE TRANSFORMATIONS ====================================================================================

# https://github.com/dfdx/PiecewiseAffineTransforms.jl

using PiecewiseAffineTransforms

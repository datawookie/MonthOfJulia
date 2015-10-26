# FOURIER TECHNIQUES ==================================================================================================

# https://www.youtube.com/watch?v=1iBLaHGL1AM

# http://docs.julialang.org/en/release-0.4/stdlib/math/

using Color
using Gadfly

# FFT IN 1D -----------------------------------------------------------------------------------------------------------

f = [abs(x) <= 1 ? 1 : 0 for x in -5:0.1:5];
length(f)

# f = sin((0:127) * pi / 8) + rand(128);

F = fft(f);
typeof(F)
length(F)
#
# Re-arrange positive/negative frequencies.
#
F = fftshift(F);

# Plot signal in the time domain.
#
plot(x = -5:0.1:5, y = f, Guide.xlabel("t [s]"), Guide.ylabel("f(t)", orientation = :vertical), Geom.line)

# Plot amplitude spectrum.
#
plot(x = -5:0.1:5, y = abs(F), Geom.line,
    Guide.xlabel("f [Hz]"), Guide.ylabel("Amplitude", orientation = :vertical))
#
# Plot power spectrum.
#
plot(x = -5:0.1:5, y = 10 * log10(abs(F).^2), Geom.line,
    Guide.xlabel("f [Hz]"), Guide.ylabel("Power [dB]", orientation = :vertical))
#
# Plot phase spectrum.
#
plot(x = -5:0.1:5, y = angle(F), Geom.line,
    Guide.xlabel("f [Hz]"), Guide.ylabel("Phase", orientation = :vertical))

# DCT IN 1D -----------------------------------------------------------------------------------------------------------

# Discrete Cosine Transform (DCT) implemented by dct().

# EXECUTION PLANS -----------------------------------------------------------------------------------------------------

# Generate plans for applying optimised FFT to specific input using plan_fft().

# plan = plan_fft(f, 1, FFTW.MEASURE)
# FFTW.forget_wisdom()
# plan = plan_fft(f, 1, FFTW.ESTIMATE)

# FFT IN 2D (IMAGE) ---------------------------------------------------------------------------------------------------

using TestImages

# 2D Fourier Transform of an image.
#
f = map(Float32, Images.raw(testimage("moonsurface")))
f -= mean(f)

F = fft(f);
F = fftshift(F);

spy(10 * log10(abs(F)^2))
spy(angle(F))

# FFT IN 2D (FUNCTION) ------------------------------------------------------------------------------------------------

# 2D sinc() function.
#
f = [(r = sqrt(x^2 + y^2); sinc(r)) for x in -6:0.125:6, y in -6:0.125:6];

typeof(f)
size(f)

spy(f)

F = fft(f);
typeof(F)
F = fftshift(F);

spy(abs(F), Guide.colorkey("Amplitude"))
spy(10 * log10(abs(F)^2), Guide.colorkey("Power [dB]"))
spy(angle(F) / pi, Guide.colorkey("Phase [π]"))

# NFFT ================================================================================================================

using NFFT

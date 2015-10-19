# FOURIER TECHNIQUES ==================================================================================================

# https://www.youtube.com/watch?v=1iBLaHGL1AM

# http://docs.julialang.org/en/release-0.4/stdlib/math/

# SIMPLE TRANSFORM ----------------------------------------------------------------------------------------------------

f = sin((0:127) * pi / 8) + rand(128);
f -= mean(f)

F = fft(f);
typeof(F)

using Gadfly

# Plot signal in the time domain.
#
plot(x = 0:127, y = f, Guide.xlabel("t [s]"), Guide.ylabel("f(t)", orientation = :vertical))

# Plot power spectrum.
#
plot(x = (0:127) / 128, y = abs(F).^2, xintercept = [1/16], Geom.line,
    Geom.vline(color = colorant"orange"),
    Guide.xlabel("f [Hz]"), Guide.ylabel("Power", orientation = :vertical))

G = fftshift(F);

plot(x = ((1:128) - 65) / 128, y = abs(G).^2, xintercept = [1/16], Geom.line,
    Geom.vline(color = colorant"orange"),
    Guide.xlabel("f [Hz]"), Guide.ylabel("Power", orientation = :vertical))

# 2D TRANSFORM --------------------------------------------------------------------------------------------------------

f = [sin(x * pi / 8) + cos(y * pi / 32) + rand() for x in 1:256, y in 1:256]
f -= mean(f)

F = fft(f);
typeof(F)

spy(f[1:149,1:149], Scale.color_continuous(minvalue=-2, maxvalue=2))

plan = plan_fft(x)

plan = plan_fft)x, 1, FFTW.MEASURE)

FFTW.forget_wisdom()

plan = plan_fft)x, 1, FFTW.ESTIMATE)

dct()

dct(x, [1, 3])

# 3D FFT (various types).
#
FFTW.r2r(x, [FFTW.REDT00, FFTW.REDFT01, FFTW.RODFT10])

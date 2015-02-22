function mse = calc_macd_lift_spectra_mse(Neff_lift, Neff_ema, Nwindow)

% descrip:  builds ema and lifted macd-poly regularization windows, computes the fft, 
%           and based on the first-half of the fft amplitude spectrum 
%           (the positive-frequency part) compute the mean-square error
%           between the cumulative box and ema spectra. 
%
% inputs:   /Neff_lift/   effective-length parameter of lifted ema
%           /Neff_ema/    effective length of ema
%           /Nwindow/     must be 2^m long, and >= ~ 8 x Neff

% construct windows
h_ema  = make_h_ema(Neff_ema, Nwindow);
h_lift = make_h_lifted_macd_poly(Neff_lift, Nwindow);

% take fft's
fft_ema  = fft(h_ema);
fft_lift = fft(h_lift);

% compute cumulative sums
S_fft_ema  = cumsum(abs(fft_ema(1:Nwindow/2)));
S_fft_lift = cumsum(abs(fft_lift(1:Nwindow/2)));

% error
mse = sum( (S_fft_ema - S_fft_lift).^2 ) / ...
    Nwindow;


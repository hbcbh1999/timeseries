function mse = calc_box_macd_spectra_mse(Neff, Nbox, Nwindow)

% descrip:  Builds box- and ema-differencer regularization windows.
%           Computes the fft, and based on the first-half of the 
%           fft amplitude spectrum (the positive-frequency part) 
%           compute the mean-square error between the cumulative spectra. 
%
% inputs:   /Neff/     effective length of positive (shorter) ema
%           /Nbox/     width of box 
%           /Nwindow/  must be 2^m long, and >= ~ 8 x Neff

% construct windows
h_box_diff = make_h_box_diff(Nbox, Nwindow);

h_cand     = make_h_macd(Neff, 3 * Neff, Nwindow);
h_macd     = switch_to_composite_unity_gauge(h_cand);

% take fft's
fft_boxd = fft(h_box_diff);
fft_macd = fft(h_macd);

% compute cumulative sums
S_fft_boxd = cumsum(abs(fft_boxd(1:Nwindow/2)));
S_fft_macd = cumsum(abs(fft_macd(1:Nwindow/2)));

% error
mse = sum( (S_fft_boxd - S_fft_macd).^2 ) / ...
    Nwindow;


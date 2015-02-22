function mse = calc_box_ema_spectra_mse(Neff, Nbox, Nwindow)

% descrip:  builds box and ema regularization windows, computes the fft, 
%           and based on the first-half of the fft amplitude spectrum 
%           (the positive-frequency part) compute the mean-square error
%           between the cumulative box and ema spectra. 
%
% inputs:   /Neff/     effective length of ema
%           /Nbox/     width of box 
%           /Nwindow/  must be 2^m long, and >= ~ 8 x Neff

% construct windows
h_box = make_h_box(Nbox, Nwindow);
h_ema = make_h_ema(Neff, Nwindow);

% take fft's
fft_box = fft(h_box);
fft_ema = fft(h_ema);

% compute cumulative sums
S_fft_box = cumsum(abs(fft_box(1:Nwindow/2)));
S_fft_ema = cumsum(abs(fft_ema(1:Nwindow/2)));

% error
mse = sum( (S_fft_box - S_fft_ema).^2 ) / ...
    Nwindow;








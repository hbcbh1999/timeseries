function mse = calc_box_ema_spectra_mse(N_eff, N_box, N_window)

% 1. d) Mean-Squared Error - Write a function 
%
% mse = calc_box_ema_spectra_mse (N ema, N box, N window)
%
% that 
% 1) generates hema and hbox given the input parameters; 
% 2) takes the amplitude of the FFT for each re- sponse; 
% 3) computes the cumulative sum of each amplitude spectrum; 
% 4) computes and returns the MSE of the two cumulative amplitude spectra.
%
% inputs:   /N_eff/     effective length of ema
%           /N_box/     width of box 
%           /N_window/  must be 2^m long, and >= ~ 8 x N_eff

% construct windows

h_box = make_h_box(N_box, N_window);
h_ema = make_h_ema(N_eff, N_window);

% take fft's

fft_box = fft(h_box);
fft_ema = fft(h_ema);

% compute cumulative sums

S_fft_box = cumsum(abs(fft_box(1:N_window/2)));
S_fft_ema = cumsum(abs(fft_ema(1:N_window/2)));

% error

mse = sum( (S_fft_box - S_fft_ema).^2 ) / ...
    N_window;
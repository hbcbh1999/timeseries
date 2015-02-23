function mse = calc_box_macd_spectra_mse(N_eff, N_box, N_window)

% descrip:  Mean-Squared Error - Write a function 
%
% mse = calc_boxd_macd_spectra_mse(N_ema, N_box, N_window) 
%
% that 
% 
% 1) generates hmacd and hboxd given the input parameters; 
% 2) takes the amplitude of the FFT for each re- sponse; 
% 3) computes the cumulative sum of each amplitude spectrum; 
% 4) computes and returns the MSE of the two cumulative amplitude spectra.
%
% inputs:   /N_eff/     effective length of positive (shorter) ema
%           /N_box/     width of box 
%           /N_window/  must be 2^m long, and >= ~ 8 x N_eff

% construct windows

h_box_diff = box_differencer(N_box, N_window);

h_cand     = make_h_macd(N_eff, 3 * N_eff, N_window);
h_macd     = switch_to_composite_unity_gauge(h_cand);

% take fft's

fft_boxd = fft(h_box_diff);
fft_macd = fft(h_macd);

% compute cumulative sums

S_fft_boxd = cumsum(abs(fft_boxd(1:N_window/2)));
S_fft_macd = cumsum(abs(fft_macd(1:N_window/2)));

% error

mse = sum( (S_fft_boxd - S_fft_macd).^2 ) / ...
    N_window;


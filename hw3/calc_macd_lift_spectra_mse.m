function mse = calc_macd_lift_spectra_mse(N_eff_lift, N_eff_ema, N_window)

% descrip:  2(d) Mean-Squared Error 
% Write a function 
%
% mse = calc_macd_lift_spectra_mse(N_eff_lift, N_eff_ema, N_window) 
%
% that 
%  1) generates hema and hlift given the input parameters; 
%  2) takes the amplitude of the FFT for each re- sponse; 
%  3) computes the cumulative sum of each amplitude spectrum; 
%  4) computes and returns the MSE of the two cumulative amplitude spectra.
%

% construct windows
h_ema  = make_h_ema(N_eff_ema, N_window);
h_lift = lifted_macd_poly(N_eff_lift, N_window);

% take fft's
fft_ema  = fft(h_ema);
fft_lift = fft(h_lift);

% compute cumulative sums
S_fft_ema  = cumsum(abs(fft_ema(1:N_window/2)));
S_fft_lift = cumsum(abs(fft_lift(1:N_window/2)));

% error
mse = sum( (S_fft_ema - S_fft_lift).^2 ) / ...
    N_window;


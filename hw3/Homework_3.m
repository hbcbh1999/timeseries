%% script:  Homework_3.m
% descrip: Fourier Transforms and Spectra Analysis

% price data from the last homework
px_series = importdata('jpm_quotes.csv');
prices    = px_series.data(:,2);
Npx_series = size(px_series.data,1);

% In all cases use Nwindow = 1024 and Nbox = 16.
N_window = 1024;
N_box    = 16;

%% 1. Box and Ema Comparison:

% a) Indicative Responses: 
% Set Neff = Nbox/ ?1 ? e?1?, compute hbox[n] and hema[n]

N_eff = N_box / (1 - exp(-1));
h_box = make_h_box(N_box, N_window);
h_ema = make_h_ema(N_eff, N_window);

% overlay these two responses on a plot.

figure(1); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
stairs(h_box); grid on; hold on;
plot(h_ema, 'r--'); ylim([-0.25 0.25])
title('Box and Ema impulse responses');

% b) Spectra: Using an FFT compute the Fourier transform of these impulse 
% responses. Take the absolute value of the results, which throws away the 
% phase information.

fft_h_box = abs(fft(h_box));
fft_h_ema = abs(fft(h_ema));

% On a separate graph overlay the two amplitude spectra.

axes(ax(2)); cla
plot(fft_h_box); grid on; hold on
plot(fft_h_ema, 'r--'); 
title('Box and Ema spectra')

% c) On a separate graph overlay the cumulative amplitude spectra of the 
% two impulse responses. These cumulative spectra show how much energy is 
% captured from D.C. frequency out to higher frequencies.

axes(ax(3)); cla
plot(cumsum(fft_h_box(1:N_window/2))); grid on; hold on
plot(cumsum(fft_h_ema(1:N_window/2)), 'r--');
title('Energy Capture, Box and Ema');

% e) optimize N_eff such that the energy capture is maximized on a MSE basis

obj_ema = @(x)(calc_box_ema_spectra_mse(x, N_box, N_window));
[N_eff_ema_opt, mse_ema_opt] = fminbnd(obj_ema, 1/3*N_box, 3*N_box);

h_ema_opt     = make_h_ema(N_eff_ema_opt, N_window);
fft_h_ema_opt = abs(fft(h_ema_opt));

axes(ax(1)); 
plot(h_ema_opt, 'k');

axes(ax(2));
plot(fft_h_ema_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_ema_opt(1:N_window/2)), 'k');

% f) Optimized Response: Using N? compute the ema impulse response, its 
% amplitude spectrum and its cumulative amplitude spectrum. Overlay these 
% results with those from tasks (1a-1c), respectively. Report the Neff/Nbox 
% ratio that you found.

box_ema_overlap = sum(h_ema_opt .* h_box) / sqrt(sum(h_ema_opt.^2) * sum(h_box.^2));
disp(['N_eff^opt: ' num2str(N_eff_ema_opt)]);  % N_eff^opt: 9.8071
disp(['N_eff / N_box: ' num2str(box_ema_overlap)]) % N_eff / N_box: 0.89501

% g) Apply to the Price Series: Convolve the box and spectrally-matched ema 
% impulse responses with the price series you generated from last week. 
% Overlay the results on a separate plot.

cand = conv(h_box, prices - prices(1)) + prices(1);
box_px = cand(1: length(prices));

cand = conv(h_ema_opt, prices - prices(1)) + prices(1);
ema_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(box_px); 
grid on; 
hold on; 
plot(ema_opt_px, 'r')
title('Box and Ema Smooths');

disp('pause')
pause


%% Ema and Lifted MACD-Poly Comparison

% a) Indicative Responses: Set Neff ema=16, Neff lift=16, compute hema[n]
% and hlift[n], overlay these two responses on a plot.

N_eff_ema  = N_box;
N_eff_lift = N_eff_ema;

h_ema  = make_h_ema(N_eff_ema, N_window);
h_lift = lifted_macd_poly(N_eff_lift, N_window);

figure(2); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
plot(h_ema); grid on; hold on;
plot(h_lift, 'r--'); ylim([-0.25 0.25])
title('Ema and Lifted MACD-Poly impulse responses');

% b) Spectra: Using an FFT compute the Fourier transform of these impulse 
% responses. Take the absolute value of the results, which throws away the 
% phase information.

fft_h_ema   = abs(fft(h_ema));
fft_h_lift  = abs(fft(h_lift));

% On a separate graph overlay the amplitude spectra.

axes(ax(2)); cla
plot(fft_h_ema); grid on; hold on
plot(fft_h_lift, 'r--'); 
title('Ema and Lifted MACD-Poly spectra')

% c) Cumulative Amplitude Spectra: On a separate graph overlay the 
% cumulative amplitude spectra.

axes(ax(3)); cla
plot(cumsum(fft_h_ema(1:N_window/2))); grid on; hold on
plot(cumsum(fft_h_lift(1:N_window/2)), 'r--');
title('Energy Capture, Ema and Lifted MACD-Poly');

% e) optimize N_eff such that the energy capture is maximized on a MSE 
% basis

obj_lift = @(x)(calc_macd_lift_spectra_mse(x, N_eff_ema, N_window));
[N_eff_lift_opt, mse_lift_opt] = fminbnd(obj_lift, 1/10*N_eff_ema, 10*N_eff_ema);

h_lift_opt     = lifted_macd_poly(N_eff_lift_opt, N_window);
fft_h_lift_opt = abs(fft(h_lift_opt));

axes(ax(1)); 
plot(h_lift_opt, 'k');

axes(ax(2));
plot(fft_h_lift_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_lift_opt(1:N_window/2)), 'k');

% f) Optimized Response: Using N? compute the lifted macd-poly impulse 
% response, its amplitude spectrum and its cumulative amplitude spectrum. 
% Overlay these results with originals. Report the N? /Neff ratio that you 
% found.

ema_lift_overlap = sum(h_lift_opt .* h_ema) / sqrt(sum(h_lift_opt.^2) * sum(h_ema.^2));
disp(['N_lift^opt: ' num2str(N_eff_lift_opt)]); % N_lift^opt: 11.553
disp(['N_lift^opt / N_eff: ' num2str(1.0/ema_lift_overlap)]); % N_lift^opt / N_eff: 1.0601

% g) Apply to the Price Series: Convolve the ema and spectrally-matched 
% lifted macd-poly impulse responses with the price series you generated 
% from last week. Overlay the results on a separate plot.

cand = conv(h_ema, prices - prices(1)) + prices(1);
ema_px = cand(1: length(prices));

cand = conv(h_lift_opt, prices - prices(1)) + prices(1);
lift_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(ema_px); grid on; hold on; plot(lift_opt_px, 'r')
title('Ema and Lifted MACD-Poly Smooths');

disp('pause')
pause


%% Box-Differencer and Macd Comparison

% a) Indicative Responses: Set Neff_neg = Nbox. Compute hboxd[n] and hmacd[n],
% overlay these two responses on a plot.

N_eff_pos = N_box / 3;
N_eff_neg = N_box;
h_box_diff = box_differencer(N_box, N_window);

h_cand     = make_h_macd(N_eff_pos, N_eff_neg, N_window);
h_macd     = switch_to_composite_unity_gauge(h_cand);

figure(3); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
stairs(h_box_diff); grid on; hold on;
plot(h_macd, 'r--'); ylim([-0.25 0.25])
title('Box-Difference and MACD impulse responses');

% b) Spectra: On a separate graph overlay the amplitude spectra.

fft_h_box_diff = abs(fft(h_box_diff));
fft_h_macd     = abs(fft(h_macd));

axes(ax(2)); cla
plot(fft_h_box_diff); grid on; hold on
plot(fft_h_macd, 'r--'); 
title('Box-Difference and MACD spectra')

% c) Cumulative Amplitude Spectra: On a separate graph overlay the 
% cumulative amplitude spectra.

axes(ax(3)); cla
plot(cumsum(fft_h_box_diff(1:N_window/2))); grid on; hold on
plot(cumsum(fft_h_macd(1:N_window/2)), 'r--');
title('Energy Capture, Box-Difference and MACD');

% (e) Minimize the MSE: Minimize the MSE with Neff as the free parameter. 

obj_macd = @(x)(calc_box_macd_spectra_mse(x, N_box, N_window));
[N_eff_pos_opt, mse_macd_opt] = fminbnd(obj_macd, 1/10*N_box, 2*N_box);

h_cand     = make_h_macd(N_eff_pos_opt, 3 * N_eff_pos_opt, N_window);
h_macd_opt = switch_to_composite_unity_gauge(h_cand);
fft_h_macd_opt = abs(fft(h_macd_opt));

% f) Optimized Response: Using N? compute the macd impulse response, its 
% amplitude spectrum and its cumulative amplitude spectrum. Overlay these 
% results with originals. Report the Nbox/N? ratio that you found.

axes(ax(1)); 
plot(h_macd_opt, 'k');

axes(ax(2));
plot(fft_h_macd_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_macd_opt(1:N_window/2)), 'k');

boxdiff_macd_overlap = sum(h_macd_opt .* h_box_diff) / sqrt(sum(h_macd_opt.^2) * sum(h_box_diff.^2));
disp(['N_eff_pos^opt: ' num2str(N_eff_pos_opt)]) % N_eff_pos^opt: 11.974
disp(['N_eff_neg^opt: ' num2str(3*N_eff_pos_opt)]); % N_eff_neg_opt: 35.922
disp(['N_box / N_eff^opt: ' num2str(boxdiff_macd_overlap)]); % N_box / N_eff^opt: 0.61643


% g) Apply to the Price Series: Convolve the box differencer and spectrally
% matched macd impulse responses with the price series you generated from 
% last week. Overlay the results on a separate plot.

cand = conv(h_box_diff, prices - prices(1));
boxd_px = cand(1: length(prices));

cand = conv(h_macd_opt, prices - prices(1));
macd_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(boxd_px); grid on; hold on; plot(macd_opt_px, 'r')
title('Box-Difference and Macd Smooths');
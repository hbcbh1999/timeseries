% script:  study_window_spectral_matching.m
% descrip: Studies how to match window shapes within the same
%          class using spectral methods.

% Defs
Nwindow = 1024;
Nbox    = 16;

% Data
l_path = resolve_machine_path();

% data
px_series = importdata([l_path '/data/homework_solutions/2012/hw2/jpm_quotes.csv']);
prices    = px_series.data(:,2);
Npx_series = size(px_series.data,1);

%% Box and Ema

% 1) Using indicative Neff, plot impulse responses, plot amplitude spectra.
Neff = Nbox / (1 - exp(-1));
h_box = make_h_box(Nbox, Nwindow);
h_ema = make_h_ema(Neff, Nwindow);

figure(1); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
stairs(h_box); grid on; hold on;
plot(h_ema, 'r--'); ylim([-0.25 0.25])
title('Box and Ema impulse responses');

fft_h_box = abs(fft(h_box));
fft_h_ema = abs(fft(h_ema));

axes(ax(2)); cla
plot(fft_h_box); grid on; hold on
plot(fft_h_ema, 'r--'); 
title('Box and Ema spectra')

axes(ax(3)); cla
plot(cumsum(fft_h_box(1:Nwindow/2))); grid on; hold on
plot(cumsum(fft_h_ema(1:Nwindow/2)), 'r--');
title('Energy Capture, Box and Ema');

% 2) optimize Neff such that the energy capture is maximized on a MSE basis
obj_ema = @(x)(calc_box_ema_spectra_mse(x, Nbox, Nwindow));
[Neff_ema_opt, mse_ema_opt] = fminbnd(obj_ema, 1/3*Nbox, 3*Nbox);

h_ema_opt     = make_h_ema(Neff_ema_opt, Nwindow);
fft_h_ema_opt = abs(fft(h_ema_opt));

axes(ax(1)); 
plot(h_ema_opt, 'k');

axes(ax(2));
plot(fft_h_ema_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_ema_opt(1:Nwindow/2)), 'k');

% 3) compute overlap intergral
box_ema_overlap = sum(h_ema_opt .* h_box) / sqrt(sum(h_ema_opt.^2) * sum(h_box.^2));
disp(['Neff_ema_opt: ' num2str(Neff_ema_opt)]);
disp(['box/ema overlap: ' num2str(box_ema_overlap)])

% 4) convolve with px data
cand = conv(h_box, prices - prices(1)) + prices(1);
box_px = cand(1: length(prices));

cand = conv(h_ema_opt, prices - prices(1)) + prices(1);
ema_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(box_px); grid on; hold on; plot(ema_opt_px, 'k')
title('Box and Ema Smooths');

disp(['hit any key...'])
pause


%% Ema and Lifted MACD

% 1) Using indicative Neff, plot impulse responses, plot amplitude spectra.
Neff_ema  = Nbox;
Neff_lift = Neff_ema;

h_ema  = make_h_ema(Neff_ema, Nwindow);
h_lift = make_h_lifted_macd_poly(Neff_lift, Nwindow);

figure(2); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
plot(h_ema); grid on; hold on;
plot(h_lift, 'r--'); ylim([-0.25 0.25])
title('Ema and Lifted ema impulse responses');

fft_h_ema   = abs(fft(h_ema));
fft_h_lift  = abs(fft(h_lift));

axes(ax(2)); cla
plot(fft_h_ema); grid on; hold on
plot(fft_h_lift, 'r--'); 
title('Ema and Lifted ema spectra')

axes(ax(3)); cla
plot(cumsum(fft_h_ema(1:Nwindow/2))); grid on; hold on
plot(cumsum(fft_h_lift(1:Nwindow/2)), 'r--');
title('Energy Capture, Ema and Lifted ema');

% 2) optimize Neff such that the energy capture is maximized on a MSE basis
obj_lift = @(x)(calc_macd_lift_spectra_mse(x, Neff_ema, Nwindow));
[Neff_lift_opt, mse_lift_opt] = fminbnd(obj_lift, 1/10*Neff_ema, 10*Neff_ema);

h_lift_opt     = make_h_lifted_macd_poly(Neff_lift_opt, Nwindow);
fft_h_lift_opt = abs(fft(h_lift_opt));

axes(ax(1)); 
plot(h_lift_opt, 'k');

axes(ax(2));
plot(fft_h_lift_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_lift_opt(1:Nwindow/2)), 'k');

% 3) compute overlap intergral
ema_lift_overlap = sum(h_lift_opt .* h_ema) / sqrt(sum(h_lift_opt.^2) * sum(h_ema.^2));
disp(['Neff_lift_opt: ' num2str(Neff_lift_opt)]);
disp(['ema/lift overlap: ' num2str(ema_lift_overlap)]);

% 4) convolve with px data
cand = conv(h_ema, prices - prices(1)) + prices(1);
ema_px = cand(1: length(prices));

cand = conv(h_lift_opt, prices - prices(1)) + prices(1);
lift_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(ema_px); grid on; hold on; plot(lift_opt_px, 'k')
title('Ema and Lifted-Ema Smooths');

disp(['hit any key...'])
pause


%% Box-Differencer and Ema-Differencer (MACD)

% 1) Using indicative Neff, plot impulse responses, plot amplitude spectra.
Neff_pos = Nbox / 3;
Neff_neg = Nbox;
h_box_diff = make_h_box_diff(Nbox, Nwindow);

h_cand     = make_h_macd(Neff_pos, Neff_neg, Nwindow);
h_macd     = switch_to_composite_unity_gauge(h_cand);

figure(3); clf
for k = 1:4,
    ax(k) = subplot(2,2,k);
end

axes(ax(1)); cla
stairs(h_box_diff); grid on; hold on;
plot(h_macd, 'r--'); ylim([-0.25 0.25])
title('BoxDiff and MACD impulse responses');

fft_h_box_diff = abs(fft(h_box_diff));
fft_h_macd     = abs(fft(h_macd));

axes(ax(2)); cla
plot(fft_h_box_diff); grid on; hold on
plot(fft_h_macd, 'r--'); 
title('BoxDiff and MACD spectra')

axes(ax(3)); cla
plot(cumsum(fft_h_box_diff(1:Nwindow/2))); grid on; hold on
plot(cumsum(fft_h_macd(1:Nwindow/2)), 'r--');
title('Energy Capture, BoxDiff and MACD');

% 2) optimize Neff such that the energy capture is maximized on a MSE basis
obj_macd = @(x)(calc_box_macd_spectra_mse(x, Nbox, Nwindow));
[Neff_pos_opt, mse_macd_opt] = fminbnd(obj_macd, 1/10*Nbox, 2*Nbox);

h_cand     = make_h_macd(Neff_pos_opt, 3 * Neff_pos_opt, Nwindow);
h_macd_opt = switch_to_composite_unity_gauge(h_cand);
fft_h_macd_opt = abs(fft(h_macd_opt));

axes(ax(1)); 
plot(h_macd_opt, 'k');

axes(ax(2));
plot(fft_h_macd_opt, 'k');

axes(ax(3));
plot(cumsum(fft_h_macd_opt(1:Nwindow/2)), 'k');

% 3) compute overlap intergral
boxdiff_macd_overlap = sum(h_macd_opt .* h_box_diff) / sqrt(sum(h_macd_opt.^2) * sum(h_box_diff.^2));
disp(['Neff_pos_opt: ' num2str(Neff_pos_opt) ' Neff_neg_opt: ' num2str(3*Neff_pos_opt)]);
disp(['boxdiff/macd overlap: ' num2str(boxdiff_macd_overlap)]);

% 4) convolve with px data
cand = conv(h_box_diff, prices - prices(1));
boxd_px = cand(1: length(prices));

cand = conv(h_macd_opt, prices - prices(1));
macd_opt_px = cand(1: length(prices));

axes(ax(4)); cla
plot(boxd_px); grid on; hold on; plot(macd_opt_px, 'k')
title('BoxDiff and Macd Smooths');









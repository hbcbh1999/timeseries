% script:  study_sampling_replication_ztransforms.m
% descrip: hw4 solutions studies sampling, replication and z-transforms
% author: Weiyi Chen, Rongxin Yu

%% 1. Sampling in Time:

% On a computer it is a bit odd to sample a time series because all time 
% series are necessarily discrete. Here we will build (discrete) impulse 
% responses and then sample them at a longer period. For this part use 
% Nwindow = 1024 and Nperiod = 4.

Nwindow = 1024;
Nperiod = 4;

% (a) Ema impulse response: Generate hema with Neff = 128.
Neff = 128;
h_ema = make_h_ema(Neff, Nwindow);

% (b) Box impulse response: Generate hbox with Nbox
Nbox = round(Neff / (1 - exp(-1)));
h_box = make_h_box(Nbox, Nwindow);

% (c) Comb impulse response: Generate hcomb with Nperiod = 4
h_comb = make_h_impulse_comb(Nperiod, Nwindow);

% (d) Sampled ema: Compute hema?sampled ? hcomb × hema.
h_ema_sampled = h_ema .* h_comb;

% (e) Sampled box: Compute hbox?sampled ? hcomb × hbox.
h_box_sampled = h_box .* h_comb;

% (f) Ema and Box amplitude spectra: Compute Hema(?) ? F (hema[n]) and keep 
% the magnitude |Hema(?)|. Likewise, compute |Hbox(?)|, |Hema?sampled(?)| 
% and |Hbox?sampled(?)|.
H_box = abs(fft(h_box));
H_ema = abs(fft(h_ema));
H_box_sampled = Nperiod * abs(fft(h_box_sampled));
H_ema_sampled = Nperiod * abs(fft(h_ema_sampled));

% (h) Plots: On one plot overlay hema and hema?sampled. Make a similar 
% overlay for hbox and hbox?sampled on another plot. On a third plot 
% overlay |Hema(?)| with Ts |Hema?sampled(?)|. Repeat for the box spectra 
% on a fourth plot. 
% (i) Remark on the sample period and the period of spectral replications.
figure(1); clf
for k=1:4, 
    ax(k,1) = subplot(4,1,k); 
end;

linkaxes(ax(:,1), 'x');
axes(ax(1,1))
plot(h_ema);
stem(h_ema_sampled, 'r');
title('hema and hema?sampled');

axes(ax(2,1));
stairs(h_box);
stem(h_box_sampled, 'r');
title('hbox and hbox?sampled')

axes(ax(3,1));
plot(H_ema);
plot(H_ema_sampled, 'b');
title('Hema and Hema-sampled')

axes(ax(4,1));
plot(H_box);
plot(H_box_sampled, 'b');
title('Hbox and Hbox-sampled')

%% 2. Replication in Time:
% The last problem showed that sampling in one domain (time) induces 
% replication in the other (frequency). Here the re- verse is explored: 
% replication in one domain (time) induces sampling in the other 
% (frequency). For this work select Nperiod = Nwindow / 4.
Nperoid = Nwindow / 4; 

% (a) Generate hema with Neff = 32 and hbox with Nbox
Neff = 32;
h_ema = make_h_ema(Neff, Nwindow);
Nbox = round(Neff / (1 - exp(-1)));
h_box = make_h_box(Nbox, Nwindow);

% (b) Generate hcomb with the new period, Np = 256.
h_comb = make_h_impulse_comb(Nwindow / Nperiod, Nwindow);

% (c) Replicate these impulse responses by convolving with the comb.
cand = conv(h_comb, h_box); 
h_box_repl = cand(1: Nwindow);
cand = conv(h_comb, h_ema); 
h_ema_repl = cand(1: Nwindow);

% (d) Compute the Fourier transforms |Hema(?)|, |Hbox(?)|, |Hema?repl(?)|
% and |Hbox?repl(?)|.
H_box = abs(fft(h_box));
H_ema = abs(fft(h_ema));
H_box_repl = abs(fft(h_box_repl)) / Nperiod;
H_ema_repl = abs(fft(h_ema_repl)) / Nperiod;

% (e) Plot hema?repl and hbox?repl on two figures. Overlay |Hema(?)| and
% T?1 |H (?)| on another figure, and do the same with the box s ema?repl
% spectra.
figure(2); clf
for k=1:4, 
    ax(k,1) = subplot(4,1,k); 
end; 
linkaxes(ax(:,1), 'x');
axes(ax(1,1)); 
plot(h_box);
stairs(h_box_repl);
title('hbox and hbox replication')

axes(ax(2,1))
plot(h_ema);
plot(h_ema_repl);
title('hema and hema replication')

axes(ax(3,1));
plot(H_box);
plot(H_box_repl, 'r');
title('Box spectrum and its sample')

axes(ax(4,1));
plot(H_ema);
plot(H_ema_repl, 'r');
title('Ema spectrum and its sample')
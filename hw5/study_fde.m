% script:  study_fde.m
% descrip: Applies a price series to each fde and
%          compares that result with the one created by convolution.

% import data
quotes = importdata('jpm_quotes.csv');

px_series = quotes.data(:,2);

% lags of output used in recursion
lags_y.delay = 0;
lags_y.unitstep = 0;
lags_y.box = 1;
lags_y.ema = 1;
lags_y.ema_poly1 = 2;
lags_y.lifted_macd = 3;
lags_y.macd = 2;
 
fns = fieldnames(lags_y);

No = 32;
Nwindow = 8 * No;

% impulse-response parameters
h_params.delay.Ndelay = No;
h_params.box.Nbox = No;
h_params.ema.Neff = No;
h_params.ema_poly1.Neff = No;
h_params.lifted_macd.Neff_lift = No;
h_params.macd.Neff_pos = No / 2;
h_params.macd.Neff_neg = No;

% associated fde's as function handles
fde.delay       = @(x)(apply_delay_impulse_filter(x, h_params.delay.Ndelay));
fde.unitstep    = @(x)(apply_unitstep_filter(x));
fde.box         = @(x)(apply_box_filter(x, h_params.box.Nbox));
fde.ema         = @(x)(apply_ema_filter(x, h_params.ema.Neff));
fde.ema_poly1   = @(x)(apply_ema_poly1_filter(x, h_params.ema_poly1.Neff));
fde.lifted_macd = @(x)(apply_lifted_macd_poly_filter(x, h_params.lifted_macd.Neff_lift));
fde.macd        = @(x)(apply_macd_filter(x, h_params.macd.Neff_pos, h_params.macd.Neff_neg));

% equivalent h[n]'s as function handles
h.delay         = @()(make_h_delta(h_params.delay.Ndelay, Nwindow));
h.unitstep      = @()(make_h_unitstep(length(px_series)));
h.box           = @()(make_h_box(h_params.box.Nbox, Nwindow));
h.ema           = @()(make_h_ema(h_params.ema.Neff, Nwindow));
h.ema_poly1     = @()(make_h_ema_poly1(h_params.ema_poly1.Neff, Nwindow));
h.lifted_macd   = @()(make_h_lifted_macd_poly(h_params.lifted_macd.Neff_lift * 24 / 23, Nwindow));
h.macd          = @()(make_h_macd(h_params.macd.Neff_pos, h_params.macd.Neff_neg, Nwindow));

% iterate through fde's, generate an impulse input with lags_y + 1 delay, 
%   compute the fde impulse response, compute the associated h[n] response, 
%   plot in overlay.

n = [0: length(px_series)-1]';
disp(['size n: ' num2str(length(n))]);
for k = 1: length(fns),
    
    disp(fns{k})

    % compute the fde result
    y_fde.(fns{k}) = fde.(fns{k})(px_series);
    
    % compute h[n]
    switch fns{k}
        case {'delay', 'unitstep'}
            subtract_coeff = 0;
            add_coeff = 0;
        case {'box', 'ema', 'ema_poly1', 'lifted_macd'}
            subtract_coeff = 1;
            add_coeff = 1;
        case 'macd'
            subtract_coeff = 1;
            add_coeff = 0;
    end
        
    cand = conv(h.(fns{k})(), px_series - subtract_coeff * px_series(1)) + add_coeff * px_series(1);
    y_n.(fns{k}) = cand(1: length(px_series));
    
    % plot the response
    figure(k); clf
    plot(n, y_fde.(fns{k})); grid on; hold on
    plot(n, y_n.(fns{k}), 'r.'); 
    title(['Filter: ' fns{k}]);
    
end

%% study_fde_impulse_responses
% descrip: Applies a impulse to each fde, measures the impulse response, and
%          compares that response with the original h[n] equation
% filters:   delay
%            unit step
%            box
%            ema
%            ema-poly1
%            lifted-macd
%            macd

% lags of output used in recursion
lags_y.delay = 0;
lags_y.unitstep = 0;
lags_y.box = 1;
lags_y.ema = 1;
lags_y.ema_poly1 = 2;
lags_y.lifted_macd = 3;
lags_y.macd = 2;
 
fns = fieldnames(lags_y);

No = 32;
Nwindow = 8 * No;

% impulse-response parameters
h_params.delay.Ndelay = No;
h_params.box.Nbox = No;
h_params.ema.Neff = No;
h_params.ema_poly1.Neff = No;
h_params.lifted_macd.Neff_lift = No;
h_params.macd.Neff_pos = No / 2;
h_params.macd.Neff_neg = No;

% associated fde's as function handles
fde.delay       = @(x)(apply_delay_impulse_filter(x, h_params.delay.Ndelay));
fde.unitstep    = @(x)(apply_unitstep_filter(x));
fde.box         = @(x)(apply_box_filter(x, h_params.box.Nbox));
fde.ema         = @(x)(apply_ema_filter(x, h_params.ema.Neff));
fde.ema_poly1   = @(x)(apply_ema_poly1_filter(x, h_params.ema_poly1.Neff));
fde.lifted_macd = @(x)(apply_lifted_macd_poly_filter(x, h_params.lifted_macd.Neff_lift));
fde.macd        = @(x)(apply_macd_filter(x, h_params.macd.Neff_pos, h_params.macd.Neff_neg));

% equivalent h[n]'s as function handles
h.delay         = @()(make_h_delta(h_params.delay.Ndelay, Nwindow));
h.unitstep      = @()(make_h_unitstep(Nwindow));
h.box           = @()(make_h_box(h_params.box.Nbox, Nwindow));
h.ema           = @()(make_h_ema(h_params.ema.Neff, Nwindow));
h.ema_poly1     = @()(make_h_ema_poly1(h_params.ema_poly1.Neff, Nwindow));
h.lifted_macd   = @()(make_h_lifted_macd_poly(h_params.lifted_macd.Neff_lift * 24 / 23, Nwindow));
h.macd          = @()(make_h_macd(h_params.macd.Neff_pos, h_params.macd.Neff_neg, Nwindow));

% iterate through fde's, generate an impulse input with lags_y + 1 delay, 
%   compute the fde impulse response, compute the associated h[n] response, 
%   plot in overlay.

n = [0: Nwindow - 1]';
for k = 1: length(fns),
    
    disp(fns{k})

    % make an impulse input with unity at lags_y + 1
    impulse = zeros(Nwindow + lags_y.(fns{k}),1);
    impulse(lags_y.(fns{k})+1) = 1;

    % compute the fde impulse response
    cand = fde.(fns{k})(impulse);
    h_fde.(fns{k}) = cand(lags_y.(fns{k})+1: end);

    % explicitly compute gain and M1
    gain_fde.(fns{k}) = sum(h_fde.(fns{k}));
    M1_fde.(fns{k})   = sum(n .* h_fde.(fns{k}));
    
    % compute h[n]
    h_n.(fns{k}) = h.(fns{k})();
    
    % plot the response
    figure(k); clf
    stairs(n, h_fde.(fns{k})); grid on; hold on
    plot(n, h_n.(fns{k}), 'r'); 
    title(['Filter: ' fns{k}]);
    
end
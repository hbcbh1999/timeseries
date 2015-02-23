function h = make_h_macd(N_eff_pos, N_eff_neg, N_window)

% descrip: returns a truncated macd response
% author: JN Damask

h_pos = make_h_ema(N_eff_pos, N_window);
h_neg = make_h_ema(N_eff_neg, N_window);

h = h_pos - h_neg;


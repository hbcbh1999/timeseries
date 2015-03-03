function h = make_h_macd(Neff_pos, Neff_neg, Nwindow)

% descrip: returns a truncated macd response
% author: JN Damask

h_pos = make_h_ema(Neff_pos, Nwindow);
h_neg = make_h_ema(Neff_neg, Nwindow);

h = h_pos - h_neg;


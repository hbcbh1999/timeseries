function h = make_h_ema(N_eff, N_window)

% descrip: returns a truncated ema impulse response. Due to the truncation
%          the gain is less than unity.

p = N_eff / (N_eff + 1);
n = [0: N_window - 1];

h = (1 - p) * p.^n;  % gain = 1 - p^(N_window-1)
h = h(:);
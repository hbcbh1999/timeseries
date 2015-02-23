function h = make_h_ema_poly1(N_eff, N_window)

% summary:  returns a unit-gain ema with a linear polynomial coefficient

p = (N_eff/2) / ((N_eff/2) + 1);
n = [0: N_window - 1];

h = (1 - p)^2 * (n + 1) .* p.^n;
h = h(:);
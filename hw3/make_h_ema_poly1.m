function h = make_h_ema_poly1(Neff, Nwindow)

% script:  returns a unit-gain ema with a linear polynomial coefficient

p = (Neff/2) / ((Neff/2) + 1);
n = [0: Nwindow - 1];

h = (1 - p)^2 * (n + 1) .* p.^n;
h = h(:);






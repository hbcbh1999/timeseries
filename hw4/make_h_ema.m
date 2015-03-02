function h = make_h_ema(Neff, Nwindow)

% descrip: returns a truncated ema impulse response. Due to the truncation
%          the gain is less than unity.
% author: JN Damask

p = Neff / (Neff + 1);
n = [0: Nwindow - 1];

h = (1 - p) * p.^n;  % gain = 1 - p^(Nwindow-1)
h = h(:);





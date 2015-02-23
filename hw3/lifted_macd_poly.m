function h = lifted_macd_poly(N_eff, N_window)

% summary:  Makes a lifted macd-poly filter, which is like a band-limited ema. 
%           The gain is unity. 'Lift' means that I have convolved an
%           macd-poly impulse response with a unit step. 

h_macd_poly = macd_poly1(N_eff, N_window);
g = 2 * N_eff / 3;
h_lift = 1 / g * cumsum(h_macd_poly);
h = h_lift(:);



function h = make_h_lifted_macd_poly(Neff, Nwindow)

% descrip:  Makes a lifted macd-poly filter, which is like a band-limited ema. 
%           The gain is unity. 'Lift' means that I have convolved an
%           macd-poly impulse response with a unit step. 

h_macd_poly = make_h_macd_poly1(Neff, Nwindow);
g = 2 * Neff / 3;
h_lift = 1 / g * cumsum(h_macd_poly);
h = h_lift(:);



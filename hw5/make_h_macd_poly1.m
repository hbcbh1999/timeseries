function h = make_h_macd_poly1(Neff, Nwindow)

% descrip:  Make a degenerate macd. The positive arm is an ema with
%           Neff_pos = Neff / 3. The negative arm is a polynomial-coeff
%           ema with Neff_neg = Neff. 

h_pos = make_h_ema(Neff / 3, Nwindow);
h_neg = make_h_ema_poly1(Neff, Nwindow);

h = h_pos - h_neg;
h = h(:);





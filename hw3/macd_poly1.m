function h = macd_poly1(N_eff, N_window)

% descrip:  Make a degenerate macd. The positive arm is an ema with
%           N_eff_pos = N_eff / 3. The negative arm is a polynomial-coeff
%           ema with N_eff_neg = N_eff. 

h_pos = make_h_ema(N_eff / 3, N_window);
h_neg = ema_poly1(N_eff, N_window);

h = h_pos - h_neg;
h = h(:);
function y = apply_lifted_macd_poly_filter(x, Neff_lift)

% descrip:  Uses a recursion equation to apply a lifted-macd filter to x, generating y.
% inputs:   /x/     input sequence
%           /Neff/  ema parameter
% recursion: 
%
%        y[n] = (2 p_poly + p_ema) y[n-1] - p_poly (p_poly + 2 p_ema) y[n-2] + p_poly^2 p_ema y[n-3]
%                  + (2 p_poly - p_poly^2 - p_ema) x[n] - p_poly^2 (1 - p_ema) x[n-1]
% 
% initial conditions: y[1:3] = 0  (matlab is index-base 1)
%

% convert ema parameter
Neff = 24 / 23 * Neff_lift;  % see solutions hw#4
p_ema  = (Neff/3) / ((Neff/3) + 1);
p_poly = (Neff/2) / ((Neff/2) + 1);

% recursion structure
lags_y = 3;

% remove x[1] from x
xn = [zeros(lags_y,1); x(:) - x(1)];  % pad with leading 0, never used

% pad yn with leading zero to set the initial condition to zero
yn = zeros(size(xn));

% run the recursion
gain = 2 * Neff / 3;
y1 = 2 * p_poly + p_ema; y2 = - p_poly * (p_poly + 2 * p_ema); y3 = p_poly^2 * p_ema;
x0 = (2 * p_poly - p_poly^2 - p_ema) / gain; x1 = - p_poly^2 * (1 - p_ema) / gain;
for k = 1 + lags_y: length(xn),
   
    yn(k) = y1 * yn(k-1) + y2 * yn(k-2) + y3 * yn(k-3) + ...
        x0 * xn(k) + x1 * xn(k-1);
    
end

% remove the initial-condition pad, add back in the x[1] value
y = yn(1 + lags_y:end) + x(1);







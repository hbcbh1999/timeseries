function y = apply_macd_filter(x, Neff_pos, Neff_neg)

% descrip:  Uses a recursion equation to apply an macd filter to x, generating y.
% inputs:   /x/         input sequence
%           /Neff_pos/  characteristic length, + arm
%           /Neff_neg/  characteristic length, - arm
% recursion: 
%
%        y[n] = (p+ - p-) y[n-1] - p-p+ y[n-2] + (p+ - p-) x[n] - (p+ - p-) x[n-1]
% 
% initial conditions: y[1] = 0, y[2] = 0  (matlab is index-base 1)
%

% convert ema parameter
p_pos = Neff_pos / (Neff_pos + 1);
p_neg = Neff_neg / (Neff_neg + 1);

% recursion structure
lags_y = 2;

% remove x[1] from x
xn = [zeros(lags_y,1); x(:) - x(1)];  % pad with leading 0s, never used

% pad yn with leading zero to set the initial condition to zero
yn = zeros(size(xn));

% run the recursion
y1 = (p_neg + p_pos); y2 = - p_neg * p_pos; 
x0 = (p_neg - p_pos); x1 = -(p_neg - p_pos);
for k = 1 + lags_y: length(xn),
   
    yn(k) = y1 * yn(k-1) + y2 * yn(k-2) + x0 * xn(k) + x1 * xn(k-1);
    
end

% remove the initial-condition pad, add back in the x[1] value
y = yn(1 + lags_y:end);



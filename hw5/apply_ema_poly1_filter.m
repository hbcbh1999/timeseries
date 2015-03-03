function y = apply_ema_poly1_filter(x, Neff)

% descrip:  Uses a recursion equation to apply an ema-poly1 filter to x, generating y.
% inputs:   /x/     input sequence
%           /Neff/  filter parameter
% recursion: 
%
%        y[n] = 2 p y[n-1] - p^2 y[n-2] + (1-p)^2 x[n]
% 
% initial conditions: y[1] = 0, y[2] = 0  (matlab is index-base 1)
%

% convert ema parameter
p = (Neff/2) / ((Neff/2) + 1);

% recursion structure
lags_y = 2;

% remove x[1] from x
xn = [zeros(lags_y,1); x(:) - x(1)];  % pad with leading 0s, never used

% pad yn with leading zero to set the initial condition to zero
yn = zeros(size(xn));

% run the recursion
y1 = 2 * p; y2 = - p * p; x0 = (1-p)^2;
for k = 1 + lags_y: length(xn),
   
    yn(k) = y1 * yn(k-1) + y2 * yn(k-2) + x0 * xn(k);
    
end

% remove the initial-condition pad, add back in the x[1] value
y = yn(1 + lags_y:end) + x(1);



function y = apply_ema_filter(x, Neff)

% descrip:  Uses a recursion equation to apply an ema filter to x, generating y.
% inputs:   /x/     input sequence
%           /Neff/  ema parameter
% recursion: 
%
%        y[n] = p y[n-1] + (1-p) x[n]
% 
% initial conditions: y[1] = 0  (matlab is index-base 1)
%

% convert ema parameter
p = Neff / (1 + Neff);

% recursion structure
lags_y = 1;

% remove x[1] from x
xn = [zeros(lags_y,1); x(:) - x(1)];  % pad with leading 0, never used

% pad yn with leading zero to set the initial condition to zero
yn = zeros(size(xn));

% run the recursion
for k = 1 + lags_y: length(xn),
   
    yn(k) = p * yn(k-1) + (1-p) * xn(k);
    
end

% remove the initial-condition pad, add back in the x[1] value
y = yn(1 + lags_y:end) + x(1);







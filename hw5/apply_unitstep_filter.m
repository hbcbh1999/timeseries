function y = apply_unitstep_filter(x)


% descrip:  Uses a recursion equation to apply a unit-step filter to x,
%           generating y.
% inputs:   /x/     input sequence
% recursion:
%
%       y[n] = y[n-1] + x[n]
%

% recursion structure
lags_y = 1;

% pad with leading 0, never used
xn = [zeros(lags_y,1); x(:)];  

% pad yn with leading zero to set the initial condition to zero
yn = zeros(size(xn));

% run the recursion
for k = 1 + lags_y: length(xn),
   
    yn(k) = yn(k-1) + xn(k);
    
end

% remove the initial-condition pad, add back in the x[1] value
y = yn(1 + lags_y:end);









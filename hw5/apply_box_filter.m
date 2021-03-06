function y = apply_box_filter(x, Nbox)

% descrip:  For each impulse response write a routine that implements the 
%           recursion.
%   
%           Each apply ?() function should consume x, a vector input, and 
%           all the necessary parameter to define the filter 
%           characteristics.
%

% recursion structure
lags_y = 1;

% remove x[1] from x
xn = [zeros(lags_y,1); x(:) - x(1)];  % pad with leading 0, never used

% pad yn with leading zero to set i.c. to zero
yn = zeros(size(xn));

% run the recursion
xn_delay = 0;
for k = 1 + lags_y: length(xn),
    
    if k - Nbox > 0
        xn_delay = xn(k-Nbox);
    end
    yn(k) = yn(k-1) + (xn(k) - xn_delay) / Nbox;
    
end

% remove the i.c. pad, add back the x[1] value
y = yn(1 + lags_y:end) + x(1);
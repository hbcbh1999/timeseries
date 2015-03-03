function y = apply_delay_impulse_filter(x, Ndelay)

% descrip:  Uses a recursion equation to apply a delay filter to x,
%           generating y.
% inputs:   /x/       input sequence
%           /Ndelay/  delay
% recursion:
%
%       y[n] = x[n-Ndelay+1] for n-Ndelay+1>0
%

% allocate
y = zeros(size(x));

% run the recursion
x_delay = 0;
for k = 1: length(x),
    
    if k - Ndelay + 1 > 0
        x_delay = x(k-Ndelay+1);
    end
    y(k) = x_delay;
    
end







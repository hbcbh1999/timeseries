function h = make_h_impulse_comb(Nperiod, Nwindow)

% descrip:  The impulse-comb impulse response is required below. Add to 
%           your collection of impulse-response generating functions by 
%           writing a function that returns a comb
% author: Weiyi Chen, Rongxin Yu
 
h = zeros(Nwindow, 1);
h(1: Nperiod: Nwindow) = 1;
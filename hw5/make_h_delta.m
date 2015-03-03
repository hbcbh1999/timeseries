function h = make_h_delta(k, Nwindow)

% descrip: returns an ideal delay
% author: JN Damask

h = zeros(Nwindow, 1);
h(k) = 1;



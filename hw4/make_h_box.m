function h = make_h_box(Nbox, Nwindow)

% descrip: returns a box-averager impulse response
% author: JN Damask

h = zeros(Nwindow, 1);
h(1:Nbox) = 1 / Nbox;
h = h(:);




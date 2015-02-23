function h = box_differencer(N_box, N_window)

% descrip:  returns a differencer impulse response where the positive
%           and negative arms are equal-length boxes.

h = zeros(N_window, 1);
h(1:N_box)        = 1 / N_box;
h(N_box+1:2*N_box) = - 1 / N_box;
h = h(:);
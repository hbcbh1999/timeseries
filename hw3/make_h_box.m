function h = make_h_box(N_box, N_window)

% descrip: returns a box-averager impulse response

h = zeros(N_window, 1);
h(1:N_box) = 1 / N_box;
h = h(:);
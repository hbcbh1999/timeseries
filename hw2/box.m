function response = box(N_box, N_window)
response = ones(1, N_window) / N_box
response(N_box+1: N_window) = 0
function response = macdM1(Neff_pos, Neff_neg, N_window)
response = delta(Neff_pos, N_window) - delta(Neff_neg, N_window)
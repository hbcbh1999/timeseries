function response = macd(Neff_pos, Neff_neg, N_window)
response = ema(Neff_pos, N_window) - ema(Neff_neg, N_window)
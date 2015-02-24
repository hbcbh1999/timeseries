function response = ema(Neff, N_window)
power = 0:(N_window-1)
p = Neff/(1+Neff)
response = (1-p) * (p .^ power)
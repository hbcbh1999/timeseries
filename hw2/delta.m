function response = delta(k, N_window)
response = zeros(1,N_window)
if(0<=k)&& (k<=N_window-1)
    response(k+1)=1
end

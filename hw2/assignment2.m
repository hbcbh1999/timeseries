%% Problem 1
load('data')
N_box = 20
Neff = 20
Neff_pos = 20
Neff_neg = 40
N_window = 400
k = 0

IR_Delta = delta(k, N_window)
IR_unitStep = unitStep(N_window)
IR_Box = box(N_box, N_window)
IR_ema = ema(Neff, N_window)
IR_macd = macd(Neff_pos, Neff_neg, N_window)
IR_macdM1 = macdM1(Neff_pos, Neff_neg, N_window)
plot(log10(1:N_window), [IR_Delta; IR_unitStep; IR_Box;IR_ema;IR_macd;IR_macdM1])
title('Impulse Response')
legend('delta', 'unitstep', 'box', 'ema', 'macd' , 'macdM1')
xlabel('log(x)')


%% Problem 2
px = table2array(data(:,'PRICE'))
vol = table2array(data(:,'vol'))
mid = table2array(data(:,'mid'))
plot(1:length(px),[px,mid])
legend('Price', 'Mid quote')
figure
bar(vol)
title('Volume')

%% Problem 3
%(a)
cand = conv(ema(Neff,N_window),px)
plot(cand)
hold on
plot(px,':r')
legend('cand','price')
hold off

%(b)
y = cand(1:length(px))   %It takes part of the cand vector that overlay with px
figure
plot(y)
hold on
plot(px,':r')
legend('y','price', 'Location', 'Southeast')
hold off

%% Problem 4
%(a)
y = conv(ema(Neff, N_window),px)
y = y(1:length(px))
plot(y)
hold on
plot(px,':r')
legend('y','price', 'Location', 'Southeast')
title('Incorrect Initialization')
hold off

%(b)
y = conv(ema(Neff, N_window),px-px(1)) + px(1)
y = y(1:length(px))
figure
plot(y)
hold on
plot(px,':r')
legend('y','price', 'Location', 'Southeast')
title('Correct Initialization')
hold off

%(c)
y1 = conv(macd(Neff_pos, Neff_neg, N_window),px)
y1 = y1(1:length(px))
y2 = conv(macd(Neff_pos, Neff_neg, N_window),px-px(1)) + px(1)
y2 = y2(1:length(px))
y3 = conv(macd(Neff_pos, Neff_neg, N_window),px-px(1))
y3 = y3(1:length(px))

figure
plot(1:length(px), px, 1:length(px),[y1;y2;y3])
legend('price','y1', 'y2', 'y3')
title('Comparison')
figure
plot(y3)
title('Correct MACD convolution')

%% Problem 5
%(a)
g = [0.2,1.0,5]
y = zeros(length(px), 3)
for i = 1:3
    temp = conv(g(i)* ema(Neff, N_window),px-px(1)) + g(i) * px(1)
    y(:,i) = temp(1:length(px))
    figure
    plot(1:length(px), [px, y(:,i)])
    legend('price', 'ema')
    title(sprintf('g = %f',g(i)))
end

%(b)
for i = 1:3
    temp = conv(g(i)* macd(Neff_pos, Neff_neg, N_window),px-px(1)) + g(i) * px(1)
    y(:,i) = temp(1:length(px))
    figure
    plot(1:length(px), [px, y(:,i)])
    legend('price', 'macd')
    title(sprintf('g = %f',g(i)))
end

%% Problem 6
Neff_series = [2,5,10,20,50,100]
IR_ema_series = zeros(6, N_window)
Y_series = zeros(6, length(px))
for i = 1:6
    IR_ema_series(i,:) = ema(Neff_series(i),N_window)
    temp = conv(ema(Neff_series(i), N_window), px-px(1)) + px(1)
    Y_series(i,:) = temp(1:length(px))
end
plot(1:N_window, IR_ema_series)
legend('Neff = 2', 'Neff = 5', 'Neff = 10', 'Neff = 20', 'Neff = 50', 'Neff = 100')
title('EMA Impulse Response')
figure
plot(1:length(px), px, 1:length(px), Y_series)
legend('Price', 'Neff = 2', 'Neff = 5', 'Neff = 10', 'Neff = 20', 'Neff = 50', 'Neff = 100')
title('Convolutions')

%% Problem 7
delay = zeros(6, length(px))
for i = 1:6
    temp = conv(delta(Neff_series(i), N_window), px-px(1)) + px(1)
    delay(i,:) = temp(1:length(px))
    figure
    plot(1:length(px), [delay(i,:); Y_series(i,:)])
    legend('Delay', 'EMA')
    title(sprintf('Neff = %d', Neff_series(i)))
end

%% Problem 8
Neff_pos_series = [2,5,10,20,50]
MACDM1_series = zeros(5, length(px))
for i = 1:5
    temp = conv(macdM1(Neff_pos_series(i), 2*Neff_pos_series(i), N_window), log(px) - log(px(1)))
    MACDM1_series(i,:) = temp(1:length(px))
end

%% Problem 9
MACD_series = zeros(5, length(px))
for i = 1:5
    temp = conv(macd(Neff_pos_series(i), 2*Neff_pos_series(i), N_window), log(px) - log(px(1)))
    MACD_series(i,:) = temp(1:length(px))
    figure
    plot(1:length(px),[MACDM1_series(i,:);MACD_series(i,:)])
    legend('MACDM1', 'MACD')
    title(sprintf('Neff_pos = %d', Neff_pos_series(i)))
end

%% Problem 10
%(a)
Neff_vol = 21
vol_ema = conv(ema(Neff_vol, N_window), vol)
vol_ema = vol_ema(1:length(vol))
%(b)
Neff_vol_pos = 7
Neff_vol_neg = 14
x = conv(unitStep(N_window), vol - vol(1)) + length(vol) * vol(1) 
x = x(1:length(vol))
y = conv(macd(Neff_vol_pos, Neff_vol_neg, N_window)/(Neff_vol_neg-Neff_vol_pos), x-x(1)) + vol(1)
y = y(1:length(vol))
plot(1:length(vol), [vol_ema;y])
legend('EMA','Compound Smoothing', 'Location', 'Southeast')
%(c)
h_cmp = conv(unitStep(length(vol)), macd(Neff_vol_pos, Neff_vol_neg, N_window)/(Neff_vol_pos-Neff_vol_neg))
h_cmp = h_cmp(1:length(vol))
y_new = conv(h_cmp, vol - vol(1)) + vol(1)
y_new = y_new(1:length(vol))
figure
plot(1:length(vol),y_new, 1:length(vol), y, '*')
legend('Compound Smoothing Impolse Response','Compound Smoothing', 'Location', 'Southeast')

%% Problem 11
%(a)
emaIR = ema(32, 256)
deltaIR = delta(192, 256)
plot(1:256, [emaIR;deltaIR])
%(b)
y_open = conv(emaIR, deltaIR)
y_open = y_open(1:length(deltaIR))
%(c)
y_cir = cconv(emaIR, deltaIR)
plot(1:length(y_open), y_open, 1:length(y_open), y_cir)

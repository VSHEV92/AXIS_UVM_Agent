clc
clear

data_samples = 100;
data_max = 255;
data_min = 0;

data = round(rand(data_samples, 1) .* 255);
data = dec2hex(data);

writematrix(data, 'data.txt');



format long g
clear all

%csv = csvread("../dataset/fengyuan_20210705.csv");
csv = csvread("./gps_accuracy_log.csv");

%ms
%timestamp_ms = csv(:, 1);
%m/s^2
h_acc = csv(:, 1);
v_acc = csv(:, 2);

[data_num, dummy] = size(h_acc);
timestamp_s = zeros(1, data_num);
dt = 1 / 100;
for i = 2: data_num
    timestamp_s(i) = (i - 1) .* dt;
end

%%%%%%%%
% Plot %
%%%%%%%%

%accelerometer
figure('Name', 'accelerometer');
subplot (2, 1, 1);
plot(timestamp_s, h_acc);
title('accelerometer');
xlabel('time [s]');
ylabel('ax [m/s^2]');
xlim([0 timestamp_s(end)]) 
subplot (2, 1, 2);
plot(timestamp_s, v_acc);
xlabel('time [s]');
ylabel('ay [m/s^2]');
xlim([0 timestamp_s(end)]) 

disp("Press any key to leave");
pause;
close all;
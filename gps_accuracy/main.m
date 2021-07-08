format long g
clear all

csv = csvread("gps_acc.csv");

time_ms = csv(:, 1);
time_ms = time_ms - time_ms(1);
times_s = time_ms .* 1e-3;
h_acc = csv(:, 2);
v_acc = csv(:, 3);

%%%%%%%%
% Plot %
%%%%%%%%

%accelerometer
figure('Name', 'GNSS Accuracy');
subplot (2, 1, 1);
plot(times_s, h_acc);
title('GNSS accuracy');
xlabel('time [s]');
ylabel('Horizontal accuracy [m]');
xlim([0 times_s(end)]) 
subplot (2, 1, 2);
plot(times_s, v_acc);
xlabel('time [s]');
ylabel('Vertical accuracy [m]');
xlim([0 times_s(end)]) 

disp("Press any key to leave");
pause;
close all;
format long g
clear all

csv = csvread("./vio_compare_optitrack.csv");

%timestamp [ms]
timestamp_ms = csv(:, 1);
timestamp_ms = timestamp_ms - timestamp_ms(1);
timestamp_s = timestamp_ms .* 0.001;
[data_num, dummy] = size(timestamp_ms);

pos_optrack_x = csv(:, 2);
pos_optrack_y = csv(:, 3);
pos_optrack_z = csv(:, 4);
pos_vio_x = csv(:, 5);
pos_vio_y = csv(:, 6);
pos_vio_z = csv(:, 7);

bias_x = mean(pos_vio_x - pos_optrack_x);
bias_y = mean(pos_vio_y - pos_optrack_y);
bias_z = mean(pos_vio_z - pos_optrack_z);

pos_vio_x = pos_vio_x - bias_x;
pos_vio_y = pos_vio_y - bias_y;
pos_vio_z = pos_vio_z - bias_z;

error_x = pos_vio_x - pos_optrack_x;
error_y = pos_vio_y - pos_optrack_y;
error_z = pos_vio_z - pos_optrack_z;

error = zeros(1, data_num);

for i = 1: data_num
    error(i) = sqrt(error_x(i)*error_x(i) + error_y(i)*error_y(i) + error_z(i)*error_z(i));
end

%position
figure('Name', 'GNSS Position');
grid on;
subplot (3, 1, 1);
hold on;
plot(timestamp_s, pos_optrack_x);
plot(timestamp_s, pos_vio_x);
title('VINS-Mono Position Evaluation');
legend('Optitrack', 'VINS-Mono', 'Location', 'best') ;
xlabel('time [s]');
ylabel('x [m]');
xlim([0 timestamp_s(end)]) 
box on
subplot (3, 1, 2);
hold on;
plot(timestamp_s, pos_optrack_y);
plot(timestamp_s, pos_vio_y);
xlabel('time [s]');
ylabel('y [m]');
legend('Optitrack', 'VINS-Mono', 'Location', 'best') ;
xlim([0 timestamp_s(end)]) 
box on
subplot (3, 1, 3);
hold on;
plot(timestamp_s, pos_optrack_z);
plot(timestamp_s, pos_vio_z);
xlabel('time [s]');
ylabel('z [m]');
legend('Optitrack', 'VINS-Mono', 'Location', 'best') ;
xlim([0 timestamp_s(end)]) 
box on

%position
figure('Name', 'GNSS Position');
grid on;
subplot (3, 1, 1);
hold on;
plot(timestamp_s, error_x);
title('Position Error');
xlabel('time [s]');
ylabel('x [m]');
xlim([0 timestamp_s(end)]) 
box on
subplot (3, 1, 2);
hold on;
plot(timestamp_s, error_y);
xlabel('time [s]');
ylabel('y [m]');
xlim([0 timestamp_s(end)]) 
box on
subplot (3, 1, 3);
hold on;
plot(timestamp_s, error_z);
xlabel('time [s]');
ylabel('z [m]');
xlim([0 timestamp_s(end)]) 
box on

%2d position trajectory plot of x-y plane
figure('Name', 'x-y position (enu frame)');
grid on;
hold on;
plot(pos_optrack_x, pos_optrack_y, 'Color', 'r')
plot(pos_vio_x, pos_vio_y, 'Color', 'b');
legend('OptiTrack', 'VINS-Mono') ;
title('Trajectory');
xlabel('x [m]');
ylabel('y [m]');

hold on;
%3d visualization of position trajectory
figure('Name', 'x-y-z position (enu frame)');
hold on;
axis equal;
plot3(pos_optrack_x, pos_optrack_y, pos_optrack_z, 'Color', 'r')
plot3(pos_vio_x, pos_vio_y, pos_vio_z, 'Color', 'b');
%legend('gps trajectory', 'b1 vector', 'b2 vector', 'b3 vector') 
legend('OptiTrack', 'VINS-Mono')
title('Trajectory');
xlabel('x [m]');
ylabel('y [m]');
zlabel('z [m]');
daspect([1 1 1])
grid on
view(56,35);


figure('Name', 'Position Error');
grid on;
hold on;
plot(timestamp_s, error);
title('Position Error');
xlabel('time [s]');
ylabel('Total Error [m]');
xlim([0 timestamp_s(end)]) 
box on

hold on;
disp("Press any key to leave");
pause;
close all;
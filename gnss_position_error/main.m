format long g
clear all

csv = csvread("./gnss_static_placement_20210710.csv");

%timestamp [ms]
timestamp_ms = csv(:, 1);
timestamp_ms = timestamp_ms - timestamp_ms(1);
timestamp_s = timestamp_ms .* 0.001;
[data_num, dummy] = size(timestamp_ms);
%longitude, latitude [deg]
longitude = csv(:, 11);
latitude = csv(:, 12);
longitude = longitude * 1e-7;
latitude = latitude * 1e-7;
gps_ned_x = zeros(1, data_num);
gps_ned_y = zeros(1, data_num);
%velocity [m/s]
gps_ned_vx = csv(:, 14);
gps_ned_vy = csv(:, 15);
gps_ned_vz = csv(:, 16);

%set home position
ekf = ekf_estimator;
home_longitude = longitude(1);
home_latitude = latitude(1);
ekf = ekf.set_home_longitude_latitude(home_longitude, home_latitude, 0);

%position rmse
pos_true_x = zeros(1, data_num);
pos_true_y = zeros(1, data_num);
x_mean = mean(gps_ned_vx);
y_mean = mean(gps_ned_vy);
p_RMSE = zeros(1, data_num);

%velocity rmse
vel_true_x = zeros(1, data_num);
vel_true_y = zeros(1, data_num);
vx_mean = mean(gps_ned_vx);
vy_mean = mean(gps_ned_vy);
v_RMSE = sqrt((gps_ned_vx - vx_mean) .* (gps_ned_vx - vx_mean) + (gps_ned_vy - vy_mean) .* (gps_ned_vy - vy_mean));

for i = 2: data_num
    pos_ned = ekf.covert_geographic_to_ned_frame(longitude(i), latitude(i), 0);
    gps_ned_x(i) = pos_ned(1);
    gps_ned_y(i) = pos_ned(2);
    gps_ned_z(i) = pos_ned(3);
    gps_error(i) = sqrt(gps_ned_x(i)*gps_ned_x(i) + gps_ned_y(i)*gps_ned_y(i));
    RMSE(i) = sqrt((gps_ned_x(i) - x_mean) .* (gps_ned_x(i) - x_mean) + (gps_ned_y(i) - y_mean) .* (gps_ned_y(i) - y_mean));
end

%%%%%%%%
% Plot %
%%%%%%%%

%raw position vs fused position
figure('Name', 'GNSS Position');
grid on;
subplot (2, 1, 1);
hold on;
plot(timestamp_s(2: end), gps_ned_x(2: end));
plot(timestamp_s(2: end), pos_true_x(2: end));
title('GNSS Position');
legend('GNSS X Position', 'True X Position', 'Location', 'best') ;
xlabel('time [s]');
ylabel('x [m]');
xlim([0 timestamp_s(end)]) 
box on
subplot (2, 1, 2);
hold on;
plot(timestamp_s(2: end), gps_ned_y(2: end));
plot(timestamp_s(2: end), pos_true_y(2: end));
xlabel('time [s]');
ylabel('y [m]');
legend('GNSS Y Position', 'True Y Position', 'Location', 'best') ;
xlim([0 timestamp_s(end)]) 
box on

%gps velocity
figure('Name', 'GNSS Velocity');
grid on;
subplot (2, 1, 1);
hold on;
plot(timestamp_s(2: end), gps_ned_vx(2: end));
plot(timestamp_s(2: end), vel_true_x(2: end));
title('GNSS Velocity');
legend('GNSS X Velocity', 'True X Velocity', 'Location', 'best') ;
xlabel('time [s]');
ylabel('x [m/s]');
xlim([0 timestamp_s(end)])
ylim([-0.2 0.2])
box on
subplot (2, 1, 2);
hold on;
plot(timestamp_s(2: end), gps_ned_vy(2: end));
plot(timestamp_s(2: end), vel_true_y(2: end));
xlabel('time [s]');
ylabel('y [m/s]');
legend('GNSS Y Velocity', 'True Y Velocity', 'Location', 'best') ;
xlim([0 timestamp_s(end)])
ylim([-0.2 0.2])
box on

figure('Name', 'GNSS Position RMSE');
grid on;
hold on;
plot(timestamp_s, RMSE);
title('GNSS Position Error');
xlabel('time [s]');
ylabel('Position Error [m]');
xlim([0 timestamp_s(end)]) 
box on

figure('Name', 'GNSS Velocity RMSE');
grid on;
hold on;
plot(timestamp_s, v_RMSE);
title('GNSS Velocity Error');
xlabel('time [s]');
ylabel('Velocity Error [m/s]');
xlim([0 timestamp_s(end)]) 
box on

hold on;
disp("Press any key to leave");
pause;
close all;
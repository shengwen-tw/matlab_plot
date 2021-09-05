close all

%=========================%
% parameters for plotting %
%=========================%
bag_select = "2020-12-14-15-42-47.bag";
%bag_select = "optitrack_heart_5s_hovering_param.bag"

start_index = 1042;
end_index = 3922;

%==================%
% open rosbag file %
%==================%
bag = rosbag(bag_select);

%==============================%
% obtain time data from rosout %
%==============================%
t_bag = select(bag, 'topic', 'rosout');
t_msgStructs = readMessages(t_bag, 'DataFormat', 'struct');
t = cellfun(@(m) double(m.Header.Stamp.Sec), t_msgStructs);
t_nsec = cellfun(@(m) double(m.Header.Stamp.Nsec), t_msgStructs);
[time_arr_size, dummy] = size(t);

%========================%
% obtain uav states data %
%========================%
x_bag = select(bag, 'topic', 'uav/x');
y_bag = select(bag, 'topic', 'uav/y');
z_bag = select(bag, 'topic', 'uav/z');
x_msgStructs = readMessages(x_bag, 'DataFormat', 'struct');
y_msgStructs = readMessages(y_bag, 'DataFormat', 'struct');
z_msgStructs = readMessages(z_bag, 'DataFormat', 'struct');
x = cellfun(@(m) double(m.Data), x_msgStructs);
y = cellfun(@(m) double(m.Data), y_msgStructs);
z = cellfun(@(m) double(m.Data), z_msgStructs);

%================================%
% obtain desired trajectory data %
%================================%
xd_bag = select(bag, 'topic', 'uav/x_des');
yd_bag = select(bag, 'topic', 'uav/y_des');
zd_bag = select(bag, 'topic', 'uav/z_des');
xd_msgStructs = readMessages(xd_bag, 'DataFormat', 'struct');
yd_msgStructs = readMessages(yd_bag, 'DataFormat', 'struct');
zd_msgStructs = readMessages(zd_bag, 'DataFormat', 'struct');
xd = cellfun(@(m) double(m.Data), xd_msgStructs);
yd = cellfun(@(m) double(m.Data), yd_msgStructs);
zd = cellfun(@(m) double(m.Data), zd_msgStructs);

%==============================%
% delete the uninterested part %
%==============================%
t(end_index:end) = [];
t_nsec(end_index:end) = [];
t = t - t(1);
t_nsec = t_nsec - t_nsec(1);
t = t + t_nsec * 10^(-9);

x(1:start_index) = [];
y(1:start_index) = [];
z(1:start_index) = [];
xd(1:start_index) = [];
yd(1:start_index) = [];
zd(1:start_index) = [];

x(end_index:end) = [];
y(end_index:end) = [];
z(end_index:end) = [];
xd(end_index:end) = [];
yd(end_index:end) = [];
zd(end_index:end) = [];

%====================================================%
%calculate RMSE of the geometric tracking controller %
%====================================================%
ex = x - xd;
ey = y - yd;
ey_mean = mean(ey);
ex_mean = mean(ex);
RMSE = sqrt((ex - ex_mean) .* (ex - ex_mean) + (ey - ey_mean) .* (ey - ey_mean));

%======%
% plot %
%======%
figure
plot(t, x, 'b')
hold on
plot(t, xd, 'r')
xlabel('Time [s]')
ylabel('x [m]');
ylim([-1.5 1.5])
xlim([0, t(end)])
legend('True state', 'Trajectory')
title('Trajectory tracking in X direction [m]')

figure
plot(t, y, 'b')
hold on
plot(t, yd, 'r')
xlabel('Time [s]')
ylabel('y [m]');
ylim([-1.3 1.3])
xlim([0, t(end)])
legend('True state', 'Trajectory')
title('Trajectory tracking in Y direction [m]')

figure
plot(t, x-xd, 'b')
hold on
plot(t, y-yd, 'r')
xlabel('Time [s]')
ylabel('Error [m]');
ylim([-1.5 1.5])
xlim([0, t(end)])
legend('X error', 'Y error')
title('Position Error')

figure
plot(t, RMSE, 'b')
xlabel('Time [s]')
ylabel('Total Error [m]');
ylim([-1.5 1.5])
xlim([0, t(end)])
legend('Position RMSE')
title('Position RMSE')
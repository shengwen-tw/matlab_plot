clear all;
percent = [0; 5; 10; 15; 20; 25; 30; 35; 40; 45; 50; 55; 60; 65; 70; 75; 80; 85; 90; 95; 100];
thrust = [0; 28; 37; 68; 106; 153; 194; 233; 284; 350; 417; 496; 561; 650; 735; 803; 871; 952; 1120; 1152; 1221];
curve = zeros(21, 0);

c5 = -1335;
c4 = 2556.1;
c3 = -1886;
c2 = 1655.9;
c1 = 235.46;
c0 = 2.6257;

for i = 1:21
    x1 = percent(i) / 100;
    x2 = x1*x1;
    x3 = x2*x1;
    x4 = x3*x1;
    x5 = x4*x1;
    curve(i) = c5*x5 + c4*x4 + c3*x3 + c2*x2 + c1*x1 + c0;
end

figure;
hold on;
plot(percent, thrust, 'Marker', '.', 'MarkerSize', 5)
plot(percent, curve, 'Color', 'r');
title('Motor Thrust Curve');
xlabel('ESC command [%]');
ylabel('Thrust [gram-force]');
xlim([0 percent(end)])
legend('Measurement', 'Approximate curve')
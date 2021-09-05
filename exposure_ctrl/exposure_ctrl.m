csv = csvread("exposure_response.csv");

exp_ = csv(:, 1)
grade = csv(:, 2)

figure(1);
plot(exp_, grade);
title('Exposure Value Response');
xlabel('Exposure value');
ylabel('Laplacian grading value');
xlim([0 exp_(end)]) 
ax = gca;
ax.XRuler.Exponent = 0;
xtickangle(45)


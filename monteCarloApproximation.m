clear; clc; close all;

% Monte Carlo Approximation of Pi
numOfIter = 20;
pi_est = zeros(1, numOfIter);
N_values = zeros(1, numOfIter); % To store the number of points at each iteration
error_values = zeros(1, numOfIter); % To store the error

N = 100; % Starting number of points

for i = 1:numOfIter
    x = rand(1,N);
    y = rand(1,N);
    
    dist = sqrt(x.^2 + y.^2);
    points_in_unit = sum(dist <= 1);
    
    pi_estimate = 4 * points_in_unit / N;
    pi_est(i) = pi_estimate;
    
    % Store N and corresponding error
    N_values(i) = N;
    error_values(i) = abs(pi - pi_estimate);
    
    % Double the number of points for the next iteration
    N = 2*N;
end

% ---- PLOT 1: Approximation of Pi over Iterations ----
figure;
subplot(2,1,1); % Create a subplot (first panel)
plot(1:numOfIter, pi_est, '-o', 'LineWidth', 1.5);
hold on;
yline(pi, 'r--', 'LineWidth', 1.5); % Reference line at true pi
grid on;
xlabel('Iteration');
ylabel('Approximate value of \pi');
title('Monte Carlo Approximation of \pi');
legend('Estimated \pi', 'True \pi', 'Location', 'best');

% ---- PLOT 2: Error vs. Computational Complexity ----
subplot(2,1,2); % Create a subplot (second panel)
loglog(N_values, error_values, '-o', 'LineWidth', 1.5);
grid on;
xlabel('Number of Points (N)');
ylabel('Error of \pi estimate');
title('Error vs. Computational Complexity');
legend('Error', 'Location', 'best');

%% Estimate variamnce
clear; clc; close all;
% Monte Carlo Approximation of Pi
numOfIter = 10;
pi_est = zeros(1, numOfIter);
N_values = zeros(1, numOfIter); % To store the number of points at each iteration
error_values = zeros(1, numOfIter); % To store the error

N = 10^4; % Starting number of points

for i = 1:numOfIter
    x = rand(1,N);
    y = rand(1,N);
    
    dist = sqrt(x.^2 + y.^2);
    points_in_unit = sum(dist <= 1);
    
    pi_estimate = 4 * points_in_unit / N;
    pi_est(i) = pi_estimate;
    
    % Store N and corresponding error
    N_values(i) = N;
    error_values(i) = pi - pi_estimate;
end
error_var = var(error_values);

% ---- PLOT 1: Error over Iterations ----
figure;
plot(1:numOfIter,error_values, '-o', 'LineWidth', 1.5);
hold on;
yline(0, 'r--', 'LineWidth', 1.5); % Reference line at zero
grid on;
xlabel('Iteration');
ylabel('Error of \pi estimate');
title('Monte Carlo Approximation of \pi');

% Display variance on the plot
variance_text = sprintf('Variance of Error: %.5f', error_var);
text(2, max(mean(error_values, 1)) * 0.8, variance_text, 'FontSize', 12, 'Color', 'red');

legend('Mean Error', 'Zero Reference', 'Location', 'best');
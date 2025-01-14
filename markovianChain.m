% set variables
a = 0.1;
c = 0.1;
b = 0.1;
steps = 1003;

transitionMatrix = [0  1-a-b   a   b   0;
                    0    0     1   0   0;
                    0    0     0  1-c  c;
                    1    0     0   0   0;
                    0    0    0.5  0  0.5];

% used to automatically switch between initial states
initialStateMat    = eye(5);

% store distributions
distributionMatrix = zeros(steps, 5, 5) ;

for initialState = 1:5
    initDistribution = initialStateMat(initialState,:);
    
    % store initial distribution to array
    distributionMatrix(1, : ,initialState) = initDistribution;
    for i=2:steps
        initDistribution = initDistribution*transitionMatrix;
        % store further distributions in matrix
        distributionMatrix(i, : ,initialState) = initDistribution;
    end
end

% we choose the time points of interest:
timeOfInterest = [1000 1001 1002 1003];

figure('Name','Distributions at t=1000,1001,1002,1003'); 

for i = 1:length(timeOfInterest)
    t = timeOfInterest(i);
    
    % Create one subplot for each time
    subplot(2,2,i);  
    hold on;
    
    % Plot distribution for each initial state s=1..5
    for s = 1:5
        % distributionMatrix(t, :, s) is a row vector of length 5
        distVec = squeeze(distributionMatrix(t, :, s));
        
        % Plot it as a line with markers
        plot(1:5, distVec, '-o', 'LineWidth',1.5,...
            'DisplayName', sprintf('InitState=%d', s));
    end
    
    hold off;
    xlabel('State');
    ylabel('Probability');
    title(sprintf('Distribution at t = %d', t));
    legend('Location','best');
    axis([1 5 0 1]);  % states on x-axis from 1..5, probability in [0..1]
    grid on;
end


%% Randomly generate trajectory

% set variables
a = 0.1;
c = 0.1;
b = 0.1;
steps = 10000;

transitionMatrix = [0  1-a-b   a   b   0;
                    0    0     1   0   0;
                    0    0     0  1-c  c;
                    1    0     0   0   0;
                    0    0    0.5  0  0.5];

% store distributions
trajectory = zeros(1, steps);

initState = [1 0 0 0 0];
    
% store initial distribution to array
trajectory(1) = 1;
for i=2:steps
    initDistribution = initState*transitionMatrix;
    % store further distributions in matrix
    
    initState = randsample(1:5,1, true, initDistribution);
    trajectory(i) = initState;
    initDist  = zeros(1,5);
    initDist(initState) = 1;
    initState = initDist;
end



% Enhanced plot for the Markov Chain trajectory
figure('Name', 'Markov Chain Trajectory', 'Color', 'white'); % Set a white background

% Plot the trajectory
plot(1:steps, trajectory, 'LineWidth', 2, 'Color', [0.2 0.4 0.8]); % Use a nice blue color

% Add grid, labels, and limits
grid on;
ylabel('State', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time Step', 'FontSize', 14, 'FontWeight', 'bold');
ylim([0 6]);
xlim([1 100]);

% Add title
title('Markov Chain Trajectory Sample', 'FontSize', 16, 'FontWeight', 'bold');

% Adjust tick labels for clarity
xticks(0:10:100);
yticks(1:5);
ax = gca; % Get current axes
ax.FontSize = 12;
ax.LineWidth = 1.2;

% Pretty histogram of the Markov Chain trajectory
figure('Name', 'Markov Chain State Distribution', 'Color', 'white'); % White background

% Create histogram
histogram(trajectory, 'Normalization', 'probability', 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'black');

% Add grid, labels, and title
grid on;
xlabel('State', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Probability', 'FontSize', 12, 'FontWeight', 'bold');
title('State Distribution of Markov Chain', 'FontSize', 12, 'FontWeight', 'bold');

% Set axis limits and ticks
xlim([0.5, 5.5]); % Assuming states are integers 1 through 5
xticks(1:5); % States are 1, 2, 3, 4, 5
yticks(0:0.1:1); % Probability range
ylim([0, 1]); % Assuming probabilities between 0 and 1

% Find left eigenvector of transition matrix (convering distribution)
stationaryDistribution = null(eye(size(transitionMatrix)) - transitionMatrix', 'r');
stationaryDistribution = stationaryDistribution / sum(stationaryDistribution);

% Display the result
disp('Stationary distribution:');
disp(stationaryDistribution);
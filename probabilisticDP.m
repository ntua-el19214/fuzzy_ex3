close all; clear; clc;

optimalParking = zeros(1,10);
selectedPosition = zeros(1,10);

for iRepetitions = 1:10
    % Probabilistic DP solution for parking problem
    N = 200;                            % Number of spaces
    C = 100;                            % Terminal state cost
    p = 0.05;
    expectedCost_ocupied = zeros(1,N);  % expected cost array if space k is occupied
    expectedCost_empty   = zeros(1,N);  % expected cost array if space k is empty
    
    % Initialize arrays
    expectedCost_ocupied(N) = C;
    expectedCost_empty(N)   = min(C, cost_k(N,N));
    probability_i           = 0.05*ones(1,N);
    
    for iPosition = N-1:-1:1
        cost_of_next_empty = probability_i(iPosition+1)*expectedCost_empty(iPosition+1) +...
                             (1-probability_i(iPosition+1))*expectedCost_ocupied(iPosition+1);
    
        expectedCost_empty(iPosition)   = min(cost_k(N,iPosition), cost_of_next_empty);
        expectedCost_ocupied(iPosition) = cost_of_next_empty;
    
    end
    
    
    %% Simulate system
    parkingSpace = zeros(1,N);
    
    % Initialize parking spots with probability
    for iSpot = 1:N
        x=rand;
        if x<0.05
          select=1;
        else
          select=0;
        end
        parkingSpace(iSpot) = select;
    end
    
    % store optimal praking spot
    idx = find(parkingSpace >0);
    optimalParking(iRepetitions) = idx(end);
    for currentPos = 1:N-1
        park_cost = cost_k(N, currentPos);
        no_park_cost = (1-p)*expectedCost_ocupied(currentPos+1) + p*expectedCost_empty(currentPos+1);
        if parkingSpace(currentPos) && (park_cost < no_park_cost)
            fprintf("Parking at position: %d\n", currentPos)
            selectedPosition(iRepetitions) = currentPos;
            break
        elseif currentPos == N-1
            fprintf("Parking at position: Parking\n")
            selectedPosition(iRepetitions) = 0;
        end
    
    end
end 

figure;
plot(1:10, selectedPosition, '-o', 'LineWidth', 1.5);
hold on;
plot(1:10, optimalParking, '-x', 'LineWidth', 1.5);

% Find indices where selectedPosition is 0
idx = find(selectedPosition == 0);

% Label those points as "Parking"
for i = 1:length(idx)
    text(idx(i), selectedPosition(idx(i)), ' Parking', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', 'red');
end

grid on;
xlabel('Iteration');
ylabel('Parking Spot');
title('Selected parking spot compared with optimal parking spot');
legend('Selected Spot', 'Optimal Spot');



%% All functions go here

function cost = cost_k(N, position)
    cost = N-position;
end

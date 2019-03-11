function balanceGame(m)
%balanceGame Runs a game of bar chart dodge ball... driven by a balance
%board.
%   The game takes either a microbit object, a char array specifying the
%   port connected to the board, or no parameters.
if nargin == 1
    if ischar(m)
        micro = microbit(m);
    else
        micro = m;
    end
else
    micro = microbit();
end

figure('MenuBar','none','Color','black',...
    'name','Balance Hunter',...
    'BackingStore','on');

% Record the top times people have lasted without being hit.
top_times = zeros(10,1);

H = uicontrol('Style', 'PushButton', ...
                    'String', 'End Game', ...
                    'Callback', 'delete(gcbf)');

% Really should find a better way to manage the application, but this will
% allow us to track the best time, and pause for 10 seconds between games
while (ishandle(H))
   colormap(hot);

   % Run a single game and record the player's time
   t = runGame(micro);
   
   % check if t is a top 10 time
   B = top_times < t;
   if B(10) ~= 0
       top_times(10) = t;
       top_times = sort(top_times, 'descend');
   end
   
   % C is the game area
   C = zeros(100);
   pcolor(C);
   
   % Print top ten times
   text(10,90, 'GAME OVER','color','w','FontSize',25);
   text(10,80, 'Your time was: ','color','w','FontSize',25);
   text(10,70, num2str(t),'color','w','FontSize',25);
   text(10,60, 'Top Times','color','w','FontSize',25);
   for i=1:length(top_times)
       text(38,58 -(i*5), num2str(top_times(i)),'color','w', ...
           'FontSize',15);
   end
   
   % Wait 10 seconds before starting the next game
   pause(10);
end

end

function t = runGame(m)
%runGame Runs a single game of bar chart dodge ball, tracking how long the
% user has lasted without hitting an obstacle.

C = zeros(100);
count = 0;

% updateRate controls how much time between each sreen refresh
updateRate = 0.04;

% obstacleCount controls the number of obstacles on the screen at once
obstacleCount = 50;

% Each obstacle will have a level, row and column
obstacles = zeros(obstacleCount,3);
obstacleIndex = 1;

% Player will start in the middle of screen, towards the bottom
playerRow = 10;
playerCol = 50;

endgame = 0;
filteredData = 0;
alpha = 0.3;

obstacleColor = 0.6;
playerColor = 0.3;

while endgame == 0
    
    % If needed, create a obstacle
    if mod(count,(100/obstacleCount)) == 0
        % Start the obstacle at a random column, near the top of the
        % screen.
        col = floor(rand()*100);
        if col < 1
            col = 1;
        end
        obstacles(obstacleIndex, 1) = col;
        obstacles(obstacleIndex, 2) = 100;
        % Give the obstacle a random length to 20
        obstacles(obstacleIndex, 3) = floor(rand * 20);
        obstacleIndex = obstacleIndex+1;
        if obstacleIndex > obstacleCount
           obstacleIndex = 1; 
        end
    end
    
    % Update the positions of all the obstacles, dropping them down a
    % row towards the bottom of the screen.
    for i = 1:length(obstacles)
        row = obstacles(i,2);
        if (row > 1)
            oldRow = row;
            row = oldRow -2;
            if row <= 0
               row = 1; 
            end
            obstacles(i,2) = row;
            for j = 1:obstacles(i,3)
                C(oldRow, j + obstacles(i,1)) = 0;
                C(row, j + obstacles(i,1)) = obstacleColor;
            end 
        end
    end
 
    % Set the players previous position to black
    C(playerRow, playerCol) = 0;
    C(playerRow, playerCol-1) = 0;
    C(playerRow, playerCol+1) = 0;
    
    % Read the acceleration data from the microbit
    [data] = readAcceleration(m);
    
    % Convert the accleration value to the chart co-ordinates
    rawColumn = abs(50 - (data(1) * 15));
    % Use a low pass filter on the co-ordinates
    filteredData = (1 - alpha)*filteredData + (alpha*rawColumn);
    
    playerCol = round(filteredData);
    
    % Check if the player hit an obstacle
    if any(obstacles(:,2) == playerRow)
        for i = 1:length(obstacles)
            if playerRow == obstacles(i,2) && ...
                playerCol >= obstacles(i,1) && ...
                    playerCol <= (obstacles(i,1) + obstacles(i,3))
                endgame = 1; 
            end
        end
    end
    
    % Make sure the player position doesn't go out of bounds
    if playerCol < 2
        playerCol = 2;
    elseif playerCol > 99
        playerCol = 99;
    end
        
    % Render the player's new position
    C(playerRow, playerCol) = playerColor;
    C(playerRow, playerCol-1) = playerColor;
    C(playerRow, playerCol+1) = playerColor;
    pcolor(C);
    
    % Display the time
    text(-10,90, num2str(floor(count/10)),'color','w','FontSize',45);

    if mod(count, 10) == 0
       updateRate = updateRate * 0.9; 
    end
    pause(updateRate);
    count = count+1;
end

t=count / 10;
end






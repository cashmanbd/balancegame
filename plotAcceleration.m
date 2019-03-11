function plotAcceleration(m)
%PLOTACCELERATION Demonstrate how different alpha values affect the 
% filtering of the microbit's acceleration data.

figure;

plotTitle = 'Microbit Acceleration';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Acceleration';      % y-axis label
legend1 = 'X'
legend2 = 'Y'
legend3 = 'Z'
yMax  = 100                           %y Maximum Value
yMin  = -20                       %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = -20;                         % set y-min
max = 100;                        % set y-max
delay = .1;                     % make sure sample faster than resolution 
%Define Function Variables
time = 0;
data = 0;
data1 = 0;
data2 = 0;
count = 0;

alpha1 = 0.3;
alpha2 = 0.2;
alpha3 = 0.1;

%Set up Plot
plotGraph = plot(time,data,'-r' )  % every AnalogRead needs to be on its own Plotgraph
hold on                            %hold on makes sure all of the channels are plotted
plotGraph1 = plot(time,data1,'-b')
plotGraph2 = plot(time, data2,'-g' )
title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1,legend2,legend3)
axis([yMin yMax min max]);
grid(plotGrid);

filteredData1 = 0;
filteredData2 = 0;

filteredData3 = 0;

tic

while ishandle(plotGraph) %Loop when Plot is Active will run until plot is closed
    [rawData] = readAcceleration(m);            
    count = count + 1;    
    time(count) = toc;     
    
     % Convert the accleration value to the chart co-ordinates
    rawColumn = abs(50 - (rawData(1) * 15));
    % Use a low pass filter on the co-ordinates
    filteredData1 = (1 - alpha1)*filteredData1 + (alpha1*rawColumn);
    
    filteredData2 = (1 - alpha2)*filteredData2 + (alpha2*rawColumn);
    
    filteredData3 = (1 - alpha3)*filteredData3 + (alpha3*rawColumn);
    
    data(count) = filteredData1;
    data1(count) = filteredData2;
    data2(count) = filteredData3;
    
    set(plotGraph,'XData',time,'YData',data);
    set(plotGraph1,'XData',time,'YData',data1);
    set(plotGraph2,'XData',time,'YData',data2);
    
    xmin = 0;
    axis([xmin time(count) min max]);
    %Update the graph
    pause(delay);
  end

end


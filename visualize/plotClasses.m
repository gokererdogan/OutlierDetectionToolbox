% Plot Classes
% Summary
%   Plots samples in x according to their classes
%
% Input(s)
%   x: 2D samples
%   y: Class labels
% Output(s)
%   h: handle to plot
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
function h = plotClasses(x, y)
    colors = 'brgymk';
    markers ='od';
    classes = unique(y);
    cc = size(classes,1);
    
    h = figure;
    hold on    
    for i = 1:cc
        plot(x(y==classes(i),1), x(y==classes(i),2), [colors(mod((i-1),6)+1) markers(mod((i-1),2)+1)]);
    end
end
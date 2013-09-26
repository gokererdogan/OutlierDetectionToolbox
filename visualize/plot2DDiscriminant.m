function plot2DDiscriminant(gxi, gyi, scores, theta, is3d)
% Plot discriminants given points and their scores
%
% Summary
%   Drwas lines through points where scores are equal to different 
%   theta threshold values to show decision boundaries of a method
%   
% Input(s): 
%   gxi, gyi: matrices from meshgrid that are used to create the points
%   scores: score for each point
%   theta: threshold value
%   is3d: if >0 plots in 3 dimensions
%
% Output(s): none
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    % gxi and gyi are matrices from meshgrid
    % normalize z and theta, otherwise color problems will arise when used
    % in same plot with scatter
    mins = min(scores);
    maxs = max(scores);
    scores = NormalizeToZeroOne(scores);
    theta = (theta - mins) ./ (maxs - mins);
    hc = histc(scores,0:0.2:1);
    hc = hc ./ sum(hc);
    chc = 1 - cumsum(hc);
    z = reshape(scores, size(gxi,1), size(gxi,2));  
    
    [C, h] = contour(gxi, gyi, z, chc(1:5));
    % make sure that normalized theta is a valid value
    % since theta is calculated from original data, and scores belong to
    % grid data, theta may not be in range of scores
    if theta > 0 && theta < 1
        hold on
        contour(gxi, gyi, z, theta, '--', 'LineWidth', 2);
    end
     
    
    if nargin > 4 && is3d > 0
        hold on
        [~, h] = contour(gxi, gyi, z, .05, '-', 'LineWidth', 1);        
        %[~, h] = contour(gxi, gyi, z, .1, '--', 'LineWidth', 2);
        [~, h] = contour(gxi, gyi, z, .2, '--', 'LineWidth', 1);
        [~, h] = contour(gxi, gyi, z, .4, '-', 'LineWidth', 1);
        [~, h] = contour(gxi, gyi, z, .6, '--', 'LineWidth', 1);
        [~, h] = contour(gxi, gyi, z, .8, '-', 'LineWidth', 1);
        mesh(gxi, gyi, z+1, z);
        view(3);
        grid on;
    end
end
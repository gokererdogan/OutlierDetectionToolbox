function [x, y, points] = GetCartesianGrid(rangex, rangey)
%
% Get all points from grid in range: (rangex, rangey)
%
%
% Input(s)
%   rangex: an array containing grid x points
%   rangex: an array containing grid y points
%
% Output(s)
%   x: output of meshgrid function
%   y: output of meshgrid function
%   points: Nx2 matrix where each row contains a point from grid
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    [x y] = meshgrid(rangex, rangey);
    points = [reshape(x, size(x,1)*size(x,2), 1) reshape(y, size(y,1)*size(y,2), 1)];    
end
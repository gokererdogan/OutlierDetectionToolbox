function nx = GetSamplesFromClass(x, y, classes)
% Gets samples belonging to given classes from dataset
%
% Notes
% Useful for obtaining training data for methods that only use normal data 
%  to train
%
% Input(s)
%   x: input data
%   y: class labels
%   classes: requested class
%
% Output(s)
%   nx: data containing instances only from requested classes
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    nx = x;
    nx(~ismember(y, classes),:) = [];
end
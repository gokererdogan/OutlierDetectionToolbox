function x = SubtractMean(x)
%
% Subtract mean of data, i.e. center data. 
% Note: Columns are centered since each columns is an attribute
%
% Input(s)
%   x: input data
%
% Output(s)
%   x: mean centered data
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    x = x - repmat( mean(x), size(x,1), 1 );
end
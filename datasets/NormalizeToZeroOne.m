function nx = NormalizeToZeroOne(x)
%
% Normalizes data in x to 0-1 interval
%
% Notes
% Columns are normalized since each column is an attribute
%
% Input(s)
%   x: data
%
% Output(s)
%   nx: data normalized to 0-1 interval
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    N = size(x,1);
    nx = (x - repmat(min(x), N, 1)) ./ repmat(max(x) - min(x), N, 1);
    % if any value becomes NaN that means min and max are very close, so
    % replace all NaNs with zero
    nx(isnan(nx)) = 0;
end
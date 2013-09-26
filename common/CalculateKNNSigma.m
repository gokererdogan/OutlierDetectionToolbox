function sigma = CalculateKNNSigma(x, neighbors, k)
%
% Calculates variance for a Gaussian kernel for a given k, neighbor count
%
% Summary
%   Variance is set to be average of distances to kth neighbors
%
% Input(s)
%   x: data
%   neighbors: a matrix where each row i holds the neighbors of instance i
%           Constructed with GetNeighbors function
%   k: neighbor count
%
% Output(s)
%   results: results structure containing the following
%       results.y: class labels for test data, 1 if normal, 2 if outlier
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    N = size(x, 1);
	totKDist = 0;
	% find k-nn and calculate sigma
	for i = 1:N
		% distance to kth neighbor
        dist = sum((x(i,:) - x(neighbors(i,k),:)).^2);
		totKDist = totKDist + sqrt(dist);		
	end
	avgDist = totKDist / N;
	% std = mean(k-nn dist) / 1
	sigma = avgDist^2 / 1;
	
end
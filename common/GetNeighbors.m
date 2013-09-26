function neighbors = GetNeighbors(x, k)
%
% Find k neighbors of instances
%
%
% Input(s)
%   x: input data. instances on rows
%   k: number of neighbors to find for each instance
%
% Output(s)
%   neighbors: Nxk matrix where each row contains the indices of neighbors
%   of an instance.
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    N = size(x, 1);
	neighbors = zeros(N,k);
	
    for i = 1:N
        dx = sum( ( repmat( x(i,:), N, 1) - x).^2, 2 );        
        dx(i) = max(dx)+1;
        % find the k neigbors
        for m = 1:k
            n = find(dx==min(dx));
            if numel(n) > 1
                n = n(1);
            end
            neighbors(i, m) = n;
            dx(n) = max(dx)+1;
        end
    end
end
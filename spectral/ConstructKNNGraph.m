function [d w] = ConstructKNNGraph(ds, neighbors, kernel)
%
% Construct k-nn graph and calculate adjacency matrix with given kernel
%
% Notes: 1) If an adjacency graph with the same parameters are already 
%       calculated, returns it. (Looks for a file under data set path)
%
%       2) For Gaussian kernel, in order to ensure a connected graph, 
%       if two instances are neighbors and the weight between them is 
%       below a certain threshold (eps in code), these weights are set to 
%       10 percent of more of the minimum weight in graph.
%
% Input(s)
%   ds: Dataset structure containing x and path (data set folder)
%   neighbors: matrix containing neighbors for each instance. Can be
%       constructed with GetNeighbors function
%   kernel: kernel structure containing
%       name: gaussian, constant or poly
%       k: neighbor count
%       s: required only if gaussian kernel, variance paramater
%
% Output(s)
%   w: sparse adjacency matrix
%   d: diagonal matrix of row sums of w
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    distType = 0;
    if strcmpi(kernel.name, 'gaussian')
        distType = 1;
        sigma = kernel.s;
    elseif strcmpi(kernel.name, 'poly')
        distType = 2;
    end
    x = ds.x;
    eps = 1e-4; % distance threshold for gaussian kernel
    minsim = 1.0; % minimum similarity encountered so far for gaussian kernel
    maxsim = 0.0; % maximum similarity encountered so far for gaussian kernel
    updIndices = []; % keeps i,j indices of weights (that are too small) that need to be updated in the second pass
    N = size(x, 1);
    % vectors for holding i,j of nonzero elements and value in w(i,j)
    % used for constructing sparse matrice
    ijws = [];
    k = kernel.k;
    
    % check if similarity matrice is already available
    fn = sprintf('%s/%s_%s.mat', ds.path, ds.name, GetKernelParamString(kernel));
    if exist(fn, 'file')
        load(fn,'w');
        d = diag(sum(w, 2));	
        fprintf('Loaded w matrice for %s\n', GetKernelParamString(kernel));
        return;
    end
    
	% update similarity values with respect to calculated sigma
    for i = 1:N
        % find the k neigbors
        for m = 1:k+1            
            if m == k+1 %connect each instance to itself (every instance is neighbor of itself)
                n = i;
            else
                n = neighbors(i, m);            
            end
            
            if distType == 0 % constant kernel
                % if this edge is not already constructed
                if ~hasEdge(ijws, i, n)
                    ijws = [ijws; i n 1];
                    if i~=n
                        ijws = [ijws; n i 1];                    
                    end
                end
            elseif distType == 1 % gaussian kernel
                dist = sum((x(i,:) - x(n,:)).^2);
                sim = exp( - dist / (sigma) );
                if sim > eps % no problem, update similarity
                    % if this edge is not already constructed
                    if ~hasEdge(ijws, i, n)
                        ijws = [ijws; i n sim];
                        if i~=n
                            ijws = [ijws; n i sim];                    
                        end
                    end
                    % update minsim, maxsim if necessary
                    if minsim > sim
                        minsim = sim;
                    end
                    if maxsim < sim
                        maxsim = sim;
                    end
                else % sim is too small, update it later
                    % update minsim if necessary
                    if minsim > sim
                        minsim = sim;
                    end
                    if ~hasEdge(updIndices, i, n)
                        updIndices = [updIndices; i n];
                        if i~=n
                            updIndices = [updIndices; n i];
                        end
                    end                    
                end
            elseif distType == 2 % polynomial kernel
                sim = ((x(i,:) * x(n,:)') + 1)^2;
                % if this edge is not already constructed
                if ~hasEdge(ijws, i, n)
                    ijws = [ijws; i n sim];
                    if i~=n
                        ijws = [ijws; n i sim];                    
                    end
                end
            end            
        end
    end
    
    if distType == 1
        % if gaussian kernel, update weights that were too small to prevent
        % disconnected components in graph
        % use the (minsim + 10% of similarity interval) as value
        sim = minsim + (maxsim - minsim)*.1;
        ijws = [ijws; [updIndices ones(size(updIndices,1),1)*sim]];
    end
    % construct graph matrice and diagonal degree matrice
    w = sparse(ijws(:,1), ijws(:,2), ijws(:,3), N, N);
	d = diag(sum(w, 2));	
    
    % save w
    fn = sprintf('%s/%s_%s.mat', ds.path, ds.name, GetKernelParamString(kernel));
    save(fn,'w');
end

function tf = hasEdge(ijws, i, j)
    if isempty(ijws)
        tf = 0;
        return
    end
    if sum((ijws(:,1)==i) & (ijws(:,2)==j)) > 0
        tf = 1;
    else
        tf = 0;
    end
end

function lem = LaplacianEigenmap(ds, neighbors, kernel)    
%
% Laplacian Eigenmaps
%
% Reference: Belkin, M. and P. Niyogi, Laplacian Eigenmaps for 
%            Dimensionality Reduction and Data Representation",
%            Neural Computation, Vol. 15, No. 6, pp. 1373-1396, 2003.
%
%
% Input(s)
%   ds: data set structure containing x
%   neighbors: matrix containing neighbors for each instance. Can be
%       constructed with GetNeighbors function
%   kernel: kernel structure containing
%       name: gaussian, constant or poly
%       k: neighbor count
%       s: required only if gaussian kernel, variance paramater
%
% Output(s)
%   lem: Laplacian eigenmaps transformation of ds.x
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    % form laplacian matrice
    fprintf('Constructing knn graph k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    [d w] = ConstructKNNGraph(ds, neighbors, kernel);
    fprintf('Finished constructing knn graph k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    
    % check number of connected components
    cc = graphconncomp(w);
    if cc > 1
        fprintf('Warning:NotConnected k-nn graph is not connected cc=%d\n', cc);
        %error('Error:NotConnected k-nn graph is not connected cc=%d\n', cc);
    end
    
    dim = size(ds.x,2);
    % find eigenvector
    l = d - w;
    fprintf('Calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    [lem ed] = eigs(l,d, dim+1, 'sa');
    [sed six] = sort(diag(ed), 'ascend');
    lem = lem(:, six);
    % remove first eigenvector
    lem(:,1) = [];
    % if all eigenvalues are zero, report error
    if isempty(lem)
        error('Error:AllEigenvaluesZero All eigenvalues are zero\n');
    end
    fprintf('Finished calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());    
end
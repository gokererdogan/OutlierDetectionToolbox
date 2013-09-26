function [mds evals] = MultidimensionalScaling(ds, neighbors, kernel)    
%
% Classical (Metric) Multidimensional Scaling
%
% Reference: Cox, T. and M. Cox, Multidimensional Scaling, 
%            Monographs on statistics and applied probability, 
%            Chapman & Hall, 1994
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
%   lem: mds transformation of x
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
	fprintf('%s\n', ds.name);
    % form similarity matrice
    fprintf('Constructing knn graph k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    [d w] = ConstructKNNGraph(ds, neighbors, kernel);
    fprintf('Finished constructing knn graph k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    
    % check number of connected components
    cc = graphconncomp(w);
    if cc > 1
        fprintf('Warning:NotConnected k-nn graph is not connected cc=%d\n', cc);
        %error('Error:NotConnected k-nn graph is not connected cc=%d\n', cc);
    end
    
    w = w ./ max(max(w));
    n = size(w, 1);
    w = -w;
    w = .5 * ( -(w.^2) + (ones(n, n)./n)*(w.^2) + (w.^2)*(ones(n, n)./n) - (ones(n, n)./n)*(w.^2)*(ones(n, n)./n));
    
    dim = size(ds.x,2);
    % find eigenvector
    fprintf('Calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    [mds ed] = eigs(w, dim, 'lr');    
    [sed six] = sort(diag(ed), 'descend');
    mds = mds(:, six);
    evals = sed;
    evals = evals ./ sum(evals);        
    fprintf('Finished calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());    
end
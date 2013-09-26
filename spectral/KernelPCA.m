function [kpca evals] = KernelPCA(ds, neighbors, kernel, normalize)
%
% Kernel Principal Components Analysis
%
% Reference: Bernhard Schölkopf, Alex J. Smola, Klaus-Robert Müller: 
%            Kernel Principal Component Analysis. ICANN 1997: 583-588
%
% Input(s)
%   ds: data set structure containing x
%   neighbors: matrix containing neighbors for each instance. Can be
%       constructed with GetNeighbors function
%   kernel: kernel structure containing
%       name: gaussian, constant or poly
%       k: neighbor count
%       s: required only if gaussian kernel, variance paramater
%   normalize: if >0 calculated kernel is mean centered
%
% Output(s)
%   kpca: Kernel PCA transformation of ds.x
%   evals: eigen values for each attribute
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
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
    
    if normalize > 0
        w = ( (w) - (ones(n, n)./n)*(w) - (w)*(ones(n, n)./n) + (ones(n, n)./n)*(w)*(ones(n, n)./n));
    end
    
    dim = size(ds.x,2);
    % find eigenvector
    fprintf('Calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());
    [kpca ed] = eigs(w, dim, 'lr');    
    [sed six] = sort(diag(ed), 'descend');
    kpca = kpca(:, six);
    evals = sed;
    evals = evals ./ sum(evals);        
    fprintf('Finished calculating evectors for k=%d dist=%s %s\n', kernel.k, kernel.name, GetCurrentTime());    
end
function results = LocalOutlierFactor(dataset, params)
%
% Local Outlier Factor
% Reference
%   Markus M. Breunig, Hans-Peter Kriegel, Raymond T. Ng, 
%   and Jorg Sander. 2000. LOF: identifying density-based local outliers. 
%   SIGMOD Rec. 29, 2 (May 2000), 93-104. DOI=10.1145/335191.335388 
%   http://doi.acm.org/10.1145/335191.335388
%
% Summary
%   Calculates local outlier factor for each sample in test dataset
%   according to training data
%
% Notes
%   It is assumed that data is normalized appropriately and categorical 
%   features in data are converted to continuous values. Please
%   see functions under dataset folder for this purpose.
%
% Input(s)
%   dataset: Dataset structure containing at least trainx, testx.
%   Can be constructed with ReadDataset function. 
%   params: Training parameters structure, should contain the following
%       params.minptslb: Lower bound of minpts, determines how many
%       neighbors are uses for calculation of LOF
%       params.minptsub: Upper bound for minpts
%       params.ptsStep: If provided defines the step size for k values that
%           will be used for LOF calculation. Default is 1
%       params.theta: Threshold for converting calculated LOF values to
%       class labels. 2 if sample is outlier, 1 if normal
%
%
% Output(s)
%   results: results structure containing the following
%       results.yprob: LOF values for each sample
%       results.y: predicted class labels for each sample. 2 if sample is 
%          outlier, 1 if normal
%       results.lof: A matrice containing calculated LOF values for each k
%       (number of neighbors) value. Each column represents sample LOF 
%       values for a certain k.
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

    if (~isfield(dataset, 'trainx') || ~isfield(dataset, 'testx'))
        error('LocalOutlierFactor:Dataset structure must contain trainx and testx fields');
    end
    if ~isfield(params, 'minptslb') || ~isfield(params, 'minptsub') || ~isfield(params, 'theta')
        error('LocalOutlierFactor:Params structure must contain minptslb, minptsub and theta fields');
    end
    
    if isfield(params, 'ptsStep')
        kStep = params.ptsStep;
    else
        kStep = 1;
    end
    
    N = size(dataset.trainx,1);
    tN = size(dataset.testx, 1);
    x = dataset.trainx;
    testx = dataset.testx;
    
    minptsub = params.minptsub;
    minptslb = params.minptslb;
    kVals = minptslb:kStep:minptsub;
    kCount = size(kVals,2);
    results.yprob = zeros(tN,1);
    results.lof = zeros(tN, kCount);
    

    % calculate kdistances and kneighbors for samples in training data
    kdistances = zeros(N, kCount);
    kneighbors = cell(N, kCount);
    for i = 1:N
        dist = sum((x - repmat(x(i,:), N, 1)).^2, 2);
        dist(i) = max(dist);
        sdist = sort(dist);
        kdistances(i,:) = sdist(kVals);
        for k = 1:kCount
            kneighbors{i, k} = find(dist <= kdistances(i,k));
        end
    end

    % for every sample in test data
    for i = 1:tN
        % find k-distance and neighbors of test sample
        dist = sum((x - repmat(testx(i,:), N, 1)).^2, 2);
        sdist = sort(dist);
        for k = 1:kCount
            kdist = sdist(kVals(k));
            neighbors = find(dist <= kdist);
            neighborCount = size(neighbors,1);
            % calculate reachability distance of test sample to each sample
            % in neighborhood
            rd = max( kdistances(neighbors, k), dist(neighbors));
            lrd = neighborCount ./ sum(rd);
            % calculate local reachability distance of all neighbors
            nlrd = zeros(1, neighborCount);
            for n = 1:neighborCount
                nkneighbors = kneighbors{neighbors(n), k};
                nkncount = size(nkneighbors,1);
                ndist = sum( (x(nkneighbors,:) - repmat(x(neighbors(n),:), nkncount, 1)).^2, 2);
                nrd = max( kdistances(nkneighbors, k), ndist);
                nlrd(1, n) = nkncount ./ sum(nrd);
            end
            lof = sum(nlrd) ./ (neighborCount .* lrd);
            if isnan(lof) || isinf(lof)
                lof = 0;
            end
            results.lof(i,k)  = lof;
        end
        results.yprob(i) = max(results.lof(i,:));
    end
    
    results.y = (results.yprob > params.theta) + 1;
    % results.yprob = NormalizeToZeroOne(results.yprob);
end
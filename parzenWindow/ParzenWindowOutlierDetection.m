function results = ParzenWindowOutlierDetection(dataset, params)
%
% Parzen Window Density Estimation for Outlier Detection
%
% Notes:
%   Any categorical variable in input data is converted to continuous
%   features by inverse document frequency.
%
% Summary
%   Calculates probability for each sample in test data according to 
%   training data using a gaussian kernel
%
%
% Input(s)
%   dataset: Dataset structure containing at least trainx, testx, categoricalVars. 
%   Can be constructed with ReadDataset function
%   params: Training parameters structure, should contain the following
%       params.s: covariance matrice for gaussian kernel
%       params.k: if s is not provided, variance is
%       calculated from the distance to kth neighbor such that
%       distanceToKthNeighbor = 2*s In that case covariance matrice is
%       diagonal. Also, if s is not provided, categorical variables in input
%           data is converted to continuous values via inverse document
%           frequency and data is normalized to 0-1 interval
%       params.local: 0 or 1. If 1, s is calculated for each point
%       params.theta: outlier threshold
%
% Output(s)
%   results: probability of each test sample
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

    if ~isfield(dataset, 'trainx') || ~isfield(dataset, 'testx') || ~isfield(dataset, 'categoricalVars') || ~isfield(params, 'local')
        error('ParzenWindowOutlierDetection:Dataset structure must contain trainx, testx, local and categoricalVars');
    end
    
    if ~isfield(params, 's') && ~isfield(params, 'k')
        error('ParzenWindowOutlierDetection:Params structure must contain s or k fields');
    end
    
    if params.local == 0 && ~isfield(params, 's') && isfield(params, 'k')
        xtx = [dataset.trainx; dataset.testx];
        xtx = ConvertCategoricalToIDF(xtx, dataset.categoricalVars); 
        xtx = NormalizeToZeroOne(xtx);
        s = CalculateS(xtx, params.k);
        params.s = repmat(s, 1, size(xtx,2));
        x = xtx(1:size(dataset.trainx,1),:);
        testx = xtx(size(dataset.trainx,1)+1:size(xtx,1),:);
        results.s = params.s;
    else
        x = dataset.trainx;
        testx = dataset.testx;
    end
    
    N = size(x,1);
    tN = size(testx,1);
    results.yprob = zeros(tN,1);
    for i = 1:tN
        if params.local == 0
            s = params.s;
        else
            s = getSigma(x, testx(i,:), params.k);            
        end
        % results.yprob(i) = sum(mvnpdf(x, testx(i,:), s))./N;
        results.yprob(i) = sum(exp(-sum((x - repmat(testx(i,:), N, 1)).^2 ./ repmat(s, N, 1), 2))) ./ N;
    end
    results.yprob = NormalizeToZeroOne(results.yprob);
    results.yprob = 1 - results.yprob;
    tsty = results.yprob - params.theta;
    tsty(tsty>0) = 2;
    tsty(tsty<=0) = 1;   
    results.y = tsty;
end

function s = getSigma(x, p, k)
    dist = (x - repmat(p, size(x,1), 1)).^2;
    totdist = sum(dist,2);
    for i=1:k
        totdist(totdist==min(totdist)) = max(totdist);
    end
    s = repmat(min(totdist) ./ 4, 1, size(x,2));
%     mini = find(totdist==min(totdist),1);
%     s = dist(mini,:) ./ 4; % 2 * std = dist
end

function sigma = CalculateS(x, k)
    N = size(x, 1);
	totKDist = 0;
	% find k-nn and calculate sigma
	for i = 1:N
        dx = sum( ( repmat( x(i,:), N, 1) - x).^2, 2 );
        
        % find the kth min distance
        for j = 1:k
            dx(dx==min(dx)) = max(dx);
        end		
		totKDist = totKDist + sqrt(min(dx));		
	end
	avgDist = totKDist / N;
	% std = mean(k-nn dist) / 1
	sigma = avgDist^2 / 1;	
end
function results = FeatureBagging(dataset, params)
%
% Feature Bagging for Outlier Detection
% Reference
%   Aleksandar Lazarevic and Vipin Kumar. 2005. 
%   Feature bagging for outlier detection. 
%   In Proceedings of the eleventh ACM SIGKDD international conference
%   on Knowledge discovery in data mining 
%   (KDD '05). ACM, New York, NY, USA, 157-166. 
%   DOI=10.1145/1081870.1081891 http://doi.acm.org/10.1145/1081870.1081891
%
% Summary
%   Calculates outlier scores by combining outputs of multiple outlier
%   detection methods on random feature subsets of input data
%
% Notes
%   Base outlier detection method is LocalOutlierFactor
%
% Input(s)
%   dataset: Dataset structure containing at least trainx, testx.
%   Can be constructed with ReadDataset function. 
%   params: Training parameters structure, should contain the following
%       params.t: number of base outlier detection methods to run
%       params.combination: Method for combining outlier scores. It must be
%           'BreadthFirst' -> Breadth-First combination
%           'CumulativeSum' -> Cumulative Sum combination
%       params.minptslb: Lower bound of minpts, determines how many
%       neighbors are uses for calculation of LOF
%       params.minptsub: Upper bound for minpts
%       params.ptsStep: If provided defines the step size for k values that
%           will be used for LOF calculation. Default is 1
%       params.theta: Threshold for converting calculated outlier scores to
%       class labels. Class labels: 2 if sample is outlier, 1 if normal
%
%
% Output(s)
%   results: results structure containing the following
%       results.yprob: outlier scores for each sample
%       results.y: predicted class labels for each sample. 2 if sample is 
%          outlier, 1 if normal
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if (~isfield(dataset, 'trainx') || ~isfield(dataset, 'testx'))
        error('FeatureBagging:Dataset structure must contain trainx and testx fields');
    end
    if ~isfield(params, 't') || ~isfield(params, 'combination') ...
            || ~isfield(params, 'minptslb') || ~isfield(params, 'minptsub') ...
            || ~isfield(params, 'theta')
        error('FeatureBagging:Params structure must contain t, combination, minptslb, minptsub and theta fields');
    end
    
    if strcmpi(params.combination,'BreadthFirst') == 0 && ...
            strcmpi(params.combination,'CumulativeSum') == 0
        error('FeatureBagging:Combination method should be BreadthFirst or CumulativeSum');
    end
    
    tN = size(dataset.testx, 1);
    D = size(dataset.trainx, 2);
    
    outlierScores = zeros(tN, params.t);
    for t = 1:params.t
        % select a random feature subset
        featureCount = randi([floor(D./2) (D-1)]);
        rp = randperm(D);
        features = rp(1:featureCount);
        ds.trainx = dataset.trainx(:,features);
        ds.testx = dataset.testx(:,features);
        
        % get LOF scores for test data
        tRes = LocalOutlierFactor(ds, params);
        outlierScores(:,t) = tRes.yprob;
        [~,~,~,auc] = perfcurve(dataset.testy, tRes.yprob,2);
        fprintf('t=%d ROC: %f\n', t, auc);
    end
    % combine scores
%     if strcmpi(params.combination,'BreadthFirst') == 1
%         scores = CombineBreadthFirst(outlierScores);
%     else
%         scores = CombineCumulativeSum(outlierScores);
%     end
    scores = CombineBreadthFirst(outlierScores);
    scores2 = CombineCumulativeSum(outlierScores);
    results.yprob = scores;
    results.yprob2 = scores2;
    results.y = (results.yprob > params.theta) + 1;
end

function scores = CombineBreadthFirst(os)
    t = size(os,2);
    N = size(os,1);
    
    os = NormalizeToZeroOne(os);
    
    [sos sind] = sort(os, 'descend');
    
    appended = false(N,1);
    curind = 1;
    
    indices = zeros(N,1);
    scores = zeros(N,1);
    for i = 1:N
        for j = 1:t
            if appended(sind(i,j)) == 0
                indices(curind) = sind(i,j);
                scores(curind) = sos(i,j);
                curind = curind+1;
                appended(sind(i,j)) = 1;
            end
            
            if curind > N
                break;
            end
        end
    end
    scores(indices,:) = scores;
end

function scores = CombineCumulativeSum(os)
    scores = sum(os, 2) ./ size(os,2);
end
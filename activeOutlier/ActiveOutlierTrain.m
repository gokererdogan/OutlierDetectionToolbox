function model = ActiveOutlierTrain(dataset, params)
%
% Outlier Detection by Active Learning - Training Step
% Reference
%   Abe, N., Zadrozny, B., & Langford, J. (2006). 
%   Outlier detection by active learning. 
%   Proceedings of the 12th ACM SIGKDD international conference on
%   Knowledge discovery and data mining KDD 06
%
% Summary
%   Trains a model for finding outliers with Active-Outlier method
%
% Notes
%   Uses decision tree (classregtree in statistics toolbox) as base learner
%   Background distribution is assumed to be uniform
%
% Input(s)
%   dataset: Dataset structure containing at least trainx, trainy,
%   normalClass, categoricalVars. Can be constructed with ReadDataset
%   function
%   params: Training parameters structure, should contain the following
%       params.t: number of learners in ensemble
%       params.r: fraction of rejection sampled data size (e.g r=0.5 means 
%                   that s' will contain roughly half of s)
%       params.maxleaves: (optional) max number of leafs in tree.default:16
%
%
% Output(s)
%   model: model that contains ensemble of learners, their weights
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

    if ~isfield(dataset, 'trainx') || ~isfield(dataset, 'trainy') || ...
            ~isfield(dataset, 'categoricalVars') || ~isfield(dataset, 'normalClass')
        error('ActiveOutlierTrain:Dataset structure must contain trainx, trainy, categoricalVars and normalClass fields');
    end
    if ~isfield(params, 't') || ~isfield(params, 'r')
        error('ActiveOutlierTrain:Params structure must contain t and r fields');
    end
    
    
    % get samples belonging to normal class
    trn = GetSamplesFromClass(dataset.trainx, dataset.trainy, dataset.normalClass);
    if isfield(dataset, 'testx') && isfield(dataset, 'testy')
        tst = GetSamplesFromClass(dataset.testx, dataset.testy, dataset.normalClass);
    else
        tst = [];
    end
    categoricalVars = dataset.categoricalVars;
    if size(categoricalVars, 1) > size(categoricalVars, 2)
        categoricalVars = categoricalVars';
    end
    
    
    N = size(trn,1);
    
    % generate artificial outliers of size N
    % give method the whole dataset since a subset of it may not cover the
    % characteristic of the whole (e.g. categorical vars may not take their
    % all possible values in training set)
    syn = SampleFromUniformDistribution([trn; tst], categoricalVars, N);
    
    % combine real and synthetic data
    sx = [trn; syn];
    sy = [zeros(N,1); ones(N,1)];
    
    if ~isfield(params, 'maxleaves')
        params.maxleaves = 16;
    end
    
    % train learners
    model.trainParams = params;
    model.trees = cell(1, params.t);
    model.alpha = zeros(1, params.t);   
    
    for i = 1:params.t
        % calculate margins
        margins = CalculateMargins(model.trees, sx, i-1);
        % sample from sx with rejection sampling
        [sprime sprimey] = SampleWithRejectionSampling(sx, sy, margins, params.r, i);
        % train learner
        minparent = size(sprime,1)./params.maxleaves;
		if minparent < 1
			fprintf('ActiveOutlier:Warning minparent is less than 1. Setting to 1 (number of samples: %d)\n', size(sprime,1));
            minparent = 1;
        end
        model.trees{i} = classregtree(sprime, sprimey, 'method', 'classification', 'categorical', categoricalVars, 'minparent', minparent);
        % get error rate
        cost = test(model.trees{i}, 'resubstitution');
        err = cost(1);
        % weight learner
        model.alpha(1,i) = log((1-err) / err);
        if err < 10e-5
            model.alpha(1,i) = 1;
        end
    end
    clear trn;
    clear margins;
    clear sx;
    clear sy;
    clear sprime;
    clear sprimey;
end

function margins = CalculateMargins(trees, x, t)
% Calculate margins for each instance using learned trees
    N = size(x,1);
    margins = zeros(1,N);

    if t > 0
        for i=1:t
            [~, nodes] = eval( trees{i}, x );
            cp = trees{i}.classprob(nodes);
            try
                p = cp(:,2);
            catch err
                p = zeros(N, 1);
            end
            margins(1,:) = margins(1,:) + ( 2.* p' - 1);
        end
    end
    margins = abs(margins);
end

function [s sy] = SampleWithRejectionSampling(x, y, margins, r, i)
    N = size(x,1);
    probs = 1 - normcdf( (i + margins)./2, i./2, sqrt(i)./2 );
    probs = probs .* (r.*N ./ sum(probs));
    selected = rand(1, N) < ( probs );
    s = x(selected,:);
    sy = y(selected,:);
end

function syn = SampleFromUniformDistribution(trn, categoricalVars, N)
    D = size(trn,2);
    
    % generate artificial outliers of size N
    intervals = max(trn) - min(trn);
    distInterval = [min(trn) - intervals/10 ; max(trn) + intervals/10];
    syn = (rand(N, D) .* repmat( distInterval(2,:) - distInterval(1,:), N, 1 )) + repmat( distInterval(1,:), N, 1 );
    
    cD = size(categoricalVars, 2);
    for i = 1:cD
%         syn(:,categoricalVars(i)) = round(syn(:,categoricalVars(i)));
        u = unique(trn(:,categoricalVars(i)));
        imax = size(u,1);
        syn(:,categoricalVars(i)) = u(randi(imax, N, 1));
    end
end
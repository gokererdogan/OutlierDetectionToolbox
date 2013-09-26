function results = ActiveOutlierTest(model, dataset, params)
%
% Outlier Detection by Active Learning - Test Step
% Reference
%   Abe, N., Zadrozny, B., & Langford, J. (2006). 
%   Outlier detection by active learning. 
%   Proceedings of the 12th ACM SIGKDD international conference on
%   Knowledge discovery and data mining KDD 06
%
% Summary
%   Tests data with trained model to find outliers
%
% Input(s)
%   model: ActiveOutlier model trained with ActiveOutlierTrain function
%   dataset: structure containing field testx for test data
%   params: test parameters structure, should contain the following
%       params.theta: outlier threshold
%
% Output(s)
%   results: results structure containing the following
%       results.y: class labels for test data, 1 if normal, 2 if outlier
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if ~isfield(model, 'trees') || ~isfield(model, 'alpha') || ...
            ~isfield(model, 'trainParams')
        error('ActiveOutlierTest:Invalid model structure');
    end
    if ~isfield(dataset, 'testx')
        error('ActiveOutlierTest:Dataset structure must contain testx');
    end
    % calculate output for test data
    tst = dataset.testx;
    tsty = zeros(1, size(tst,1));
    for i=1:model.trainParams.t
        [~, nodes] = eval( model.trees{i}, tst );
        cp = model.trees{i}.classprob(nodes);
        try
            p = cp(:,2);
        catch err
            p = zeros(size(tst,1), 1);
        end
        tsty = tsty + (model.alpha(i) * p');
    end
    tsty = tsty';
    % store probability values for each sample normalized to 1 for class 0
    % and 1
    %results.yprob = (tsty - min(tsty)) ./ (max(tsty) - min(tsty));
    results.yprob = tsty;
    %results.yprob = [1 - results.yprob results.yprob];
    tsty = tsty - sum(params.theta .* model.alpha);    
    tsty(tsty>0) = 2;
    tsty(tsty<=0) = 1;   
    results.y = tsty;
end
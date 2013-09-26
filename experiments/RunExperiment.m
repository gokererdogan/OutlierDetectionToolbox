function results = RunExperiment(method, dataset, expParams)
%
% Run method on dataset with cross validation and obtain results
%
% Input(s)
%   method: method structure containing information on the method to be
%   tested. following fields are required in method structure
%       method.requiresTraining: >0 if method requires a separate training
%           step, then trainFcn must also be supplied
%       method.trainFcn: function handle to method's training function,
%           function signature must be model = fn(dataset, trainingParams)
%       method.testFcn: function handle to method's test function
%           function signature;
%               if requiresTraining>0 -> results = fn(model, dataset, testParams)
%               else -> results = fn(dataset, testParams)
%       method.trainParams: method specific training parameters
%       method.testParams: method specific test params
%   dataset: dataset structure containing x and y matrices, some methods
%       may require extra fields to be supplied
%   expParams: experiment parameters
%       expParams.cvFoldCount: number of folds used in cross validation
%       expParams.cvRunCount: number of runs for cross validation
%       expParams.problemType: 'onlyNormals' or 'mixed'
%           'onlyNormals': methods are trained with only normal sample
%           'mixed': methods are trained with both normal and outlier
%           samples
%
% Output(s)
%   results: results sructure containing results for each fold
%       results.y: class labels predicted by method for each fold
%       results.yprob: class probabilities predicted by method for
%           each fold
%       results.actualy: actual class labels for samples in each
%           fold
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if isfield(expParams, 'notify') && expParams.notify > 0
        notify = 1;
    end
    results.y = cell(1, expParams.cvFoldCount * expParams.cvRunCount);
    results.yprob = cell(1, expParams.cvFoldCount * expParams.cvRunCount);
    results.yprob2 = cell(1, expParams.cvFoldCount * expParams.cvRunCount);
    results.actualy = cell(1, expParams.cvFoldCount * expParams.cvRunCount);
    
    if notify
        fprintf('RunExperiment: Experiment started. Method: %s, Dataset: %s, Problem Type: %s, CV: %dx%d\n', ...
            method.name, dataset.name, expParams.problemType, expParams.cvRunCount, expParams.cvFoldCount);
    end
    
    % Cross Validation
    N = size(dataset.x,1);
    for r = 1:expParams.cvRunCount
        cv = cvpartition(dataset.y, 'kfold', expParams.cvFoldCount);    
        
        for k = 1:expParams.cvFoldCount
            
            if notify
                fprintf('RunExperiment: CV Run %d Fold %d started\n', r, k);
            end
        
            istrain = training(cv, k);
            istest = test(cv, k);
            dataset.trainx = dataset.x(istrain,:);
            dataset.trainy = dataset.y(istrain,:);
            dataset.testx = dataset.x(istest,:);
            dataset.testy = dataset.y(istest,:);
            dataset.sampleIndices = istrain;
            
            if strcmpi(expParams.problemType,'onlyNormals')
                % remove outliers from training sample
                dataset.trainx(dataset.trainy==2,:) = [];
                dataset.trainy(dataset.trainy==2,:) = [];
            elseif strcmpi(expParams.problemType,'mixed') 
                % consider outliers as normal
                dataset.trainy(dataset.trainy==2,:) = 1;
            end
            
            if notify
                fprintf('RunExperiment: Running method\n');
            end

            if method.requiresTraining > 0
                model = method.trainFcn(dataset, method.trainParams);
                foldRes = method.testFcn(model, dataset, method.testParams);
                results.actualy{ ((r-1) * expParams.cvFoldCount) + k } = dataset.testy;
            else
                foldRes = method.testFcn(dataset, method.testParams);
                results.actualy{ ((r-1) * expParams.cvFoldCount) + k } = dataset.testy;
            end
            
            if notify
                fprintf('RunExperiment: Aggregating results\n');
            end
            foldRes.actualy = results.actualy;
            results.y{ ((r-1) * expParams.cvFoldCount) + k } = foldRes.y;
            results.yprob{ ((r-1) * expParams.cvFoldCount) + k } = foldRes.yprob;            
        end
    end
    results.method = method;
    results.datasetName = dataset.name;
    results.expParams = expParams;
    if notify
        fprintf('RunExperiment: Experiment finished. Method: %s, Dataset: %s, CV: %dx%d\n', ...
            method.name, dataset.name, expParams.cvRunCount, expParams.cvFoldCount);
    end
end
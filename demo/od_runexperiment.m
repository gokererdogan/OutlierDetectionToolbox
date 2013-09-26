function [testResults bestParam] = od_runexperiment(ds, method, expParams, dims)
% Helper function used by od.m
%
% Summary
%   Runs experiment with the given data set, method, experiment parameters
%   and number of dimensions on validation set. Chooses the best performing
%   parameter combination and evaluates on test set.
%   
% Input(s): 
%   ds: data set structure containing tsx, tsy, tvx, tvy
%   method: structure containing method parameters. See RunExperiment
%       function for details
%   expParams: experiment parameters. See RunExperiment function for 
%       details
%   dims: array containing the number of dimensions to try
%
% Output(s):
%   testResults: results on test set with best parameter combination
%   bestParam: parameter that gave the best results on validation set
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

if isfield(expParams, 'transformationName')
    % categorical vars are converted to continuous during transformation
    ds.categoricalVars = [];
else
    expParams.transformationName = '';
end

AUCs = {};

x = ds.x;
y = ds.y;

dc = size(dims,2);

for j = 1:dc
    cdim = dims(j);      
    param.d = cdim;

    ds.x = x(:,1:cdim);  
    ds.y = y;

    results = RunExperiment(method, ds, expParams);

    roc = CalculateROCCurve(results, 2, expParams.resultsPath, 1, 0, [expParams.problemType ' ' expParams.transformationName '-' num2str(cdim)]);
    results.roc = roc;
    results.param = param;

    cr.param = param;
    cr.roc = roc.AUC;
    AUCs = [AUCs, cr];

    sn = sprintf('%s_%d', expParams.transformationName , cdim);
    SaveResults(results, expParams.resultsPath, sn);
    fprintf('Results (%s-%s): roc %f\n', expParams.transformationName , ds.name, roc.AUC(1));
end        

%%
if isempty(AUCs)
    return;
end

% save validation AUC values for different dimensions
fn = sprintf('%s/%s_%s_%s_%s_ROCPR.mat', expParams.resultsPath, method.name, ds.name, expParams.problemType, expParams.transformationName );
save(fn, 'AUCs');

% find params with best PR and ROC performances
[bestParam] = GetParametersWithBestResult(AUCs);


ds.tvx = x(:,1:bestParam.d);
ds.tvy = ds.y;
ds.tsx = ds.tsx(:,1:bestParam.d);
ds.tsy = ds.tsy;    

testResults = RunExperimentWithFixedTestSet(method, ds, expParams);
testResults.param = bestParam;

roc = CalculateROCCurve(testResults, 2, expParams.resultsPath, 1, 0, [expParams.problemType '-' num2str(cdim) '-Test Set best ROC']);
testResults.roc = roc;

sn = sprintf('%s_test_pr',expParams.transformationName );
SaveResults(testResults, expParams.resultsPath, sn);

end
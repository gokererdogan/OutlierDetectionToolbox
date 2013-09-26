function SaveResults(results, resultsPath, appStr)
%
% Save experiment results
%
%
% Input(s)
%   results: results structure returned by RunExperiment* methods
%   resultsPath: path to save results
%   appStr: optional string to append to filenames
%
% Output(s): none
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if nargin == 2
        appStr = '';
    end
    fn = sprintf('%s/%s_Dataset_%s_%s_%s_Results.mat', resultsPath, results.method.name, results.datasetName, results.expParams.problemType, appStr);
    save(fn, 'results');
end
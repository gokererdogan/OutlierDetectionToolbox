function [bestRocParam] = GetParametersWithBestResult(ROCPR)
%
% Find the parameter that gives the best performance from a results
% structure
% Input(s)
%   ROCPR: a cell array where each cell contains a param and roc field.
%       param holds the parameters structure used to get the accuracy in
%       roc field
% Output(s)
%   bestRocParam: parameter with the best roc AUC result
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    rocs = cellfun(@(x)( x.roc ), ROCPR);
    bestroci = find(rocs==max(rocs), 1);
    bestRocParam = ROCPR{bestroci}.param;
    bestRocParam.roc = ROCPR{bestroci}.roc;    
end

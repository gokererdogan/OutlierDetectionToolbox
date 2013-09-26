function model = DecisionTreeTrain(dataset, trainParams)
%
% Outlier Detection by Classification - Training Step
%
% Summary
%   Trains a decision tree on training data
%
% Notes
%   Uses decision tree classregtree in statistics toolbox.
%
% Input(s)
%   dataset: Dataset structure containing at least trainx, trainy,
%   categoricalVars. Can be constructed with ReadDataset
%   function
%   params: Training parameters structure. not required.
%
%
% Output(s)
%   model: decision tree model
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if ~isfield(dataset, 'trainx') || ~isfield(dataset, 'trainy') || ...
            ~isfield(dataset, 'categoricalVars')
        error('ActiveOutlierTrain:Dataset structure must contain trainx, trainy, categoricalVars fields');
    end
    
    model = classregtree(dataset.trainx, dataset.trainy, 'method', 'classification', 'categorical', dataset.categoricalVars);    
end
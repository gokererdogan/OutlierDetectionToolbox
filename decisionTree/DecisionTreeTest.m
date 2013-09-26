function results = DecisionTreeTest(model, dataset, params)
%
% Outlier Detection by Classification - Test Step
%
% Summary
%   Trains a decision tree on training data
%
% Notes
%   Uses classregtree in statistics toolbox
%
% Input(s)
%   model: Trained decision tree
%   dataset: Dataset structure containing at least testx
%   Can be constructed with ReadDataset function
%
%   params: Test parameters structure
%       params.theta: Outlier threshold
%
%
% Output(s)
%   results: Results structure
%       results.yprob: Outlierness probability for each test instance
%       results.y: Predicted class labels; 1 normal, 2 outlier
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if ~isfield(dataset, 'testx')
        error('ActiveOutlierTrain:Dataset structure must contain testx field');
    end    
    tst = dataset.testx;
    [~, nodes] = eval( model, tst );
    cp = model.classprob(nodes);
    p = cp(:,2);
    results.yprob = p;
    tsty = p - params.theta;
    tsty(tsty>0) = 2;
    tsty(tsty<=0) = 1;   
    results.y = tsty;
end
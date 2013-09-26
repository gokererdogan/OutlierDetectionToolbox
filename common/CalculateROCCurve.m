function roc = CalculateROCCurve(results, posLabel, resultsPath, savePlot, showPlot, appStr)
%
% Calculate ROC curve, plot, show and save it
%
% Summary
%   Calculates ROC values for each fold in results and/or plot/save figures
%
% Input(s)
%   results: structure containing results
%       results.yprob: a cell array where each cell contains the results
%           for a fold. fold results are given in a matrix where each row
%           contain the probabilities for different classes in columns.
%       results.actualy: a cell array of actual output values for each fold
%   posLabel: positive class label
%   resultsPath: path for saving figures
%   savePlot: >0 if PR figures are saved
%   showPlot: >0 if show plots on screen
%   appStr: optional string to append to saved filenames
%
% Output(s)
%   results: contains fold AUCs and average AUC
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if nargin < 5
        appStr = '';
    end
    foldCount = size(results.actualy,2);
    % if results contain score for all classes not only positive class
    if iscell(results.yprob) && size(results.yprob{1,1},2) > 1
        scores = cell(1, size(results.actualy,2));
        for i = 1:foldCount
            fs = results.yprob{i};
            scores{i} = fs(:,posLabel);
        end
    else
        scores = results.yprob;
    end
    if savePlot > 0
        if showPlot > 0 
            h = figure;
        else
            h = figure('Visible','Off');        
        end
        hold all
    end
    
    
    % calculate roc
    for k = 1:foldCount
        t(results.actualy{k}==posLabel) = 1;
        t(results.actualy{k}~=posLabel) = -1;
        y = scores{k};
        [tp fp] = croc(t,y);
        auc = auroc(tp, fp);
        roc.foldAUC(k) = auc;
        if savePlot > 0
            plot(fp, tp);
        end
    end
    
    roc.AUC = mean(roc.foldAUC);
    
    if savePlot > 0
        fn = sprintf('%s/%s_%s_%s_ROC_Plot.png', resultsPath, results.method.name, results.datasetName, appStr); 
        tn = sprintf('ROC Curve - %s, %s %s, AUC=%f', results.method.name, results.datasetName, appStr, mean(roc.foldAUC));
        title(tn);
        print(h, '-dpng', fn);
    end    
end
function pr = CalculatePrecisionRecallCurve(results, posLabel, resultsPath, savePlot, appStr)
%
% Calculate Precision-Recall curve, plot and save it
%
% Summary
%   Calculates PR values for each fold in results and/or plot/save figures
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
%   appStr: optional string to append to saved filenames
%
% Output(s)
%   pr: contains AUC values for each fold and average AUC value
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
        h = figure;
        hold all
    end
    % calculate pr
    npts = 100;
    for k = 1:foldCount
        yp = scores{k};
        yp(isinf(yp)) = 0;
        yp(isnan(yp)) = 0;
        y = results.actualy{k};
        cy = zeros(size(yp,1),1);
        mint = min(yp);
        maxt = max(yp);
        ts = linspace(mint, maxt, npts);
        precs = zeros(1,npts);
        recalls = zeros(1,npts);
        for t = 1:npts
            cy(yp>ts(t)) = 2;
            cy(yp<=ts(t)) = 1;
            % precision
            precs(t) = sum(cy==2 & y==2) ./ sum(cy==2);
            % recall
            recalls(t) = sum(cy==2 & y==2) ./ sum(y==2);        
        end
        precs = fliplr(precs);
        recalls = fliplr(recalls);

        precs(isnan(precs))=1;
        tp = [1 precs 0];
        fp = [0 recalls 1];
        pr.foldAUC(k) = sum( ((tp(2:npts+2) + tp(1:npts+1))./2) .* (fp(2:npts+2) - fp(1:npts+1)) );
        if savePlot > 0
            plot(fp, tp);
        end
        
    end
    
    pr.AUC = mean(pr.foldAUC);
    
    if savePlot > 0
        fn = sprintf('%s/%s_%s_%s_PrecisionRecall_Plot.png', resultsPath, results.method.name, results.datasetName, appStr); 
        tn = sprintf('PR Curve - %s, %s %s, AUC=%f', results.method.name, results.datasetName, appStr, mean(pr.foldAUC));
        title(tn);
        print(h, '-dpng', fn);
    end
end
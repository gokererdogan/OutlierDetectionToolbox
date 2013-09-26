function CalculateAndPlotDiscriminants(ds, method, expParams)
% Calculate discriminant for method and plot it
%
% Summary
%   Runs experiment with the given data set, method, experiment parameters
%   and plots the discriminant
%   
% Input(s): 
%   ds: data set structure containing tsx, tsy, tvx, tvy
%   method: structure containing method parameters. See RunExperiment
%       function for details
%   expParams: experiment parameters. See RunExperiment function for 
%       details
%
% Output(s): none
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    format = 'png';
    is3d = 0;
    x = ds.x;
    y = ds.y;
    % initialize grid data for plotting discriminant
    xinterval = max(x(:,1)) - min(x(:,1)); 
    yinterval = max(x(:,2)) - min(x(:,2));

    gxmin = min(x(:,1)) - (xinterval/10);
    gxmax = max(x(:,1)) + (xinterval/10);
    gymin = min(x(:,2)) - (yinterval/10);
    gymax = max(x(:,2)) + (yinterval/10);
    gxi = linspace(gxmin, gxmax, 50);
    gyi = linspace(gymin, gymax, 50);
    [mx,my,gx] = GetCartesianGrid(gxi,gyi);
    gds.testx = gx;
    
    
    ds.trainx = x;
    ds.trainy = y;
    ds.testx = x;
    ds.testy = y;
    gds.trainx = x;
    gds.trainy = y;
    ds.categoricalVars = [];
    ds.normalClass = 1;
    ds.outlierClass = 2;
    gds.normalClass = 1;
    gds.outlierClass = 2;
    gds.categoricalVars = [];

    if strcmpi(expParams.problemType,'onlyNormals')
        % remove outliers from training sample
        ds.trainx(ds.trainy==2,:) = [];
        ds.trainy(ds.trainy==2,:) = [];
    elseif strcmpi(expParams.problemType,'mixed') 
        % consider outliers as normal
        ds.trainy(ds.trainy==2,:) = 1;
    end
    
    
    if method.requiresTraining > 0
        model = method.trainFcn(ds, method.trainParams);
        results = method.testFcn(model, ds, method.testParams);        
        results2 = method.testFcn(model, gds, method.testParams);
    else
        results = method.testFcn(ds, method.testParams);        
        results2 = method.testFcn(gds, method.testParams);
    end
    
    % get optimum operating point
    %[rx,ry,rt,auc,opt] = perfcurve(ds.testy, results.yprob, 2, 'xCrit', 'reca', 'yCrit', 'prec');
    [rx,ry,rt,auc,opt] = perfcurve(ds.testy, results.yprob, 2);
    theta = rt(rx==opt(1) & ry==opt(2));
    
    map = GetColormap();
    h = plotClasses(x, y); 
    hold on
    plot2DDiscriminant(mx, my, results2.yprob, theta, is3d);
    axis([gxmin gxmax gymin gymax]);
    colormap(map);
    colorbar;
    
    fn = sprintf('%s/%s_%s_%s_OutlierScores_%s.png',expParams.resultsPath, method.name, ds.name, expParams.problemType, expParams.transformationName);
    tn = sprintf('%s ,%s - %s, %s %s', method.name, ds.name, expParams.problemType, expParams.transformationName, paramStr);
    title(tn);

    SaveFigure(h, fn, format);
end
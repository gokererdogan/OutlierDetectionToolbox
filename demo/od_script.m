% A sample script to run spectral outlier detection methods
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

problemType = 'onlyNormals';
%problemType = 'mixed';

% ActiveOutlier method parameters
runAO = 1;
AOt = 10; % number of learners

% LOF method parameters
runLOF = 1;
LOFkMin = 1; % minimum neighbor count
LOFkMax = 3; % maximum neighbor count
LOFstepSize = 1; % step size

% ParzenWindows method parameters
runPW = 1;
PWk = 2; % neighbor counts

dsPath = '../datasets/optdigits1';
ds = ReadDataset(dsPath);

% pre-process data
tvN = size(ds.tvx, 1);
tsN = size(ds.tsx, 1);
x = [ds.tvx; ds.tsx];
x = ConvertCategoricalToIDF(x, ds.categoricalVars);
x = NormalizeToZeroOne(x);
ds.x = SubtractMean(x);
ds.tvx = x(1:tvN,:);
ds.tsx = x(tvN+1:tvN+tsN,:);

% calculate PCA
[tvxpca, tsxpca pcavars] = PCA(ds, problemType);

% calculate kernel matrix
kernel.name = 'gaussian'; % or 'constant', 'poly'
kernel.k = 3; % number of neighbors
% find neighbors
neighbors = GetNeighbors(ds.x, kernel.k);
kernel.s = CalculateKNNSigma(ds.x, neighbors, kernel.k);

% calculate LEM, MDS, KPCA transformations
lem = LaplacianEigenmap(ds, neighbors, kernel);
% separate into train/validation and test set
tvxlem = lem(1:tvN,:);
tsxlem = lem(tvN+1:tvN+tsN,:);

[mds mdsvars] = MultidimensionalScaling(ds, neighbors, kernel);  
% separate into train/validation and test set
tvxmds = mds(1:tvN,:);
tsxmds = mds(tvN+1:tvN+tsN,:);

[kpca evals] = KernelPCA(ds, neighbors, kernel, 0);    
% separate into train/validation and test set
tvxkpca = kpca(1:tvN,:);
tsxkpca = kpca(tvN+1:tvN+tsN,:);

% method and experiment parameters
method.name = 'ActiveOutlier';
method.requiresTraining = 1;
method.trainFcn = @ActiveOutlierTrain;
method.testFcn = @ActiveOutlierTest;
method.trainParams.t = AOt;
method.trainParams.r = .5;
method.testParams.theta = .5;

%initialize experiment params
expParams.cvFoldCount = 2;
expParams.cvRunCount = 5;
expParams.problemType = problemType;
expParams.notify = 1;
expParams.resultsPath = dsPath;

% give the data that you want to run experiments on 
% as x and y (training/validation),  tsx and tsy (test)
ds.x = tvxlem;
ds.y = ds.tvy;
ds.tsx = tsxlem;
ds.tsy = ds.tsy;
expParams.transformationName = 'lem';
% number of dimensions to try
dims = [2 3 10];


% AUC results for each parameter
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

fprintf('Test set results are in testResults and validation AUCs are in AUCs\n');
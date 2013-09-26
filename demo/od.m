function varargout = od(varargin)
% Outlier Detection Toolbox - Spectral Outlier Detection GUI
%
% Summary
%   Lets user to choose a data set path, outlier detection methods;
%   ActiveOutlier, LOF and ParzenWindows, kernel parameters and runs
%   spectral outlier detection and reports results.
%   
% Input(s): none
% Output(s): none
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @od_OpeningFcn, ...
                   'gui_OutputFcn',  @od_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before od is made visible.
function od_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to od (see VARARGIN)

% Choose default command line output for od
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes od wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = od_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function txtDsPath_Callback(hObject, eventdata, handles)
% hObject    handle to txtDsPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDsPath as text
%        str2double(get(hObject,'String')) returns contents of txtDsPath as a double


% --- Executes during object creation, after setting all properties.
function txtDsPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDsPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnChoosePath.
function btnChoosePath_Callback(hObject, eventdata, handles)
% hObject    handle to btnChoosePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir();
if folder ~= 0
    set(handles.txtDsPath, 'String', folder);
end


% --- Executes on button press in cbAO.
function cbAO_Callback(hObject, eventdata, handles)
% hObject    handle to cbAO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAO



function txtAOt_Callback(hObject, eventdata, handles)
% hObject    handle to txtAOt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtAOt as text
%        str2double(get(hObject,'String')) returns contents of txtAOt as a double


% --- Executes during object creation, after setting all properties.
function txtAOt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAOt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbLOF.
function cbLOF_Callback(hObject, eventdata, handles)
% hObject    handle to cbLOF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbLOF



function txtLOFkMin_Callback(hObject, eventdata, handles)
% hObject    handle to txtLOFkMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLOFkMin as text
%        str2double(get(hObject,'String')) returns contents of txtLOFkMin as a double


% --- Executes during object creation, after setting all properties.
function txtLOFkMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLOFkMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLOFkMax_Callback(hObject, eventdata, handles)
% hObject    handle to txtLOFkMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLOFkMax as text
%        str2double(get(hObject,'String')) returns contents of txtLOFkMax as a double


% --- Executes during object creation, after setting all properties.
function txtLOFkMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLOFkMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtLOFstepSize_Callback(hObject, eventdata, handles)
% hObject    handle to txtLOFstepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtLOFstepSize as text
%        str2double(get(hObject,'String')) returns contents of txtLOFstepSize as a double


% --- Executes during object creation, after setting all properties.
function txtLOFstepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtLOFstepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbPW.
function cbPW_Callback(hObject, eventdata, handles)
% hObject    handle to cbPW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbPW



function txtPWk_Callback(hObject, eventdata, handles)
% hObject    handle to txtPWk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPWk as text
%        str2double(get(hObject,'String')) returns contents of txtPWk as a double


% --- Executes during object creation, after setting all properties.
function txtPWk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPWk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtKernelK_Callback(hObject, eventdata, handles)
% hObject    handle to txtKernelK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtKernelK as text
%        str2double(get(hObject,'String')) returns contents of txtKernelK as a double


% --- Executes during object creation, after setting all properties.
function txtKernelK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtKernelK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtKernelS_Callback(hObject, eventdata, handles)
% hObject    handle to txtKernelS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtKernelS as text
%        str2double(get(hObject,'String')) returns contents of txtKernelS as a double


% --- Executes during object creation, after setting all properties.
function txtKernelS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtKernelS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnRun.
function btnRun_Callback(hObject, eventdata, handles)
% hObject    handle to btnRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get parameters
if get(handles.rbSS, 'Value') == 1
    problemType = 'onlyNormals';
else
    problemType = 'mixed';
end

kernelK = round(str2double(get(handles.txtKernelK, 'String')));
if kernelK < 1
    errordlg('Kernel neighbor count must be greater than 0'); 
    return;
end

kernelS = str2double(get(handles.txtKernelS, 'String'));
if kernelS < 0
    errordlg('Kernel variance cannot be negative'); 
    return;
end

runAO = get(handles.cbAO, 'Value');
if runAO == 1
    AOt = round(str2double(get(handles.txtAOt, 'String')));
end

runLOF = get(handles.cbLOF, 'Value');
if runLOF == 1
    LOFkMin = round(str2double(get(handles.txtLOFkMin, 'String')));
    LOFkMax = round(str2double(get(handles.txtLOFkMax, 'String')));
    LOFstepSize = round(str2double(get(handles.txtLOFstepSize, 'String')));
end

runPW = get(handles.cbPW, 'Value');
if runPW == 1
    PWk = round(str2double(get(handles.txtPWk, 'String')));
end

% read dataset
folder = get(handles.txtDsPath, 'String');
try
    ds = ReadDataset(folder);
catch err
    errordlg(sprintf('Cannot read data set. \n Error: %s', err.message));
    return;
end

% pre-process
tvN = size(ds.tvx, 1);
tsN = size(ds.tsx, 1);
x = [ds.tvx; ds.tsx];
x = ConvertCategoricalToIDF(x, ds.categoricalVars);
x = NormalizeToZeroOne(x);
ds.x = SubtractMean(x);
ds.tvx = x(1:tvN,:);
ds.tsx = x(tvN+1:tvN+tsN,:);

% calc PCA
[tvxpca, tsxpca pcavars] = PCA(ds, problemType);

% calc kernel matrix

kernel.name = 'gaussian';
kernel.k = kernelK;
neighbors = GetNeighbors(ds.x, kernel.k);

if kernelS < 10e-6
    kernel.s = CalculateKNNSigma(ds.x, neighbors, kernel.k);
else
    kernel.s = kernelS;
end

% calc LEM, MDS, KPCA
lem = LaplacianEigenmap(ds, neighbors, kernel);
tvxlem = lem(1:tvN,:);
tsxlem = lem(tvN+1:tvN+tsN,:);

[mds mdsvars] = MultidimensionalScaling(ds, neighbors, kernel);  
tvxmds = mds(1:tvN,:);
tsxmds = mds(tvN+1:tvN+tsN,:);

[kpca evals] = KernelPCA(ds, neighbors, kernel, 0);    
tvxkpca = kpca(1:tvN,:);
tsxkpca = kpca(tvN+1:tvN+tsN,:);

% run experiments
results = {'Method', 'AUC', '# of dimensions'};
if runAO == 1
    % no transformation
    %initialize method params
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
    expParams.resultsPath = folder;
    
    ds.x = ds.tvx;
    ds.y = ds.tvy;
    dims = size(ds.x, 2);
    
    [testResults bestParam] = od_runexperiment(ds, method, expParams, dims);
    results = [results; {'AO', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];

    % pca
    expParams.transformationName = 'pca';
    ds.x = tvxpca;
    ds.y = ds.tvy;
    ds.tsx = tsxpca;
    
    % find number of dimensions for .8, .9, .95, .99 variance
    vars = [0.8 0.9 0.95 0.99];
    edc = cumsum(pcavars);
    ecs = 2;
    for v = 1:4
        ecs = [ecs find(edc > vars(v),1)];
    end
    ecs = unique(ecs);
    ecs = sort(ecs);
    [testResults bestParam] = od_runexperiment(ds, method, expParams, ecs);
    results = [results; {'AO-PCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % mds
    dimc = [.05 .1 .2 .4];
    mdims = [2 round(dims * dimc)];
    mdims = unique(mdims);
    mdims(mdims<1) = [];
    expParams.transformationName = 'mds';
    ds.x = tvxmds;
    ds.y = ds.tvy;
    ds.tsx = tsxmds;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'AO-MDS', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % kpca
    expParams.transformationName = 'kpca';
    ds.x = tvxkpca;
    ds.y = ds.tvy;
    ds.tsx = tsxkpca;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'AO-KPCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % lem
    expParams.transformationName = 'lem';
    ds.x = tvxlem;
    ds.y = ds.tvy;
    ds.tsx = tsxlem;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'AO-LEM', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
end

if runLOF == 1
    % no transformation
    %initialize method params
    method.name = 'LOF';
    method.requiresTraining = 0;
    method.testFcn = @LocalOutlierFactor;
    method.testParams.minptslb = LOFkMin;
    method.testParams.minptsub = LOFkMax;
    method.testParams.ptsStep = LOFstepSize;
    method.testParams.theta = 2;

    %initialize experiment params
    expParams.cvFoldCount = 2;
    expParams.cvRunCount = 5;
    expParams.problemType = problemType;
    expParams.notify = 1;
    expParams.resultsPath = folder;
    
    ds.x = ds.tvx;
    ds.y = ds.tvy;
    dims = size(ds.x, 2);
    
    [testResults bestParam] = od_runexperiment(ds, method, expParams, dims);
    results = [results; {'LOF', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];

    % pca
    expParams.transformationName = 'pca';
    ds.x = tvxpca;
    ds.y = ds.tvy;
    ds.tsx = tsxpca;
    
    % find number of dimensions for .8, .9, .95, .99 variance
    vars = [0.8 0.9 0.95 0.99];
    edc = cumsum(pcavars);
    ecs = 2;
    for v = 1:4
        ecs = [ecs find(edc > vars(v),1)];
    end
    ecs = unique(ecs);
    ecs = sort(ecs);
    [testResults bestParam] = od_runexperiment(ds, method, expParams, ecs);
    results = [results; {'LOF-PCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % mds
    dimc = [.05 .1 .2 .4];
    mdims = [2 round(dims * dimc)];
    mdims = unique(mdims);
    mdims(mdims<1) = [];
    expParams.transformationName = 'mds';
    ds.x = tvxmds;
    ds.y = ds.tvy;
    ds.tsx = tsxmds;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'LOF-MDS', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % kpca
    expParams.transformationName = 'kpca';
    ds.x = tvxkpca;
    ds.y = ds.tvy;
    ds.tsx = tsxkpca;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'LOF-KPCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % lem
    expParams.transformationName = 'lem';
    ds.x = tvxlem;
    ds.y = ds.tvy;
    ds.tsx = tsxlem;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'LOF-LEM', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
end

if runPW == 1
    % no transformation
    %initialize method params
    method.name = 'ParzenWindow';
    method.requiresTraining = 0;
    method.testFcn = @ParzenWindowOutlierDetection;
    method.testParams.k = PWk;
    method.testParams.local = 0;
    method.testParams.theta = .5;


    %initialize experiment params
    expParams.cvFoldCount = 2;
    expParams.cvRunCount = 5;
    expParams.problemType = problemType;
    expParams.notify = 1;
    expParams.resultsPath = folder;
    
    ds.x = ds.tvx;
    ds.y = ds.tvy;
    dims = size(ds.x, 2);
    
    [testResults bestParam] = od_runexperiment(ds, method, expParams, dims);
    results = [results; {'PW', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];

    % pca
    expParams.transformationName = 'pca';
    ds.x = tvxpca;
    ds.y = ds.tvy;
    ds.tsx = tsxpca;
    
    % find number of dimensions for .8, .9, .95, .99 variance
    vars = [0.8 0.9 0.95 0.99];
    edc = cumsum(pcavars);
    ecs = 2;
    for v = 1:4
        ecs = [ecs find(edc > vars(v),1)];
    end
    ecs = unique(ecs);
    ecs = sort(ecs);
    [testResults bestParam] = od_runexperiment(ds, method, expParams, ecs);
    results = [results; {'PW-PCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % mds
    dimc = [.05 .1 .2 .4];
    mdims = [2 round(dims * dimc)];
    mdims = unique(mdims);
    mdims(mdims<1) = [];
    expParams.transformationName = 'mds';
    ds.x = tvxmds;
    ds.y = ds.tvy;
    ds.tsx = tsxmds;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'PW-MDS', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % kpca
    expParams.transformationName = 'kpca';
    ds.x = tvxkpca;
    ds.y = ds.tvy;
    ds.tsx = tsxkpca;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'PW-KPCA', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
    % lem
    expParams.transformationName = 'lem';
    ds.x = tvxlem;
    ds.y = ds.tvy;
    ds.tsx = tsxlem;
    [testResults bestParam] = od_runexperiment(ds, method, expParams, mdims);
    results = [results; {'PW-LEM', sprintf('%.2f - %.3f', testResults.roc.AUC, std(testResults.roc.foldAUC)), num2str(bestParam.d)}];
    
end

% output results
set(handles.tblResults, 'Data', results);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btnChoosePath.
function btnChoosePath_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btnChoosePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when uipanel4 is resized.
function uipanel4_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function varargout = demo(varargin)
% Spectral Methods Demonstration
%
% Summary
%   Lets user to choose points in 2D and plots the PCA, LEM, KPCA and MDS
%   transformations.
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
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
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


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Add application data
points = [];
setappdata(hObject, 'points', points);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get points and kernel parameters
points = getappdata(handles.figure1, 'points');
k = str2num(get(handles.textNeighborCount, 'String'));
s = str2num(get(handles.textSigma, 'String'));

% calculate w matrice
% gaussian kernel
neighbors = GetNeighbors(points, k);
[d w] = calculateW(points, neighbors, 1, k, s);
%w = points * points';
%d = diag(sum(w,2));
% polynomial kernel
[pd pw] = calculateW(points, neighbors, 2, k, s);

set(handles.tableW, 'Data', w);
set(handles.tableD, 'Data', d);
set(handles.tableL, 'Data', d-w);

% plot transformations
[pcax vars] = pca(points);
[lemx led] = lem(w, d);
[kpcax ked] = kpca(w, 0);
[nkpcax nked] = kpca(w, 1);
[mdsx med] = mds(w);

labels = cellstr( num2str([1:size(points,1)]') );

lim = 1;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/8 3*scrsz(3)/4 3*scrsz(4)/4])
% original data
subplot(2, 3, 1);
plot(points(:,1), points(:,2), 'ro');
axis([-lim lim -lim lim]);
grid on
title('Original Data');
text(points(:,1), points(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 

% pca
subplot(2, 3, 2);
plot(pcax(:,1), pcax(:,2), 'ro');
grid on
minx = min(min(pcax(:,1:2)));
maxx = max(max(pcax(:,1:2)));
h = (maxx-minx)/10;
axis([-lim lim -lim lim]);
%axis([minx-h maxx+h minx-h maxx+h])
title('PCA');
svar = sprintf('Var=%.3f', vars(1,1));
xlabel(svar);
svar = sprintf('Var=%.3f', vars(2,2));
ylabel(svar);
text(pcax(:,1), pcax(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 

% lem
subplot(2, 3, 4);
plot(lemx(:,1), lemx(:,2), 'ro');
grid on
minx = min(min(lemx(:,1:2)));
maxx = max(max(lemx(:,1:2)));
h = (maxx-minx)/10;
axis([-lim lim -lim lim]);
%axis([minx-h maxx+h minx-h maxx+h])
title('Laplacian EM');
svar = sprintf('Var=%.3f', led(1,1));
xlabel(svar);
svar = sprintf('Var=%.3f', led(2,2));
ylabel(svar);
text(lemx(:,1), lemx(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 

% classical mds
subplot(2, 3, 3);
plot(mdsx(:,1), mdsx(:,2), 'ro');
grid on
minx = min(min(mdsx(:,1:2)));
maxx = max(max(mdsx(:,1:2)));
h = (maxx-minx)/10;
axis([-lim lim -lim lim]);
%axis([minx-h maxx+h minx-h maxx+h])
title('Classical MDS');
svar = sprintf('Var=%.3f', med(1,1));
xlabel(svar);
svar = sprintf('Var=%.3f', med(2,2));
ylabel(svar);
text(mdsx(:,1), mdsx(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 


% kpca
subplot(2, 3, 5);
plot(kpcax(:,1), kpcax(:,2), 'ro');
grid on
minx = min(min(kpcax(:,1:2)));
maxx = max(max(kpcax(:,1:2)));
h = (maxx-minx)/10;
axis([-lim lim -lim lim]);
%axis([minx-h maxx+h minx-h maxx+h])
title('KPCA');
svar = sprintf('Var=%.3f', ked(1,1));
xlabel(svar);
svar = sprintf('Var=%.3f', ked(2,2));
ylabel(svar);
text(kpcax(:,1), kpcax(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 

% kpca - mean centered
subplot(2, 3, 6);
plot(nkpcax(:,1), nkpcax(:,2), 'ro');
grid on
minx = min(min(nkpcax(:,1:2)));
maxx = max(max(nkpcax(:,1:2)));
h = (maxx-minx)/10;
axis([-lim lim -lim lim]);
title('KPCA - Mean Centered');
svar = sprintf('Var=%.3f', nked(1,1));
xlabel(svar);
svar = sprintf('Var=%.3f', nked(2,2));
ylabel(svar);
text(nkpcax(:,1), nkpcax(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 


function textNeighborCount_Callback(hObject, eventdata, handles)
% hObject    handle to textNeighborCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textNeighborCount as text
%        str2double(get(hObject,'String')) returns contents of textNeighborCount as a double


% --- Executes during object creation, after setting all properties.
function textNeighborCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textNeighborCount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textSigma_Callback(hObject, eventdata, handles)
% hObject    handle to textSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textSigma as text
%        str2double(get(hObject,'String')) returns contents of textSigma as a double


% --- Executes during object creation, after setting all properties.
function textSigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
points = [];
setappdata(handles.figure1, 'points', points);
cla(handles.axesInput);
set(handles.tableW, 'Data', {});


% --- Executes on mouse press over axes background.
function axesInput_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = get(hObject, 'CurrentPoint');
points = getappdata(handles.figure1, 'points');
points = [points; p(1,1) p(1,2)];
setappdata(handles.figure1, 'points', points);
labels = cellstr( num2str([1:size(points,1)]') );
plot(hObject, points(:,1), points(:,2), 'rx');
text(points(:,1), points(:,2), labels, 'VerticalAlignment','bottom', 'HorizontalAlignment','right'); 


function [d w] = calculateW(x, neighbors, distType, k, sigma)
N = size(x, 1);
x = x - repmat(mean(x), size(x,1), 1);
w = zeros(N, N);
% update similarity values with respect to calculated sigma
for i = 1:N
    % find the k neigbors
    for m = 1:k+1 

        if m == k+1 %connect each instance to itself (every instance is neighbor of itself)
            n = i;
        else
            n = neighbors(i, m);            
        end

        if distType == 0 % constant kernel
            % if this edge is not already constructed
            w(i, n) = 1;
            w(n, i) = 1;
        elseif distType == 1 % gaussian kernel
            dist = sum((x(i,:) - x(n,:)).^2);
            sim = exp( - dist / (sigma) );
            w(i, n) = sim;
            w(n, i) = sim;
        elseif distType == 2 % polynomial kernel
            sim = ((x(i,:) * x(n,:)') + 1)^2;
            w(i, n) = sim;
            w(n, i) = sim;
        end            
    end
end    
d = diag(sum(w, 2));


function [pcax vars] = pca(x)
z = x - repmat(mean(x), size(x,1), 1);
cx = z' * z;
[ev ed] = eig(cx);
ed = rot90(ed,2);
ed = ed ./ sum(diag(ed));
ev = fliplr(ev);
vars = ed;
pcax = x * ev;

function [lemx ed] = lem(w, d)
l = d - w;
[lemx ed] = eig(l,d);
[sed six] = sort(diag(ed));
lemx = lemx(:, six);
lemx = lemx(:, 2:size(lemx,2));
ed = diag(sed(2:numel(sed)));
%ed = ed ./ sum(diag(ed));

function [mdsx ed] = mds(w)
pcount = size(w,1);
dist = 1 - w;
edist = .5 * (-(dist.^2) + (ones(pcount, pcount)./pcount)*(dist.^2) + (dist.^2)*(ones(pcount, pcount)./pcount) - (ones(pcount, pcount)./pcount)*(dist.^2)*(ones(pcount, pcount)./pcount));
[mdsx ed] = eig(edist);
% remove evectors with evalue < 0
del = diag(ed)<0;
ed(del,:) = [];
ed(:,del) = [];
mdsx(:, del) = [];
[sed six] = sort(diag(ed));
mdsx = mdsx(:, six);
ed = diag(sed);
mdsx = fliplr(mdsx);
ed = rot90(flipud(ed));
%ed = ed ./ sum(diag(ed));

function [kx ed] = kpca(w, normalize)
pcount = size(w,1);
if normalize > 0
    w = w - (ones(pcount, pcount)./pcount)*w - w*(ones(pcount, pcount)./pcount) + (ones(pcount, pcount)./pcount)*w*(ones(pcount, pcount)./pcount);
end
[kx ed] = eig(w);
del = diag(ed)<0;
ed(del,:) = [];
ed(:,del) = [];
kx(:, del) = [];
[sed six] = sort(diag(ed));
kx = kx(:, six);
ed = diag(sed);
kx = fliplr(kx);
ed = rot90(flipud(ed));
%ed = ed ./ sum(diag(ed));

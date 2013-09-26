function ds = ReadDataset(path)
% Read and construct dataset structure from path
% Summary
%   Reads files from path and constructs dataset structure
%
% Notes
% Path must contain files: Training/Validation Set: tvx.mat, tvy.mat 
%                          Test Set: tsx.mat, tsy.mat
% def.txt
% def.txt format: Contains 4 lines, 1st line: dataset name, 
% 2nd line: normal classes, 3rd line outlier classes, 
% 4th line: categorical variables indices. Example below;
%     Shuttle
%     1 2 3
%     4 5
%     3 4 5 9 11 
%
% Input(s)
%   path: path containing training, test data and dataset definition file
%
% Output(s)
%   ds: dataset structure containing train, test data and following
%   attributes
%   ds.tvx: training/validation input data
%   ds.tvy: training/validation class labes
%   ds.tsx: test input data
%   ds.tsy: test class labes
%   ds.normalClass: class labels for normal samples
%   ds.outlierClass: class labels for outlier samples
%   ds.categoricalVars: indices of categorical variables
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    fn = sprintf('%s/%s', path, 'tvx.mat');
    load(fn, 'tvx');
    ds.tvx = tvx;
    fn = sprintf('%s/%s', path, 'tvy.mat');
    load(fn, 'tvy');
    ds.tvy = tvy;
    
    fn = sprintf('%s/%s', path, 'tsx.mat');
    load(fn, 'tsx');
    ds.tsx = tsx;
    fn = sprintf('%s/%s', path, 'tsy.mat');
    load(fn, 'tsy');
    ds.tsy = tsy;
        
    fn = sprintf('%s/%s', path, 'def.txt');
    fd = fopen(fn,'r');
    if fd == -1
        error('ReadDataset: Cannot read dataset definition file');
    end
    
    line = fgetl(fd);
    ds.name = line;
    
    line = fgetl(fd);
    ds.normalClass = sscanf(line, '%d');
    
    line = fgetl(fd);
    if line == -1 % no outlier classes
        ds.outlierClass = [];
    else
        ds.outlierClass = sscanf(line, '%d');
    end
    
    line = fgetl(fd);
    if line == -1
        ds.categoricalVars = [];
    else
        ds.categoricalVars = sscanf(line, '%d');
    end
    
    ds.path = path;
end
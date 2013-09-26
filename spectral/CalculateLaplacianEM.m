% Sample script to calculate Laplacian Eigenmaps transformations for
% multiple data sets with multiple kernels and kernel parameters
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering

% Calculate Laplacian EM transformations and store them
clear;

dsNames = {'pageblocks1', 'pageblocks2', 'pageblocks3', 'pageblocks4'};
path = '../datasets/';
dsCount = size(dsNames, 2);

dsStart = 1;

ks = [3 6 12 25 80];
kCount = size(ks,2);

scoeff = [.5 1 2 4];
sCount = size(scoeff,2);

diary('CalculateLaplacian.log');

for dd = dsStart:dsStart+dsCount-1
    dd
    dsPath = sprintf('%s%s', path, dsNames{dd});
    % read dataset
    ds = ReadDataset(dsPath);
    ds.path = dsPath;
    
    tvN = size(ds.tvx, 1);
    tsN = size(ds.tsx, 1);
    x = [ds.tvx; ds.tsx];
    
    x = zscore(x);    
    ds.x = x;
    % get neighbors of each point in x
    fn = sprintf('%s%s/neighbors.mat', path, dsNames{dd});
    if exist(fn, 'file')
        load(fn, 'neighbors');
        fprintf('Loaded neihgbors matrice: %s\n', GetCurrentTime());
    else
        fprintf('Constructing neihgbors matrice: %s\n', GetCurrentTime());
        neighbors = GetNeighbors(x, ks(kCount));
        save(fn, 'neighbors');
        fprintf('Finished constructing neihgbors matrice: %s\n', GetCurrentTime());
    end
    
    
    
    
    for i = 1:kCount
        ks(i)
        
        kernel.name = 'constant';
        kernel.k = ks(i);
        % constant distance
        try
            lem = LaplacianEigenmap(ds, neighbors, kernel);
            tvxLem = lem(1:tvN,:);
            tsxLem = lem(tvN+1:tvN+tsN,:);
            fn = sprintf('%s%s/tvxlem_%d_%s.mat', path, dsNames{dd}, kernel.k, kernel.name);
            save(fn, 'tvxLem');
            fn = sprintf('%s%s/tsxlem_%d_%s.mat', path, dsNames{dd}, kernel.k, kernel.name);
            save(fn, 'tsxLem');
        catch err
            fprintf('Cannot calculate Laplacian EM for %s, k=%d, %s dist\n', dsNames{dd}, ks(i), kernel.name);
            fprintf('%s: %s\n', err.identifier, err.message);
        end
        
        %-----------------------gaussian kernel
        kernel.name = 'gaussian';
        kernel.k = ks(i);
        % calculate sigma values to try
        s = CalculateKNNSigma(x, neighbors, kernel.k);
        ss = scoeff * s;
        fn = sprintf('%s%s/sigmaVals_%d.mat', path, dsNames{dd}, kernel.k);
        save(fn,'ss');
        
        for j = 1:sCount
            kernel.s = ss(j);
            try
                lem = LaplacianEigenmap(ds, neighbors, kernel);
                tvxLem = lem(1:tvN,:);
                tsxLem = lem(tvN+1:tvN+tsN,:);
                fn = sprintf('%s%s/tvxlem_%d_%d_%s.mat', path, dsNames{dd}, kernel.k, j, kernel.name);
                save(fn, 'tvxLem');
                fn = sprintf('%s%s/tsxlem_%d_%d_%s.mat', path, dsNames{dd}, kernel.k, j, kernel.name);
                save(fn, 'tsxLem');
            catch err
                fprintf('Cannot calculate Laplacian EM for %s, k=%d %d, %s dist\n', dsNames{dd}, ks(i), j, kernel.name);
                fprintf('%s: %s\n', err.identifier, err.message);
            end            
        end
        %---------------------------------------------------------------%
        
        %----------------------polynomial kernel------------------------%
        kernel.name = 'poly';
        kernel.k = ks(i);
        % constant distance
        try
            lem = LaplacianEigenmap(ds, neighbors, kernel);
            tvxLem = lem(1:tvN,:);
            tsxLem = lem(tvN+1:tvN+tsN,:);
            fn = sprintf('%s%s/tvxlem_%d_%s.mat', path, dsNames{dd}, kernel.k, kernel.name);
            save(fn, 'tvxLem');
            fn = sprintf('%s%s/tsxlem_%d_%s.mat', path, dsNames{dd}, kernel.k, kernel.name);
            save(fn, 'tsxLem');
        catch err
            fprintf('Cannot calculate Laplacian EM for %s, k=%d, %s dist\n', dsNames{dd}, ks(i), kernel.name);
            fprintf('%s: %s\n', err.identifier, err.message);
        end
        %---------------------------------------------------------------%
    end
end
diary off;

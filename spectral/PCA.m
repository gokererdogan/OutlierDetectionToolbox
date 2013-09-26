function [tvxpca, tsxpca vars] = PCA(ds, problemtype)   
%
% Principal Components Analysis
%
% Reference: Jolliffe, I.,Principal Component Analysis, 
%                      Springer Series in Statistics, Springer-Verlag, 2002.
%
%
% Input(s)
%   ds: data set structure containing tvx, tsx
%   problemType: onlyNormals (semi-supervised) or mixed (unsupervised)
%
% Output(s)
%   tvxpca: pca transfomation of training/validation set
%   tsxpca: pca transfomation of test set
%   vars: explained variances by each dimension
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if strcmpi(problemtype, 'onlyNormals')
        x = GetSamplesFromClass(ds.tvx, ds.tvy, ds.normalClass);
    elseif strcmpi(problemtype, 'mixed')
        x = ds.tvx;
    else
        error('PCA:Invalid problem type');
    end
    
    dim = size(x,2);
    N = size(x,1);
    if N > dim
        cx = x'*x;
        [lv usvars] = eig(cx);
        [vars ix] = sort(diag(usvars), 'descend');
        vars = vars ./ sum(vars);
        lv = lv(:, ix);
        tvxpca = ds.tvx*lv;
        tsxpca = ds.tsx*lv;
    else
        simx = x*x';
        [tvxpca usvars] = eig(simx);
        [vars ix] = sort(diag(usvars), 'descend');
        vars = vars ./ sum(vars);
        tvxpca = tvxpca(:,ix);
        tvxpca = ds.tvx*x'*tvxpca;
        tsxpca = ds.tsx*x'*tvxpca;
    end    
end
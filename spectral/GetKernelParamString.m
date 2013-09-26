function paramStr = GetKernelParamString(param)
%
% Returns a string representation for kernel parameters
%
%
% Input(s)
%   param: kernel parameter
%
% Output(s)
%   paramStr: string representation of kernel 
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if strcmpi(param.name, 'gaussian')
        paramStr = sprintf('%s-k%d-s%.3f', param.name, param.k, param.s);
    else
        paramStr = sprintf('%s-k%d', param.name, param.k);
    end
    
    if isfield(param, 'd')
        paramStr = sprintf('%s-d%d', paramStr, param.d);
    end
end
function nx = ConvertCategoricalToIDF(x, categoricalVars)
%
% Converts categorical variables in x to inverse document freq. values
%
% Input(s)
%   x: data
%   categoricalVars: indices of categorical attributes
%
% Output(s)
%   nx: converted data
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    % categoricalVars need to be column vector
    if size(categoricalVars,1) == 1
        categoricalVars = categoricalVars';
    end
    D = size(x,2);
    N = size(x,1);
    in = ismember((1:D)', categoricalVars);
    nx = [];
    for i = 1:D
        if in(i) == 1 %if attribute i is categorical
            u = unique(x(:,i));            
            ud = size(u,1);
            freqs = N ./ sum(repmat(x(:,i),1,ud)==repmat(u',N,1),1);
            ix = zeros(N,1);
            for j = 1:ud
                ix(x(:,i) == u(j),1) = freqs(j);
            end
            nx = [nx ix];
        else %if attribute i is continuous
            nx = [nx x(:,i)];
        end
    end
end
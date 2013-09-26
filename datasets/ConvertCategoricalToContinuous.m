function nx = ConvertCategoricalToContinuous(x, categoricalVars)
%
% Converts categorical variables in x to membership vectors
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
            ix = zeros(N,ud);
            for j = 1:ud
                ix(x(:,i)==u(j), (u==u(j))) = 1;
            end
            nx = [nx ix];
        else %if attribute i is continuous
            nx = [nx x(:,i)];
        end
    end
end
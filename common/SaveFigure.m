function SaveFigure(h, fname, format)
%
% Save figure in format
%
%
% Input(s)
%   h: figure handle
%   fname: filename
%   format: figure format
%
% Output(s): none
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    if strcmpi(format, 'png') == 1
        print(h, '-dpng', fname);
    elseif strcmpi(format, 'eps') == 1
        print(h, '-depsc', fname);
    else
        error('SaveFigure:Unknown format');
    end
end
function times = GetCurrentTime()
%
% Format current time as a string
%
%
% Input(s): none
%
% Output(s)
%   times: a string representing current time in hours:mins:secs format
%
% Goker Erdogan (gokererdogan@gmail.com)
% Bogazici University
% Department of Computer Engineering
    timev = fix(clock);
    
    if timev(4) < 10
        hour = ['0' num2str(timev(4))]; 
    else
        hour = num2str(timev(4)); 
    end
    if timev(5) < 10
        min = ['0' num2str(timev(5))]; 
    else
        min = num2str(timev(5)); 
    end
    if timev(6) < 10
        sec = ['0' num2str(timev(6))]; 
    else
        sec = num2str(timev(6)); 
    end
    times = [hour ':' min ':' sec];
end
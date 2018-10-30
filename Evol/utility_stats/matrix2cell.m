

function [tcell, xcell] = matrix2cell (t,x,dt)
    if nargin < 3
        dt = t(end)-t(end-1);
    end
    
    tdif = diff(t) - dt;        % Find differences
    index = find ( abs(tdif) >= 1e-5 ); % Identify any discontinuities greater than normal stepsize.
    index = [index length(t)];  % Be sure to go all the way to the end of the dataset
    
    cstart = 1;
    for i = 1:length(index)
        cend = index(i);
        tcell{i}=t(cstart:cend);
        xcell{i}=x(cstart:cend);
        cstart = index(i)+1;
    end
    
    
end
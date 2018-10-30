
function [tcellind tmatind] = find_tcell_ind (tmins, tmaxs, tbin_min, tbin_max, dt)
    
    tcellind = [];
    tmatind = [];
    N = length(tmins);
    for i = 1:N
        if ((tmins(i) <= tbin_max) && (tmaxs(i) >= tbin_min))
            tcellind = [tcellind i];
            if tmins(i) >= tbin_min
                ind_min = 1;
            else
                ind_min = round((tbin_min-tmins(i))/dt)+1;
            end
            if tmaxs(i) >= tbin_max
                ind_max = round((tbin_max-tmins(i))/dt)+1;
            else
                ind_max = round((tmaxs(i)-tmins(i))/dt)+1;
            end
            tmatind = [tmatind; [ind_min ind_max] ];
        end
    end
    
end

function channum_arr = getchannums (ratN)

        if ratN == 9; 
            channum_arr=[1:32];
%             channum_arr=[1:3];
        end
        if ratN == 4;
           channum_arr=[1:32];
%             channum_arr=[1:3];
        end
        if ratN == 1;
            % We're missing kurtosis and stdev data for channel 9
            channum_arr=[1:8 10:16];
        end
        if ratN == 13; 
            % We're missing channels 25 and 28
            channum_arr=[1:24 26:27 29:32];
        end
        
end
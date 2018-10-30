
function [stim_time first_seizure] = get_seiztimes (ratnum)

    if ratnum == '009'; 
        stim_time = 28;
        first_seizure = 73;
    end
    if ratnum == '004';
        stim_time = 28;
        first_seizure = 99;
    end
    if ratnum == '001';
        stim_time = 78;
        first_seizure = 109;
    end
    if ratnum == '013'; 
        stim_time = 38;
        first_seizure = 75; % This is a guess!
    end
    if ratnum == '010'; 
        stim_time = 43;
        first_seizure = 75;
    end

end
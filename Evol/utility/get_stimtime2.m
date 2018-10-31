

function [stim_tabs seiz_tabs] = get_stimtime2(ratN)

    ratnum = num2str(ratN, '%6.3d');

    if ratnum == '009'; 
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 28;
        first_seizure = 73;
    end
    if ratnum == '004';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 28;
        first_seizure = 99;
    end
    if ratnum == '001';
        ii = 1;
        for i=[1:8 9 10:16]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        % if ~strcmp(plot_type, 'skew'); clear channum_arr; ii = 1; for i=[1:8 10:16]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end; end % We're missing channel 9 for stdev and kurt for rat 001
        stim_time = 78;
        first_seizure = 109;
    end
    if ratnum == '013'; 
        ii = 1;
            % We're missing channels 25 and 28
        for i=[1:24 26:27 29:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 38;
        first_seizure = 75; % Note Rat 13 actually doesn't exhibit seizures; just stuck this in to make code work.
    end
    if ratnum == '010'; 
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 43;
        first_seizure = 75;
    end
    
    if ratnum == '006';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 15;
        first_seizure = 46;
    end
    if ratnum == '007';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 22;
        first_seizure = 106;
    end
    if ratnum == '005';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 11;
        first_seizure = 113;
    end
    if ratnum == '008';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 18;
        first_seizure = 128;
    end
    if ratnum == '011';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 24;
        first_seizure = 87;
    end
    if ratnum == '012';
        ii = 1;
        for i=[1:32]; channum_arr{ii}=num2str(i,'%05.2d'); ii=ii+1; end
        stim_time = 30;
        first_seizure = 76;
    end
    
    
    start_from_scratch=1;
    path_ratlog='../data/Disk_inventory/RatData_out';
    outlog_path = ['./Ratoutmat_FFT'];
    if start_from_scratch
        [outlog_path outlog_name] = save_log(path_ratlog, ratnum, outlog_path);   % Save log file
    else
        outlog_name = strcat('Rat',ratnum,'log');
    end
    load ([outlog_path '/' outlog_name])    % Load log file
    
    for ii = 1:length(fileNames);
        fileNums(ii) = str2num(fileNames{ii}(1:4));
    end
    if ~isempty(find(diff(fileNums)==0)); fprintf('Warning: Overlapping filenums. Check log! \n'); end
    stim_index = find(fileNums >= stim_time, 1, 'first'); stim_tabs=(tabs(stim_index)-floor(tabs(1)));
    seiz_index = find(fileNums >= first_seizure, 1, 'first'); seiz_tabs=(tabs(seiz_index)-floor(tabs(1)));
    
    
end

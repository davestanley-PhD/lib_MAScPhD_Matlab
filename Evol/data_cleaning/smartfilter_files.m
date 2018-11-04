function [bad_indices, bad_files] = smartfilter_files (t,d0,fnum,invert,ratN)

    % This code goes through the entire dataset and identifies bad data
    % points and then removes BAD FILES associated with that bad data. It
    % Does this on the basis of how much bad data
    % they contain.
    %
    % The return value [bad_indices] flags all indices of d0 corresponding
    % to each file identified as bad.
    
    % Rationale: We do this file-by-file mainly for validation purposes.
    % We can easily load a whole file and visually identify it as good or
    % bad, or see what's going on.
    % 
    % The algorithm is as follows:
    % 1. Identify any data points exceeding prefilter_threshold standard
    % deviations across the whole dataset.
    %
    % 2. Ignoring these data points, we then calculate an envelope using
    % envelope_threshold. This is based on a 5-hour moving window. Any data
    % points exceeding this envelope are marked as bad. Note that the
    % original pre-filtering was necessary because they can skew the
    % envelope calculation.
    %
    % 3. Of the data marked as bad, see how many bad data points each file
    % contains. If a file contains more than 10 bad data points, mark ALL
    % of the data associated with it as bad, so it can be rejected.
    % 
    % Notes:
    % Each data point represents a 2-second bin. Each file contains about
    % 7-hours of data. The total data set is ~40 hours for rat 9
    %
    % Rationale:
    % The data points captured by prefilter_threshold are usually due to
    % things like saturation (e.g., all 65535 values), whereas the bad data
    % detected by the envelopes may be chewing artifacts, loose wires, etc.
    % 
    % Note that although removing the entire file is somewhat conservative,
    % the data is generally quite good, plus we have tons of it, so this
    % does not affect things that much
    
    
    if ~invert
        plot_on = 1;
        bin_size = 5;
        prefilter_threshold = 10;
        envelope_threshold = 20;
        max_bad_datapoints_per_file = 10;
        if ratN == 7
            prefilter_threshold = 2.5;
        end
    else
        plot_on = 0;
        bin_size = 5;
        prefilter_threshold = 0.2;
        envelope_threshold = 15;
        max_bad_datapoints_per_file = 10;
        invertmax = 1/5;
        invertmax = 1/5 * 3276700^2 / (1e3)^2;
        if ratN == 1
            % Use this for more strict filtering. - instead of doing this to remove entire files,
            % below I just filter out the low-amp data points point-by-point
%             invertmax = 1/100;
%             envelope_threshold = 10;
            max_bad_datapoints_per_file = 500;
        end
        if ratN == 7
            envelope_threshold = 5;
        end
    end

    if invert
        d = 1./d0;
        d(d>invertmax) = invertmax;
    else
        d = d0;
    end
    
    % Build a padded dataset (for use in moving averages)
    ind = find(t > bin_size,1,'first');
    ind2 = find(t > t(end) - bin_size,1,'first');
    d_temp = [fliplr(d(1:ind)) d fliplr(d(ind2:end))];
    t_temp = [-1*fliplr(t(1:ind)) t t(end) + -1*(fliplr(t(ind2:end))-t(end)) ];        
    
    % Ignore data exceeding prefilter_threshold
    ind = d_temp < (mean(d_temp) + std(d_temp)*prefilter_threshold);
    
    % Get 5-hour moving average and std, for use in calculating envelope
    [t_sm, d_sm, d_std] = daveMVAVG_bin (t_temp(ind), d_temp(ind), bin_size, 0.5, 0.9,0);

    
    if plot_on
        mrksize = 20;
        figure; plot(t,d,'b.','MarkerSize',mrksize)
        hold on; plot(t_temp(ind), d_temp(ind),'k.','MarkerSize',mrksize)
        if ~invert hold on; errorbar(t_sm,d_sm,d_std*envelope_threshold,'r.','MarkerSize',mrksize)
        else hold on; errorbar(t_sm,d_sm,d_sm*envelope_threshold,'r.','MarkerSize',mrksize); end
        legend('original','prefiltered','envelope');
        xlabel('time days');
        
        %hold on; plot(t_sm,d_sm+ mean(d_std)*5,'y.')
    end
    clear ind ind2
    
    % Find original data exceeding the envelope
    temp = interp1(t_sm,d_sm,t);
    if ~invert envelope = temp + interp1(t_sm,d_std,t)*envelope_threshold;
    else envelope = temp + temp*envelope_threshold; end
    ind = d > envelope;
    fnum_bads = fnum(ind);
    
    filebins = unique(fnum);
    [nfiles] = hist(fnum,filebins);
    [nbad] = hist(fnum_bads,filebins);
    
    if plot_on
        figure;
        subplot(311); bar(filebins,nfiles); title('# datapoints vsfiles');
        subplot(312); bar(filebins,nbad); title('# bad datapoints vs files');
        subplot(313); bar(filebins,nbad./nfiles); title('Fraction of bad data points in each file');
        xlabel('File number');
    end
    
    % Exclude any file having more than max_bad_datapoints_per_file bad datapoints
    ind = (nbad) >= max_bad_datapoints_per_file;
    bad_files = (filebins(ind));
    
    % Manually add some files we know are bad by visual inspection
    if ratN == 1; bad_files = [bad_files 188]; end
    if ratN == 1; bad_files = [bad_files 187 151 152 153 201 202 218 250 251 252 253 264 267 115 129 141 149 151:154]; end
    if ratN == 10; bad_files = [bad_files 5:11]; end        % Added to remove discontinuity during start.
    if ratN == 7; bad_files = [bad_files 108:111]; end        % High frequency data explodes near the end. Remove this


    %%% Remove ALL data points associated with bad files. This essentially
    %%% removes the bad files.
    % Note, this is extremely conservative.
    bad_indices = logical(zeros(1,length(fnum)));
    for i = 1:length(bad_files)
        bad_indices = bad_indices | (fnum == bad_files(i));
    end


    if plot_on
       figure('Position',[680   155   640   823]);
       subplot(211); plot(t,d,'b');
       hold on; plot(t(~bad_indices),d(~bad_indices),'k')
       legend('all data','good data');
       xlabel('Time (h)'); ylabel('Power (1-100 Hz');
       subplot(212); plot(fnum,d,'b.');
       hold on; plot(fnum(~bad_indices),d(~bad_indices),'k.')
       xlabel('Files');
       legend('all data','good data'); ylabel('Power (1-100 Hz');
       
%        figure; plot(t,log(d),'b.');
%        hold on; plot(t(~bad_indices),log(d(~bad_indices)),'k.')
    end


end

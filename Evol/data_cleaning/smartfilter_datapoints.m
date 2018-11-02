
function bad_indices = smartfilter_datapoints(t,d0,invert)
    % Works similar to smartfilter_files, but identifies bad data points
    % within files. Assumes it's only working with good files at this
    % stage.
    plot_on = 0;
    if ~invert
        bin_size = 5;
        envelope_threshold = 20;
    else
        plot_on = 0;
        bin_size = 5;
        envelope_threshold = 4;
        invertmax = 1/5;
    end
    
    if invert
        d = 1./d0;
        d(d>invertmax) = invertmax;
    else
        d = d0;
    end
    
    
    ind = find(t > bin_size,1,'first');
    ind2 = find(t > t(end) - bin_size,1,'first');
    d_temp = [fliplr(d(1:ind)) d fliplr(d(ind2:end))];
    t_temp = [-1*fliplr(t(1:ind)) t t(end) + -1*(fliplr(t(ind2:end))-t(end)) ];
    [t_sm d_sm d_std] = daveMVAVG_bin (t_temp, d_temp, bin_size, 0.5, 0.9,0); % Take average time spent in theta state.

    clear ind ind2
    
    temp = interp1(t_sm,d_sm,t);
    if ~invert envelope = temp + interp1(t_sm,d_std,t)*envelope_threshold;
    else envelope = temp + temp*envelope_threshold; end
    %envelope = temp + interp1(t_sm,d_std,t)*envelope_threshold;
    
    bad_indices = d > envelope;
    
    
    if plot_on
        figure; plot(t,d,'b.')
        
        if ~invert hold on; errorbar(t_sm,d_sm,d_std*envelope_threshold,'r.')
        else hold on; hold on; errorbar(t_sm,d_sm,d_sm*envelope_threshold,'r.'); end
        %hold on; errorbar(t_sm,d_sm,d_std*envelope_threshold,'r.')
        
        hold on; plot(t(bad_indices),d(bad_indices),'r.')
        legend('original data','envelope','good data')
        xlabel('time days');
    end

end
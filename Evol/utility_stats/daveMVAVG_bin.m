

function [t2 x2 x2_std] = daveMVAVG_bin (t, x, time_bin, fract_overlap, fract_maxgap, use_tcell_search)

    if nargin < 6
        use_tcell_search = 1;   % Identify time bins via a clever trick using cells, as opposed to just using "find"
    end                         % This is much faster for very large data sets containing large segments of partially
                                % contiguous data.

    eliminate_gaps = 1;
    testplot = 0;
    
    if nargin < 5; fract_maxgap=0.50; end
    if nargin < 4; fract_overlap = 0.50; end
    if fract_maxgap > 1.0; fract_maxgap=fract_maxgap/100; end % Convert percent to a fraction
    if (fract_overlap > 1); fract_overlap = fract_overlap / 100; end  % Convert percent to a fraction if need be.

%     x=x(:);
%     t=t(:);
%     filter = ones(time_bin, 1);
% %     figure; plot(t, x);
%     % Pad data sets
%     x = [zeros(time_bin-1, 1); x; zeros(time_bin-1, 1);];
%     t_padding = (1:time_bin-1)'*dt;
%     t = [(t(1) - flipud(t_padding)); t; (t(end)+t_padding)];
% %     hold on; plot(t, x, ':');

    if use_tcell_search
        dt = t(end)-t(end-1);
        [tcell, xcell] = matrix2cell (t,x,dt);
%         clear t x;
        tmins = zeros(1,length(tcell));
        tmaxs = tmins;
        for i = 1:length(tcell);
            tmins(i)=min(tcell{i});
            tmaxs(i)=max(tcell{i});
            tdiff = diff(tcell{i}) - dt;
            if (max(abs(tdiff))>=1e-5)
                fprintf('Error, discontinuity present!');
            end
        end
        
        
        tmax = max(tmaxs);
        tmin = min(tmins);
        tlen = tmax-tmin;
        fract_shift = 1.0-fract_overlap;
        shift = time_bin*fract_shift;
        if (shift <=0); shift = dt; end

        tbin_starts = tmin:shift:(tmax-time_bin);
        tbin_centres = tbin_starts + time_bin/2;
        nbins = length(tbin_centres);

        t2 = zeros(1,nbins);
        x2 = t2;
        x2_std = t2;
        if (testplot); figure(10); clf(10);
        figure(10); plot(t,x); end
        for i = 1:nbins
            tbin_min = tbin_starts(i);
            tbin_max = tbin_starts(i)+time_bin;
            t2(i) = tbin_centres(i);
            [tcellind tmatind] = find_tcell_ind (tmins, tmaxs, tbin_min, tbin_max, dt);
            if testplot
                hold on; plot([tbin_starts(i) tbin_starts(i)], [0 max(x)],'k');
                hold on; plot([tbin_starts(i)+time_bin tbin_starts(i)+time_bin], [0 max(x)],'r');
            end
            if ~isempty(tcellind)
                
%                 xmeans = zeros(1, length(tcellind));
                ttemp = []; xtemp = [];
                for j = 1:length(tcellind);
                    if tmatind(j,2)>size(tcell{tcellind(j)},2)
                        tmatind(j,2)=size(tcell{tcellind(j)},2);
                    end
                    ttemp=[ttemp tcell{tcellind(j)}(tmatind(j,1):tmatind(j,2))];
                    xtemp=[xtemp xcell{tcellind(j)}(tmatind(j,1):tmatind(j,2))];
                    if (testplot); hold on; plot(ttemp, xtemp,'r'); end
%                     xmeans(j) = mean(xtemp);
                end
%                 x2(i)=mean(xmeans);

                nan_gaps = sum(isnan(xtemp));
                if nan_gaps > 0
                    fprintf('Inf present in bin \n');
                    %ind_temp = find(~isnan(xtemp));
                    %xtemp = xtemp(ind_temp);
                end
                x2(i)=mean(xtemp);
                x2_std(i)=std(xtemp);
                if (testplot); hold on; plot(t2(1:i), x2(1:i), 'go-');
                end
                gaps = tmins(tcellind(2:end)) - tmaxs(tcellind(1:end-1));
                gaps = [(tcell{tcellind(1)}(tmatind(1,1))-tbin_min) gaps (tbin_max-tcell{tcellind(end)}(tmatind(end,end)))];
                gaps_pos = (gaps + abs(gaps))/2;
                totalgap = sum(gaps_pos);
                if (totalgap/time_bin > fract_maxgap)
                    x2(i)=NaN; % Gap is too large, discount data point
                    x2_std(i) = NaN;
                    %fprintf ('Gap too large \n');
                end
%                 if sum(gaps) < 0
%                     fprintf ('neggap');
%                 end
                
                
                tmin_error = tbin_min - tcell{tcellind(1)}(tmatind(1,1));
                tmax_error = tbin_max - tcell{tcellind(end)}(tmatind(end,2));
                if (tmin_error>dt/2 || tmax_error>dt/2 )
%                     fprintf ('Error in calculating indices \n');
%                     fprintf ('tbin_min - tcell{tcellind(1)}(tmatind(1,1)) = %d \n', tmin_error);
%                     fprintf ('tbin_max - tcell{tcellind(end)}(tmatind(end,2)) = %d \n', tmax_error);
%                     fprintf (' \n');
                end
                if length(tcellind)>1
%                     fprintf('Here! t-range is spanning multiple cells! \n');
                end
            else
                x2(i) = NaN;
            end
            
        end
    else
    
        % Sort data
        pairs = [t(:) x(:)];
        pairs = sortrows(pairs);
        t = pairs(:,1); x = pairs(:,2);
        
        tmax = max(t);
        tmin = min(t);
        tlen = tmax-tmin;
        dt = t(end)-t(end-1);
        N = length(x);
        fract_shift = 1.0-fract_overlap;

        shift = time_bin*fract_shift;
        if (shift <=0); shift = dt; end

    %     tbin_starts = tmin:shift:(tmax-time_bin+0.001); % this doesn't help
        tbin_starts = tmin:shift:(tmax-time_bin);
        tbin_centres = tbin_starts + time_bin/2;
        nbins = length(tbin_centres);

        t2 = zeros(1,nbins);
        x2 = t2;
        x2_std = t2;
        for i = 1:nbins

%             index = find ( (tbin_starts(i) <= t) .* (t < tbin_starts(i)+time_bin) );
            index1 = find ( (tbin_starts(i) <= t),1,'first');
            index2 = find ( ((tbin_starts(i)+time_bin) <= t),1,'first' ) -1;
            index = index1:index2;
            t2(i) = tbin_centres(i);
            if isempty(index)
                x2(i) = NaN;
                x2_std(i) = NaN;
                fprintf ('Gap too large \n');
            else
                xtemp = x(index); ttemp = t(index);
    %             figure(1);subplot(211); hold on; plot(ttemp, xtemp)
    %             subplot(212); plot(ttemp, xtemp)
                if (((1 - (length(index)*dt) / time_bin) > fract_maxgap) && dt > 1e-9)
                    x2(i) = NaN;
                    x2_std(i) = NaN;
                    fprintf ('Gap too large \n');
                else
                    x2(i) = mean(xtemp);
                    x2_std(i) = std(xtemp);
                end
            end
            clear xtemp ttemp
        end
    end
%     
%     first_tbin = tmin;
%     last_tbin = tmax - time_bin;
%     
%     nbins = ;
%     ttbin_dt = (max(tmod) - min(tmod))/(nbins);
%     ttbin_dt = (1 - 0) / (nbins);
%     ttbin = (0:nbins-1)*ttbin_dt;
% 
% 
%     x_mean=[];
%     x_std=[];
%     N_arr=[];
%     for i = 1:length(ttbin)
%        index2 = find ( (ttbin(i) <= tmod) .* (tmod < ttbin(i)+ttbin_dt) );
%        x_mean(i)=mean(datamean(index2));
%        x_std(i)=std(datamean(index2));
%        N_arr(i)=length(index2);
%     end
% 
%     
%     
%     
%     
%     
%     
%     loopvar = tbin_start:shift:tbin_end;
%     Nout = length(loopvar);
%     y=zeros(1,Nout); t2=y;
%     j=0;
% 
%     for i = loopvar
%         j=j+1;
%         x_temp = x(i:(i+time_bin-1));       % Extract current window of x
%         t_temp = t(i:(i+time_bin-1));  
%         index = find (x_temp > base_thresh);   % Find portion of window above threshold
%         amnt_good_data = length(index);
%         t2(j) = t(round(mean([i i+time_bin-1])));   % Get time point
%         if ( (time_bin-amnt_good_data)/time_bin <= fract_maxgap)   % Make sure gaps in our window are less than allowed percent.
% %             hold on; plot(t_temp, x_temp,'r');
%             y(j)=(filter(1:amnt_good_data)' * x_temp(index)) / amnt_good_data;  % Do moving average of only the good data.
%         else
%             y(j)=-Inf;
%         end   
%     end
% 
%     index2 = find (y>-Inf);
%     y=y(index2);
%     t2=t2(index2);
%     
%     y=y(:);
%     t2=t2(:);

    if eliminate_gaps
        good_index = find(~isnan(x2));
        x2 = x2(good_index);
        x2_std = x2_std(good_index);
        t2 = t2(good_index);
    end

end

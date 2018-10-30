

function [t2 x2 x2_std] = daveMVAVG_MAT (t, x, time_bin, fract_overlap, fract_maxgap)

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

    
        % Sort data
        pairs = [t(:) x];
        pairs = sortrows(pairs,1);
        t = pairs(:,1); x = pairs(:,2:end);
        
        tmax = max(t);
        tmin = min(t);
        tlen = tmax-tmin;
        dt = t(end)-t(end-1);
        N = size(x,1);
        fract_shift = 1.0-fract_overlap;

        shift = time_bin*fract_shift;
        if (shift <=0); shift = dt; end

    %     tbin_starts = tmin:shift:(tmax-time_bin+0.001); % this doesn't help
        tbin_starts = tmin:shift:(tmax-time_bin);
        tbin_centres = tbin_starts + time_bin/2;
        nbins = length(tbin_centres);

        t2 = zeros(nbins,1);
        x2 = zeros(nbins,size(x,2));
        x2_std = x2;
        timestart = clock;
        for i = 1:nbins

            index1 = find ( (tbin_starts(i) <= t),1,'first');
            index2 = find ( ((tbin_starts(i)+time_bin) <= t),1,'first' ) -1;
            index = index1:index2;
            
%             index2 = find((t >= tbin_starts(i)) & (t <(tbin_starts(i)+time_bin)));
            
            t2(i) = tbin_centres(i);
            if isempty(index)
                x2(i,:) = repmat(NaN,1,size(x,2));
                x2_std(i,:) = repmat(NaN,1,size(x,2));
                %fprintf ('Gap too large \n');
            else
                xtemp = x(index,:); ttemp = t(index);
                if testplot
                figure(1);subplot(211); hold on; plot(ttemp, xtemp)
                subplot(212); plot(ttemp, xtemp); end
                if (((1 - (length(index)*dt) / time_bin) > fract_maxgap) && dt > 1e-9)
                    x2(i,:) = repmat(NaN,1,size(x,2));
                    x2_std(i,:) = repmat(NaN,1,size(x,2));
                    %fprintf ('Gap too large \n');
                else
                    x2(i,:) = mean(xtemp,1);
                    x2_std(i,:) = std(xtemp,1);
                end
                
                if testplot
                    subplot(211); plot(t2,x2)
                end
            end
            clear xtemp ttemp
        end
        timestop=clock;
        calctime = timestop - timestart
        
    if eliminate_gaps
        
        good_index = find(~isnan(x2(:,1)));
        
        x2 = x2(good_index,:);
        x2_std = x2_std(good_index,:);

%         x2 = reshape(x2(repmat(good_index,1,size(x2,2))),sum(good_index),size(x2,2));
%         x2_std = reshape(x2_std(repmat(good_index,1,size(x2_std,2))),sum(good_index),size(x2_std,2));
        t2 = t2(good_index);
        
%         x2 = x2(good_index);
%         x2_std = x2_std(good_index);
        
    end

end

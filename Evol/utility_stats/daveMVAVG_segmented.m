

function [t2 y] = daveMVAVG_segmented (t, x, len_filt, fract_overlap, base_thresh, max_gap_fract)

    if nargin < 6; max_gap_fract=0.50; end
    if nargin < 5; base_thresh = 0; end
    if max_gap_fract > 1.0; max_gap_fract=max_gap_fract/100; end % Convert percent to a fraction

    x=x(:);
    t=t(:);
    dt = t(end)-t(end-1);
    filter = ones(len_filt, 1);
%     figure; plot(t, x);
    % Pad data sets
    x = [zeros(len_filt-1, 1); x; zeros(len_filt-1, 1);];
    t_padding = (1:len_filt-1)'*dt;
    t = [(t(1) - flipud(t_padding)); t; (t(end)+t_padding)];
%     hold on; plot(t, x, ':');
    

    if (fract_overlap > 1); fract_overlap = fract_overlap / 100; end  % Convert percent to a fraction if need be.
    shift_fraction = 1.0-fract_overlap;
    N = length(x);
    fil_start = 1;
    fil_end = N - len_filt + 1; % Go from start to end of padded dataset


    shift = round(len_filt*shift_fraction);
    if (shift <=0); shift = 1; end

    loopvar = fil_start:shift:fil_end;
    Nout = length(loopvar);
    y=zeros(Nout, 1); t2=zeros(Nout, 1);
    j=0;
%     figure;plot(t,x);
    for i = loopvar
        j=j+1;
        x_temp = x(i:(i+len_filt-1));       % Extract current window of x
%         t_temp = t(i:(i+len_filt-1));  
        index = find (x_temp > base_thresh);   % Find portion of window above threshold
        amnt_good_data = length(index);
        t2(j) = t(round(mean([i i+len_filt-1])));   % Get time point
        if ( (len_filt-amnt_good_data)/len_filt <= max_gap_fract)   % Make sure gaps in our window are less than allowed percent.
%             hold on; plot(t_temp, x_temp,'r');
            y(j)=(filter(1:amnt_good_data)' * x_temp(index)) / amnt_good_data;  % Do moving average of only the good data.
        else
            y(j)=-Inf;
        end   
    end

    index2 = find (y>-Inf);
    y=y(index2);
    t2=t2(index2);
    
    y=y(:);
    t2=t2(:);
end

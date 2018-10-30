

function [A phi tbin_cent] = fit_sinusoids (t, x, period, fract_maxgap)
    global per
    
    FS_axis_sm = 30;
    plot_on = 1;
    autoscale = 0;
    plot_icon = '';
    if max(t) < 10*period; plot_icon = '.'; end     % Assume t has been rolled back scenario
    per = period;
    if nargin < 4; fract_maxgap = 0.5; end
    if nargin < 3; period = 1.0; end
    if fract_maxgap > 1.0; fract_maxgap = fract_maxgap / 100; end
    
    tmin = min(t);
    tmax = max(t);
    tstart = floor (tmin/period)*period;
    tend = ceil(tmax/period)*period;

    tbin_starts = tstart:period:(tend-period);
    tbin_cent = tbin_starts + period/2;
    A=zeros(1,length(tbin_starts));
    phi=A;
    if plot_on; figure; set (gcf,'Color','w'); end
    for i=1:length(tbin_starts)
        index = find ( (tbin_starts(i) <= t) .* (t < tbin_starts(i)+period) );
        ttemp = t(index); xtemp = x(index);
        %if plot_on; hold on; plot(ttemp, xtemp, ['r' plot_icon],'MarkerSize',24); end
        if plot_on; hold on; plot([tbin_starts(i) tbin_starts(i)], [min(x) max(x)],'k--','LineWidth',2); end
        if plot_on; hold on; plot([tbin_starts(i)+period tbin_starts(i)+period], [min(x) max(x)],'k--','LineWidth',2); end
        if (length(find(isnan(xtemp)))/length(xtemp) > fract_maxgap)
            fprintf('Error, gap too large. No data');
            A(i)=NaN;
            phi(i)=NaN;
        elseif length(xtemp) < 5
            fprintf('Error, Too few data points');
            A(i)=NaN;
            phi(i)=NaN;
        else
            index1=find(~isnan(xtemp));
            xtemp=xtemp(index1); ttemp=ttemp(index1);
            if plot_on; hold on; plot(ttemp, xtemp, ['g' plot_icon],'MarkerSize',24); end
            if plot_on;
                hold on; % Plot raw data with standard deviation of 1-hour bins
%                 [t2 x2 x2_std] = daveMVAVG_bin (ttemp,xtemp,1/24,0.1,0.9,0);
%                 errorbar(t2,x2,x2_std);
            end
            coefs0=[std(xtemp), 0.5];
            ub = [Inf, period]; lb = [0, 0];
            coefs = lsqcurvefit(@cosfun,coefs0,ttemp, xtemp-mean(xtemp), lb, ub);
%             coefs = lsqcurvefit(@cosfun,coefs0,ttemp, xtemp-mean(xtemp));
            A(i)=coefs(1);
%             phi(i)=mod(coefs(2),period);            % Fix this - find a better way, maybe put bounds on curve fitting
            phi(i)=coefs(2);            % Fix this - find a better way, maybe put bounds on curve fitting
            if plot_on; hold on; plot(ttemp, cosfun(coefs,ttemp)+mean(xtemp),'k.','MarkerSize',24); end
            
            
        end
        
    end
    
    if plot_on; xlabel('time (days)','FontSize',FS_axis_sm); set(gca,'FontSize',FS_axis_sm); end
    if plot_on
        if autoscale
            ymin = min(cosfun(coefs,ttemp)+mean(xtemp));
            ymax = max(cosfun(coefs,ttemp)+mean(xtemp));
            ymid = (ymin + ymax) / 2;
            ydelta = (ymax-ymin)/2;
            axis([-0.01 1.05 (ymid-ydelta*5) (ymid+ydelta*5)]);
        end
    end
end



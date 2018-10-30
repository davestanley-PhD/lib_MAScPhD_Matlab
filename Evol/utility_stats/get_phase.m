
function [A_mean phi_mean A_err phi_err] = get_phase (t, x, period, use_rollback, rollback_period )

    if nargin < 5; rollback_period = period; end
    if nargin < 4; use_rollback=0; end
    plot_on = 0;
    
    if ~use_rollback
        [A phi t_sin] = fit_sinusoids (t, x, period);
        index1=find(~isnan(A));
        t_sin = t_sin(index1);
        A = A(index1);
        phi = phi(index1);

        phi_vect = exp(2*pi*i*phi);
        phi_vect2 = sum(phi_vect) / length(phi_vect)
        phi_angle = angle(phi_vect2) / 2/pi;
        if phi_angle < 0; phi_angle = phi_angle + 1; end
        A_mean=mean(A);
        phi_mean_old=mean(phi);
        phi_mean = phi_angle;
        A_err=std(A) / length(A);
        phi_err_old=std(phi) / length(phi);
        phi_err = 0;


        if (plot_on)
            figure;
            subplot(211); plot(t_sin, A);
            subplot(212); plot(t_sin, phi);
        end
    
    else
        troll = mod(t,rollback_period);
        [A phi t_sin] = fit_sinusoids (troll, x, period, 1.0);
        
        index1=find(~isnan(A));
        t_sin = t_sin(index1);
        A = A(index1);
        phi = phi(index1);

        A_mean=mean(A);
        phi_mean=mean(phi);
        A_err = 0;
        phi_err = 0;
        
    end

end
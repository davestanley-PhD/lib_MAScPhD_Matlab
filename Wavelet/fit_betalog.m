
function [const_est beta_est fit_list] = fit_beta_log (f, fft_val, intlist)


intlist = sortrows (intlist);
[row col] = size(intlist);
if intlist(row,1) > (max(f))
    'Warning: Fitting values above Nyquest frequency. Consider adjusting intlist'
end
df = f(2) - f(1);

%For curve fitting, we need to exclude the regions of the graph that have been filtered
    %Find the indicies that have been filtered and therefore need to be excluded
    exclude_list = [];
    for i = 1:(size(intlist, 1))
        exclude_list = [exclude_list find(f >= (intlist(i,1)-df) & f <= (intlist(i,2)+df) )];
    end
    
    % Use this trick to obtain the "inverse" list 
    unfiltered_index = 1:length(f);
    unfiltered_index(exclude_list) = -1;
    fit_list = find (unfiltered_index >= 0);


p = polyfit(log10(f(fit_list)), log10(abs(fft_val(fit_list)).^2),1);
beta_est = p(1);
const_est = p(2);




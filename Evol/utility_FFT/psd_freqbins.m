
function [fout Fout] = psd_freqbins (f, F, f_bins, f_centers, f_width)
    

    filter_out_60Hz = 1;
    plot_on = 0;
    colourarr = 'bgrmcykbgrmcykbgrmcykbgrmcykbgrmcykbgrmcykbgrmcyk';
    
    df = f(2) - f(1);

    if isempty(f_bins)
        f_bins = [];
        f_centers = (f_centers(:))';
        f_bins = [f_centers-f_width/2; f_centers+f_width/2];
        f_width_arr = diff(f_bins);
    else
        f_centers = mean(f_bins);
        f_width_arr = diff(f_bins);
    end
    
    if plot_on;
        figure;
        hold on; plot(f,F);
    end
    Fout = zeros(1,length(f_centers));
    for i=1:length(f_centers)
        index = find((f >= f_bins(1,i)) .* (f < f_bins(2,i)));
        if filter_out_60Hz
            index = find((f >= f_bins(1,i)) .* (f < f_bins(2,i)) .* ~((f > 58) .* (f < 62)) );
        end
        
        Fout(i) = sum(F(index));
        
        if plot_on
            hold on; plot(f(index),F(index),[colourarr(mod(i,length(colourarr))) '.']);
            hold on; plot(f_centers(i),Fout(i),[colourarr(mod(i+1,length(colourarr))) 'o']);
        end
    end
    
    fout = f_centers;

end

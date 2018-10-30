
clc
format compact
ratNum='004';
path_ratlog='../../RatData_out';
outlog_path = './outlog2';
[outlog_path outlog_name] = save_log(path_ratlog, ratNum,outlog_path);   % Save log file


path_ratlogmat='.';
path_ratout='../../RatData_out';
path_savemat='.';
chNum='11';
statType='stdev';
[out_path out_name] = save_rat_data(path_ratlogmat, path_ratout, path_savemat,ratNum,chNum,statType);   % Save rat file




load ([outlog_path '/' outlog_name])    % Load log file
load ([out_path '/' out_name])  % Load rat data file


datamean = mean(data);
% t=tabs-tabs(1);
t=tabs-(floor(tabs(1)));

figure; plot(t,datamean,'b');

cutoff_min=200;
cutoff_max=1000;
tstart = 15;
tstop = 40;
index = find((datamean>cutoff_min) .* (datamean<cutoff_max) .* ((tstart <= t) .* (t <= tstop)) );
datamean=datamean(index); t=t(index);
trel_selected=trel(index);
hold on; plot([min(t) max(t)], [cutoff_min cutoff_min],'r:');
hold on; plot([min(t) max(t)], [cutoff_max cutoff_max],'r:');
hold on; plot([tstart tstart], [min(datamean) max(datamean)],'r:');
hold on; plot([tstop tstop], [min(datamean) max(datamean)],'r:');
hold on; plot(t, datamean, 'g:'); legend('original','cutoff','postprocessed');

tmod=mod(t,1);
figure; plot(tmod, datamean, 'ko');
hold on; plot(trel_selected, datamean, 'ro');
xlabel('time (days)'); ylabel('mean stdev');
title(['Mean EEG STDev vs Time, Rat' ratNum ', Ch.' chNum]);

nbins = 24;
tbin_dt = (max(tmod) - min(tmod))/(nbins);
tbin_dt = (1 - 0) / (nbins);
tbin = (0:nbins-1)*tbin_dt;


x_mean=[];
x_std=[];
N_arr=[];
for i = 1:length(tbin)
   index = find ( (tbin(i) <= tmod) .* (tmod < tbin(i)+tbin_dt) );
   x_mean(i)=mean(datamean(index));
   x_std(i)=std(datamean(index));
   N_arr(i)=length(index);
end

figure;
mean_num_cycles_per_datapoint = mean(N_arr);
% bar(tbin, x_mean);
hold on; errorbar(tbin, x_mean, x_std./N_arr,'ko');
xlabel('time (days)'); ylabel('mean stdev'); legend('errorbar=STE');
title(['Mean EEG STDev vs Time, Rat' ratNum ', Ch.' chNum]);



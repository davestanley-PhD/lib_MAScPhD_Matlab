function [out_path out_name]= save_rat_data(path_ratlogmat, path_ratout, path_savemat,ratNum,chNum,statType)
%function plot_rat_data(ratNum,chNum,statType)
%ratNum must be string: '003', '004', '006, '008', or '013'
%chNum is string version of ch 1-32.  ex: '03', '09', '12', or '31'
%statType is string 'stdev' 'skew' or 'kurt'

logName = strcat(path_ratlogmat,'/','Rat',ratNum,'log.mat');
load(logName);
%cd(strcat('/media/LaCie/RatData/Rat',ratNum,'/bin1000/'))

%This variable size is from the max number of entries for the statistics
%files for Rat 13.  This number is different for rat 4
% size = 14398;

% % % % % % % % % % % % % % % % % % % Brian's original code using Matrix
% data=zeros(numFiles,14398);
% for i = 1:numFiles
%    strtemp=fileNames{i};
%    fname = strcat(path_ratout,'/Rat',ratNum,'/bin1000/','Rat',ratNum,'ch',chNum,'F',strtemp(1:4),'_',statType,'.bin');
%    filenums(i)= str2num(strtemp(1:4));
%    fid = fopen(fname,'rb');
%    if (fid ~= -1)
%       dtemp = fread(fid, inf, 'double');
%       [m,n] = size(dtemp);
%       data(i,1:m)=dtemp';
%       fclose(fid);
%    else
%         fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
%    end
% end
% data=data';

% % % % % % % % % % % % % % % % % % Use cell array
data_cell={};
max_length=0;
for i = 1:numFiles
   strtemp=fileNames{i};
   fname = strcat(path_ratout,'/Rat',ratNum,'/bin1000/','Rat',ratNum,'ch',chNum,'F',strtemp(1:4),'_',statType,'.bin');
   filenums(i)= str2num(strtemp(1:4));
   fid = fopen(fname,'rb');
   if (fid ~= -1)
      dtemp = fread(fid, inf, 'double');
      dtemp = dtemp(:);
      data_cell{i}=dtemp';
      ldtemp = length(dtemp);
      if ldtemp>max_length; max_length=ldtemp; end
      fclose(fid);
   else
        fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
   end
end
data=zeros(max_length,numFiles);
for i=1:length(data_cell)
    dtemp=data_cell{i};
    ldtemp = length(dtemp);
    data(1:ldtemp,i)=dtemp;
end


currdir = pwd;
out_path=strcat(path_savemat,'/','Rat',ratNum);
[s,mess,messid] = mkdir(path_savemat);
[s,mess,messid] = mkdir(out_path);
cd(out_path)
out_name = strcat('DataRat',ratNum,'ch',chNum,'_',statType,'.mat');
% save(out_name,'data', 'filenums')
save(out_name,'data_cell', 'data', 'filenums')
cd (currdir)


% cd ~/Documents/Ma'tlab Files'/
%fid = fopen('Rat004ch01F0012_stdev.bin','rb');   %open file
%data1 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);  %close file
%fid = fopen('Rat004ch01F0013_stdev.bin','rb');   %open file
%data2 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);   %close file

end


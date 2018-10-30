function save_rat_data(ratNum,chNum,statType)
%function plot_rat_data(ratNum,chNum,statType)
%ratNum must be string: '003', '004', '006, '008', or '013'
%chNum is string version of ch 1-32.  ex: '03', '09', '12', or '31'
%statType is string 'stdev' 'skew' or 'kurt'

logName = strcat('Rat',ratNum,'log.mat');
load(logName);
%cd(strcat('/media/LaCie/RatData/Rat',ratNum,'/bin1000/'))

%This variable size is from the max number of entries for the statistics
%files for Rat 13.  This number is different for rat 4
size = 14398;

data=zeros(numFiles,14398);

for i = 1:numFiles
   strtemp=fileNames{i};
   fname = strcat('/media/LaCie/RatData/Rat',ratNum,'/bin1000/','Rat',ratNum,'ch',chNum,'F',strtemp(1:4),'_',statType,'.bin');
   fid = fopen(fname,'rb');
   if (fid ~= -1)
      dtemp = fread(fid, inf, 'double');
      [m,n] = size(dtemp);
      data(i,1:m)=dtemp';
      fclose(fid);
   end
end
dName=strcat('/media/LaCie/RatData/Rat',ratNum,'/');
cd(dName)
fileNametoSave = strcat('DataRat',ratNum,'ch',chNum,'_',statType,'.mat');
save(fileNametoSave,'data')

cd ~/Documents/Ma'tlab Files'/
%fid = fopen('Rat004ch01F0012_stdev.bin','rb');   %open file
%data1 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);  %close file
%fid = fopen('Rat004ch01F0013_stdev.bin','rb');   %open file
%data2 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);   %close file



end
function [data_cell filenums] = load_imf(path_data,ratNum,chNum,fileNames,statType, curr_imf, start_imf, end_imf)
%function plot_rat_data(ratNum,chNum,statType)
%ratNum must be string: '003', '004', '006, '008', or '013'
%chNum is string version of ch 1-32.  ex: '03', '09', '12', or '31'
%statType is string 'stdev' 'skew' or 'kurt'

if nargin < 9 
    end_imf = 10;
end
if nargin < 8
    start_imf = 6;
    if ratNum == '001'
        start_imf = 6;
    end
    if (strcmp(ratNum,'004')) && (strcmp(chNum,'02'))
        start_imf = 3;
    end
    if (strcmp(ratNum,'009')) && (strcmp(chNum,'02'))
        start_imf = 3;
    end
    if ratNum == '013'
        start_imf = 6;
    end
end

imfN = str2num(curr_imf);

header_type = 'uint64';
if statType == 'dpts'
    dat_type = 'uint32';
elseif statType == 'xtrm'
    dat_type = 'float';
end


data_cell={};
filenums = [];
max_length=0;
for i = 1:length(fileNames)
   strtemp=fileNames{i};
   fname = strcat(path_data,'/Rat',ratNum,'/EMD/','Rat',ratNum,'ch',chNum,'F',strtemp(1:4),'_',statType,'.bin');
   data = readbin_emd (fname, dat_type, imfN, start_imf, end_imf, header_type);
   filenums(i)= str2num(strtemp(1:4));
   data_cell{i} = data;
end




% cd ~/Documents/Ma'tlab Files'/
%fid = fopen('Rat004ch01F0012_stdev.bin','rb');   %open file
%data1 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);  %close file
%fid = fopen('Rat004ch01F0013_stdev.bin','rb');   %open file
%data2 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);   %close file

end


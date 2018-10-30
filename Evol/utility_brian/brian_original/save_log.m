
% This file reads in the log file and saves the time and other information
% to be read in later


function SaveLog(ratNum)
%Ratnum must be the string with the rat number like '004' and '008'

logName = strcat('Rat',ratNum,'EEG.log');
fid = fopen(logName,'r');
format = '%s %s %f %f %f %f %f %f %s %s %s %s %s %s %d32 %s %s';
format = strcat('Rat',ratNum,'ch01F',format);
A=textscan(fid,format,'delimiter',':- \b\t','multipledelimsasone',1,'Headerlines',1);
fclose(fid);

fileNames=A{1};
dates=A{2};
hrStart=A{3};
minStart=A{4};
secStart=A{5};
hrEnd = A{6};
minEnd = A{7};
secEnd = A{8};
numSamples = A{15};
[numFiles,n]=size(numSamples);

Fsave = strcat('Rat',ratNum,'log');
save(Fsave,'fileNames','dates','hrStart','minStart','secStart','hrEnd','minEnd','secEnd','numSamples','numFiles')



%cd ~/rat/RatData_out/Rat004/bin1000/
%read in the same file

%fid = fopen('Rat004ch01F0012_stdev.bin','rb');   %open file
%data1 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);  %close file
%fid = fopen('Rat004ch01F0013_stdev.bin','rb');   %open file
%data2 = fread(fid, inf, 'double');  %read in the data
%fclose(fid);   %close file
%cd ~/Documents/Ma'tlab Files'/
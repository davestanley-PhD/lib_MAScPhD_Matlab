

function [dtemp]= readbin_temp(fname, dat_type, pos, len, skip)
% pos - Position in array to seek to
% len - Number of data points to read in
% (Neither of these are in bytes!)

if (~exist('skip','var')); skip=0; end

if strcmp(dat_type,'uint32')
    sizeof_data = 4;
elseif strcmp(dat_type,'float')
    sizeof_data = 4;
elseif strcmp(dat_type,'double')
    sizeof_data = 8;
elseif strcmp(dat_type,'int16')
    sizeof_data = 2;
else
    fprintf('Unknown data type \n');
    sizeof_data = -1;
end


fid = fopen(fname,'rb');
if (fid ~= -1)
       
       dtemp = fread(fid,Inf,dat_type);

       dtemp = dtemp(:);
       fclose(fid);
   else
        fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
        dtemp = [];
end
   
end
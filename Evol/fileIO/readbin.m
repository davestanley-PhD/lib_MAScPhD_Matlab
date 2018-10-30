

function [dtemp]= readbin(fname, dat_type, pos, len, skip)

% INPUTS
% fname = your file name, for example 'blah.bin'
% dat_type = one of uint32, float, double, int16, int8, int32, int64
% pos - Position in array to seek to
% len - Number of data points to read in
% (Neither of these are in bytes!)
% 
% OUTPUTS
% dtemp = your data

if (~exist('skip','var')); skip=0; end
if (~exist('pos','var')); pos=0; end
if (~exist('len','var')); len=Inf; end

if strcmp(dat_type,'uint32')
    sizeof_data = 4;
elseif strcmp(dat_type,'float')
    sizeof_data = 4;
elseif strcmp(dat_type,'double')
    sizeof_data = 8;
elseif strcmp(dat_type,'int16')
    sizeof_data = 2;
elseif strcmp(dat_type,'int8')
    sizeof_data = 1;
elseif strcmp(dat_type,'int32')
    sizeof_data = 4;
elseif strcmp(dat_type,'int64')
    sizeof_data = 8;
else
    fprintf('Unknown data type \n');
    return
end


fid = fopen(fname,'rb');
if (fid ~= -1)
       fseek (fid, sizeof_data*pos, 'bof');    %Seeks in bytes
       dtemp = fread(fid,len,dat_type,skip*sizeof_data);

       dtemp = dtemp(:);
       fclose(fid);
   else
        fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
        dtemp = [];
end
   
end
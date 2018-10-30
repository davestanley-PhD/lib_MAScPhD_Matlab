

function [dtemp]= readbin_emd(fname, dat_type, curr_imf, start_imf, end_imf, header_type)

if nargin < 6
    header_type = 'uint64';
end
if nargin < 5
    fprintf ('Usage: filename, data type (float, double, etc), imf of interest, starting_imf (smallest), \n');
    fprintf ('ending imf (largest), header data type \n. Exiting...');
    dtemp = [];
    return
end


if strcmp(dat_type,'uint32')
    sizeof_data = 4;
elseif strcmp(dat_type,'float')
    sizeof_data = 4;
end
sizeof_long = 8;

    fid = fopen(fname,'rb');
    if (fid ~= -1)
           len = (end_imf - start_imf + 1)*2;
           fseek (fid, 0, 'bof');
           header = fread(fid, len,header_type);
           fseek (fid, header((curr_imf-start_imf)*2+1)*sizeof_data + len*sizeof_long, 'bof');
           dtemp = fread(fid,header((curr_imf - start_imf)*2+2),dat_type);

           dtemp = dtemp(:);
           fclose(fid);
       else
            fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
            dtemp = [];
    end
   
end
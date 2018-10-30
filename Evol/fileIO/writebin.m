



function [count]= writebin(fname, X, dat_type)

%     if strcmp(dat_type,'uint32')
%         sizeof_data = 4;
%     elseif strcmp(dat_type,'float')
%         sizeof_data = 4;
%     elseif strcmp(dat_type,'double')
%         sizeof_data = 8;
%     elseif strcmp(dat_type,'int16')
%         sizeof_data = 2;
%     elseif strcmp(dat_type,'int8')
%         sizeof_data = 1;
%     elseif strcmp(dat_type,'int32')
%         sizeof_data = 4;
%     elseif strcmp(dat_type,'int64')
%         sizeof_data = 8;
%     else
%         fprintf('Unknown data type \n');
%         return
%     end


    fid = fopen(fname,'w');
    if (fid ~= -1)
            precision = dat_type;
            count = fwrite(fid, X(:), precision);
            fclose(fid);
       else
            fprintf (['Data file ' fname ' not found! Assume missing and continuing. \n'])
            dtemp = [];
    end
   
end
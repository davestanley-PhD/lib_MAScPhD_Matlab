


% path (path, 'C:\Documents and Settings\Dave\Desktop\MATLAB\Wavelet');
% path (path, 'C:\Documents and Settings\Dave\Desktop\MATLAB\Wavelet\utility');

% path (path, 'F:\2007-7_Documents\Skule\Thesis_Neural\MATLAB\Wavelet');
% path (path, 'F:\2007-7_Documents\Skule\Thesis_Neural\MATLAB\Wavelet\utility');


% path (path, '/media/KINGSTON/2007-7_Documents/Skule/Thesis_Neural/MATLAB/Wavelet/utility')
% path (path, '/media/KINGSTON/2007-7_Documents/Skule/Thesis_Neural/MATLAB/Wavelet')



cd ..


path (path, pwd)

cd utility_brian
path (path, pwd)
cd ..

cd utility_stats
path (path, pwd)
cd ..

cd utility_EMD
path (path, pwd)
cd ..

cd utility_FFT
path (path, pwd)
cd ..

cd fileIO
path (path, pwd)
cd ..

cd utility
path (path, pwd)





currpath_evol = pwd;

cd ../../Wavelet/utility;

set_path_CaRes

cd (currpath_evol);
clear currpath_evol
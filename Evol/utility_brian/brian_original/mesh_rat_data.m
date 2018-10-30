function mesh_rat_data(ratNum,statType)

%function mesh_rat_data(ratNum,statType)

%Function takes data and turns it into one long array where each datapoint
%corresponds to a second in time

%ratNum must be string: '003', '004', '006, '008', or '013'
%chNum is string version of ch 1-32.  ex: '03', '09', '12', or '31'
%statType is string 'stdev' 'skew' or 'kurt'


cd ~/Documents/Matl'ab Files'/
logName = strcat('Rat',ratNum,'log.mat');
load(logName);

dayStart = day_of_year(dates{1});
dayEnd = day_of_year(dates{end});
totalNumDays = dayEnd-dayStart+1;
totalTime = totalNumDays*24*60*60;






%Code to arrange by date




for i = 1:32
    
    totalData = zeros(1,totalTime);
    
    if i<10
        chNum = strcat('0',num2str(i));
    else
        chNum = num2str(i);
    end
    
    fName  = strcat('/media/LaCie/RatData/Rat',ratNum,'/DataRat',ratNum,'ch',chNum,'_',statType,'.mat');
    load(fName);


    for j =1:numFiles
        if (nnz(data(j,:)) ~= 0)
            dayOfFile = day_of_year(dates{j})-dayStart;
            index = int32(dayOfFile*24*3600+hrStart(j)*3600+minStart(j)*60+secStart(j));
            [n,m] = size(data(j,:));
            totalData(index:index+m-1) = data(j,:);
        end
    end

    fName = strcat('/media/LaCie/RatData/Rat',ratNum,'/','TimeRat',ratNum,'ch',chNum,'_',statType,'.mat');
    save(fName,'totalData')    
end
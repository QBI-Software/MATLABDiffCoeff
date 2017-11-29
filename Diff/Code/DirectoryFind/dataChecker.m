function [uFP,allDataFound] = dataChecker(eFP)

if isempty(eFP) == 1
    uFP = []; allDataFound = [];
    return
end

% check if there are any more subdirectories in the expanded foldsParent
for n = 1:size(eFP,1);
   dirFlag(n,:) = eFP(n,:).isdir; % check if is a directory
end

% count number of directories and compare to total number of files found
sumFlag = sum(dirFlag);
numCheck = size(eFP,1) - sumFlag;

if sumFlag == 0;
    allDataFound = 1;
elseif numCheck >= 0;
    allDataFound = 0;

end

% start testing for 'AllROI-D/MSD.txt' files
% eliminate non-'AllROI' files from the foldsParent list
for n = 1:size(eFP,1);
    if eFP(n,:).isdir == 1; % skip step if a directory
        tempStruct(n,:) = eFP(n,:);
    elseif eFP(n,:).isdir == 0;
        tempCheck = strfind(eFP(n,:).name,'AllROI'); % check if correct name
        if tempCheck == 1;
            tempStruct(n,:) = eFP(n,:);
        end
    end
end

uFP = tempStruct; % update foldsParent

for n = 1:size(uFP,1);
    isEmpt(n,:) = isempty(uFP(n,:).name);
end

elimUFP = find(isEmpt);
uFP(elimUFP,:) = [];

end

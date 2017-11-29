function [foldsParent,checkDir,numSubs] = checkDirectory(ParentFolderName);

% get information about parent directory
foldsParent = dir(ParentFolderName); % store all files/folders within parent
numFoldsParent = size(foldsParent,1); 
    foldsParent = foldsParent([3:numFoldsParent],1); % remove '..' & '.'
for n = 1:size(foldsParent,1);
    dirFlag(n,:) = foldsParent(n,:).isdir; % determine if components are directories
end
sumDir = sum(dirFlag);
    numSubs = size(foldsParent,1);
    checkDir = numSubs - sumDir; % check if all files or if some are directories
    
end
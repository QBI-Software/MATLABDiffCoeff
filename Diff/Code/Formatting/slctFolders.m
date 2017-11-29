function [foldersAnalyse,numFiles] = slctFolders(foldsParent,fileLoc);

% get folder names
for n = 1:size(foldsParent,1);
    folderName{n} = foldsParent(n,:).folder;
end

% determine folder name which are unique
uniqueFolders = unique(folderName);
    uniqueElim = uniqueFolders;
    uniqueElim = uniqueElim(:); % restructure to a vertical array

% remove selected files from the analysis
maxLoc = length(uniqueFolders);
    threshLoc = 1:maxLoc;
    threshLoc([fileLoc]) = [];
    uniqueElim(threshLoc) = [];
foldersAnalyse = uniqueElim;
numFiles = size(foldersAnalyse,1);
end
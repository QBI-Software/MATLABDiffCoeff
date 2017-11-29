function [uFP,allDataFound] = findFolds(foldsParent);

% calculate number of subdirectories in the parent folder
[dataDir,fullFileArray] = subdirFinder(foldsParent); 

% remove found data files which are not .txt and empty direcotires
[sFA,sFP,sDD] = dataEliminator(foldsParent,dataDir,fullFileArray);

% expand foldsParent to include all newly found subdirectories and files
% including any suitable .txt files foun earlier
eFP = folderExpand(sFP,sDD);

% check if all data has been found and eliminate the incorrect .txt files
[uFP,allDataFound] = dataChecker(eFP);

end
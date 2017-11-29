function [sFA,sFP,sDD] = dataEliminator(foldsParent,dataDir,fullFileArray);

% eliminate any non .txt files from parent directory
% keep any directories in the parent folder for further searching

numFolds = numel(dataDir);
ext = cell(numFolds,1);
for iRow = 1:numFolds;
% eliminate previous iterations deletion values
txtSave = [];
isBlank = [];
tempData = [];
dirflag = [];
ext = [];
dElim = [];

% get info about each found directory
tempData = dataDir{iRow}; % extract struct info for each directory
for n = 1:size(tempData,1);
    ext{n} = strfind(tempData(n,:).name,'.txt'); % determine if .txt file
    dirflag{n} = tempData(n,:).isdir; % determine if a directory
    isBlank(n,:) = isempty(ext{n}); % return a 1 if not a .txt file
end

dirflagMat = cell2mat(dirflag); % convert logical to matrix
isaDir = find(dirflagMat); % find the row values of the directories
txtSave = find(isBlank); % find the row values of the non .txt files
dElim = setdiff(txtSave,isaDir); % generate list of row values to eliminate
    tempData(dElim,:) = []; % remove non .txt data from the dataDir

dataDir{iRow} = tempData; % replace old dataDir struct with shortened one
sizeStruct(iRow,:) = size(dataDir{iRow},1); % find empty directories
end

% re-define new data directories
emptyStruct = find(sizeStruct);
sDD = dataDir(emptyStruct,:);
sFP = foldsParent(emptyStruct,:);
sFA = fullFileArray(emptyStruct,:);

if isempty(sFP) == 1
    msgbox('There are no .txt files in any of the subdirectories');
end

end
function [dataDir,fullFileArray] = subdirFinder(foldsParent) 

% find the number of sub directories within the parent folder
% generate a cell array to store the full subfolder directories
numFF = size(foldsParent,1);
fullFileArray = cell(numFF,1);

% generate new strings with the full subfolder directory
for iRow = 1:numFF;
    fullFileArray{iRow} = fullfile(foldsParent(iRow,:).folder,...
                                                 foldsParent(iRow,:).name);
end

% find how many files/folders exist within the current directory, if any
% eliminate '.' & '..' directories
% dataDir is the updated structure data from the fullFileArrays
foldCount = NaN(numFF,1); 
dataDir = cell(numFF,1); 
for iRow = 1:numFF;
    tempDir = dir(fullFileArray{iRow}); % get struct info for each file
    sizeRow = size(tempDir,1);
        if sizeRow >= 3; % eliminate '..' '.' directories if present
            tempDir([1:2],:) = [];
            foldCount(iRow,:) = size(tempDir,1); 
            dataDir{iRow} = tempDir;
        elseif sizeRow <= 2;
            foldCount(iRow,:) = size(tempDir,1); % record size of struct
            dataDir{iRow} = tempDir; % store data directory into memory
        end            
end

end
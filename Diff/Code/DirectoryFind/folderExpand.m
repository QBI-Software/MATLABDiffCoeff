function eFP = folderExpand(sFP,sDD)

if isempty(sFP) == 1
    eFP = [];
    return
end

% find total number of files & subdirecotires in the new direcotires list
for n = 1:size(sDD,1);
    tempData = sDD{n};
    sizeDir(n,:) = size(tempData,1);
end

% expand foldsParent to include all newly found subdirectories and files
% including any suitable .txt files foun earlier
numSubs = sum(sizeDir);
for numDir = 1:size(sFP,1);
    tempName = fullfile(sFP(numDir).folder,sFP(numDir).name);
    tempDir = dir(tempName); % get dir info
        if size(tempDir,1) > 2; % eliminate '..' & '.' directory info
            tempDir([1:2],:) = [];
        end
    for n = 1:size(tempDir,1);
        sFP(numDir,n) = tempDir(n,:); % generate a new cell array of all possible directories
    end
end
    
sFP = sFP(:); % reshape cell arrays into 1xn vector
for n = 1:size(sFP,1);
    dat(n,:) = isempty(sFP(n).name); % find any empty struct values
end

elimFold = find(dat); % find row value for empty structs
sFP(elimFold,:) = []; % remove empty struct values
eFP = sFP; % re-define expanded folds parent list
end
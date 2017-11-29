function [binMatTotal,logDiffMat,indicesArray,diffBinEdges,baseFileArray]...
                              = diffCoeff(foldersAnalyse,baseFND,numFiles);

% establish matrices & arrays to store data into for diffusion coefficient
logDA = cell(1,numFiles);
baseFileArray = cell(1,numFiles);
indicesArray = cell(1,numFiles);
    binMat = NaN(numFiles,61);
    diffBinEdges= -5.05:0.1:1.05;

h = waitbar(0,'Converting and binning diffusion coefficients');

% analyse each diffusion coefficient file, binning log coefficients 
for iFile = 1:numFiles;
        addpath(foldersAnalyse{iFile}); % establish path to folder
        fullFile = fullfile(foldersAnalyse{iFile},baseFND);
        tempStorage = dlmread(fullFile,' ',3,1); % import .txt file
        lengthDiff = size(tempStorage,1);
        
coeffArray{iFile} = num2cell(tempStorage); % store imported data into cell
baseFileArray{iFile} = baseFND;
    tempCoeffStorageArray = coeffArray([1:1],iFile);
    tempDiffStorageMatrix = tempCoeffStorageArray{1,1};
    % load out just the diffusion coefficient values from data
    tempDiffStorage = tempDiffStorageMatrix([1:lengthDiff],[3:3]);
        tempDiffStorageMat = cell2mat(tempDiffStorage); % transform to matrix

% find and remove any values which are less than 0.00001
indices = find(abs(tempDiffStorageMat)<=0.00001);
indicesArray{iFile} = find(abs(tempDiffStorageMat)<=0.00001);
    tempDiffStorageMat(indices) = []; % remove values
    lengthDiffThresh = length(tempDiffStorageMat);

% convert diffusion values to a log scale
logDiffStorageMat = log10(tempDiffStorageMat);
logDA{iFile} = log10(tempDiffStorageMat);
    % bin converted log values into categories between -5 and 1
    discretizedLogDiff = histcounts(logDiffStorageMat,diffBinEdges);
    binMat(iFile,:) = discretizedLogDiff;
    binMatTotal(iFile,:) = binMat(iFile,:)./lengthDiffThresh;
    
    waitbar(iFile./numFiles);
end
close(h);

% get the raw converted log data of the diffusion coefficients
sizeMat = NaN(numFiles,2);
for iCol = 1:numFiles;
sizeMat(iCol,:) = size(logDA{iCol});
end

maxLengthMat = max(sizeMat);
    maxLength = maxLengthMat([1:1],[1:1]);

logDiffMat = NaN(maxLength,numFiles);

% extract and store the log binned diffusion coefficients
for iCol = 1:numFiles;
    tempStorage = logDA{iCol};
    tempLength = length(tempStorage);
    padValue = maxLength - tempLength; % padding to keep vectors consistent
    padTempStorage = padarray(tempStorage,[padValue 0],NaN,'post');
    
logDiffMat(:,iCol) = padTempStorage;
end

end
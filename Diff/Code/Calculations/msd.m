function [firstTenMat,baseFileArrayMSD] = msd(foldersAnalyse,baseFNMSD,indicesArray,numFiles);

firstTenMat = NaN(numFiles,10);

h = waitbar(0,'Analysing Mean Square Difference Files');
% analyse MSD files, eliminating corresponding samples from diffusion coeff
for iFile = 1:numFiles;
    fullFile = fullfile(foldersAnalyse{iFile},baseFNMSD);
    tempStorage = dlmread(fullFile,' ',2,1); % import MSD data
    lengthTempStorage = length(tempStorage);
    tempStorageShort = tempStorage([1:lengthTempStorage],[3:12]);
% eliminate the files which were removed from the diffusion coeff analysis
[tempStorageLess,PS] = removerows(tempStorageShort,'ind',indicesArray{iFile});
tempStorageLess(tempStorageLess==0) = NaN; 
firstTenMat(iFile,:) = nanmean(tempStorageLess,1);
baseFileArrayMSD{iFile} = foldersAnalyse{iFile};

waitbar(iFile./numFiles);
end

    close(h);
baseFileArrayMSD = reshape(baseFileArrayMSD,[numFiles,1]);
end
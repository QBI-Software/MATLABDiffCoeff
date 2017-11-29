function [logDiffMat,baseFileArray,binnedDiffCoeff,baseFileArrayMSD,...
    MSD,binMatTotal,firstTenMat] = svFile(logDiffMat,baseFileArray,...
    binnedDiffCoeff,baseFileArrayMSD,MSD,binMatTotal,firstTenMat,...
                                                    fileSave,diffBinEdges);

% truncate all files to the selected folders for saving 
logDiffMat = logDiffMat(:,fileSave);
baseFileArray = baseFileArray(:,fileSave);
baseFileArrayMSD = baseFileArrayMSD(fileSave,:);
binMatTotal = binMatTotal(:,fileSave);
    binMatTotal = binMatTotal';
firstTenMat = firstTenMat(fileSave,:);
MSD = mean(firstTenMat);
numFiles = numel(fileSave);

% re-run statDiff to redefine binnedDiffCoeff for fewer files
[binnedDiffCoeff,binMatTotal] = statDiff(binMatTotal,numFiles,diffBinEdges);

end
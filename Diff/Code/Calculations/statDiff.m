function [binnedDiffCoeff,binMatTotal] = statDiff(binMatTotal,numFiles,diffBinEdges);

% generate matrix with the binned diffusion coefficients, bin value, n &
% SEM
if numFiles > 1
    meanBinMat = mean(binMatTotal,1);
    stdBinMat = std(binMatTotal,1);
    semBinMat = stdBinMat./sqrt(numFiles);
    semBinMat = semBinMat(:);
    meanBinMatReshape = meanBinMat(:);
        elseif numFiles <= 1;
            semBinMat = repelem(0,61);
            semBinMat = semBinMat(:);
            meanBinMatReshape = binMatTotal(:);
end

    binValues = diffBinEdges(:);
    binValues = binValues([1:61],[1:1]);
    nFiles = repelem(numFiles,61);
    nMSDFiles = repelem(numFiles,9);
    nFiles = nFiles(:);
    binMatTotal = binMatTotal.';
% concatenate all data
binnedDiffCoeff = [binValues meanBinMatReshape nFiles semBinMat]; 
end
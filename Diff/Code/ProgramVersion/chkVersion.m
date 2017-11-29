function chkVersion(allCodeDir,mainLoc);
% number of old files in the ProgramVersion folder should be 0

ProgramVersion = allCodeDir.ProgramVersion;
% check for any new directories
fileDir = dir(ProgramVersion);
    fileDir([1:2],:) = [];
for n = 1:size(fileDir,1);
    temp = fileDir(n,:).name;
newDirs{n} = strfind(temp,'.zip');
isEmpt(n,:) = isempty(newDirs{n});
end
elimRow = find(isEmpt);
newDirs = cell2mat(newDirs);
sumDirs = find(newDirs);

% prompt user to update the program, throw error if too many program
% versions found in folder
if sumDirs == 1;
  pgmUp = questdlg('A new version is available, do you want to update?',...
                       'New update detected',...
                        'Update','Cancel','Cancel');
% run different functions depending on answer                    
switch pgmUp;
    case 'Update' % run the update function if selected
        fileDir(elimRow,:) = []; % get struct info on .zip folder
        pgmUpdate(fileDir,allCodeDir,mainLoc);
        addpath('Code\Misc');
        pgmUptCode;
    case 'Cancel' % do nothing if selected
end
    
elseif sumDirs > 1;
    msgbox('Please remove old program version zip files');
end

end
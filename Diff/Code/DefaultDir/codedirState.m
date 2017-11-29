function allCodeDir = codedirState(matlabLoc)

% define all the MATLAB file directories
Calculations = fullfile(matlabLoc,'Code\Calculations');
DefaultDir = fullfile(matlabLoc,'Code\DefaultDir');
DirectoryFind = fullfile(matlabLoc,'Code\DirectoryFind');
Documentation = fullfile(matlabLoc,'Code\Documentation');
Formatting = fullfile(matlabLoc,'Code\Formatting');
Misc = fullfile(matlabLoc,'Code\Misc');
ProgramVersion = fullfile(matlabLoc,'Code\ProgramVersion');

% create structure with all the code folder names
f1 = 'Calculations';
f2 = 'DefaultDir';
f3 = 'DirectoryFind';
f4 = 'Documentation';
f5 = 'Formatting';
f6 = 'Misc';
f7 = 'ProgramVersion';

allCodeDir = struct(f1,Calculations,f2,DefaultDir,f3,DirectoryFind,...
    f4,Documentation,f5,Formatting,f6,Misc,f7,ProgramVersion);
end
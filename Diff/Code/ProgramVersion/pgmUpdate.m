function pgmUpdate(fileDir,allCodeDir,matlabLoc,mainLoc);

w = warning('off','all');

% delete old code files
rmdir Code\Calculations s;
    warning(w);
rmdir Code\DefaultDir s;
    warning(w);
rmdir Code\DirectoryFind s;
    warning(w);
rmdir Code\Documentation s;
    warning(w);
rmdir Code\Formatting s;
    warning(w);
rmdir Code\Misc s;
    warning(w);

delete('Diff.fig');
delete('Diff.m');

% unzip program update folder and delete .zip folder
fileUnzip = fullfile(fileDir.folder,fileDir.name);
unzip(fileUnzip,fileDir.folder);
delete(fileUnzip); % delete old .zip folder

% get content of the unzipped folder and distribute to folders

movefile(fullfile(allCodeDir.ProgramVersion,'Code\Calculations'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Code\DefaultDir'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Code\DirectoryFind'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Code\Documentation'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Code\Formatting'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Code\Misc'),...
                          matlabLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Diff.fig'),...
                               mainLoc);
movefile(fullfile(allCodeDir.ProgramVersion,'Diff.m'),...
                              mainLoc);
end
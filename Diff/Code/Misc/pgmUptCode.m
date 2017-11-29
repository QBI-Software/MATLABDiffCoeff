function pgmUptCode

% update and remove the old ProgramVersion folder
movefile('Code\ProgramVersion\Code\ProgramVersion','Code\Misc');
rmdir('Code\ProgramVersion\Code');
movefile('Code\Misc\ProgramVersion','Code');

msgbox('Please restart diff for changes to take effect','Update complete');
end
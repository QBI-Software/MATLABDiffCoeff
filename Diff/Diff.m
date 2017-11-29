function varargout = Diff(varargin)
% DIFF MATLAB code for Diff.fig
%      DIFF, by itself, creates a new DIFF or raises the existing
%      singleton*.
%
%      H = DIFF returns the handle to a new DIFF or the handle to
%      the existing singleton*.
%
%      DIFF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIFF.M with the given input arguments.
%
%      DIFF('Property','Value',...) creates a new DIFF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Diff_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Diff_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%
%
% ABOUT DIFF;
%--------------------------------------------------------------------------
% Diff was written for the Meunier lab, Queensland Brain Institute at the
% University of Queensland. It's not intended for commerical purposes.
%
% Diff allows a user to set a parent folder consisting of analysed single
% particle tracking (SPT) diffusion coefficient and mean square distance
% data to automatically filter out inappropriate data from both data sets.
%
% Diff also puts all log diffusion coefficient values into a bin from
% between -5 and 1 in 0.1 increments in order to derive AUC for mobile and
% immobile fractions.
%
% All data from Diff can be exported to the user's directory of choice into
% an excel spreadsheet for convenience.
%
% Diff was written by Adam Hines, van Swinderen lab Queensland Brain
% Institute at the University of Queensland in 2017.
%
% Version no. 1.1 - 14/11/2017.
% Refer to 'ProgramVersions.xlsx' for list of features and updates, file is
% located in the ProgramVersion folder in the MATLAB directory.

% Last Modified by GUIDE v2.5 27-Nov-2017 11:58:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Diff_OpeningFcn, ...
                   'gui_OutputFcn',  @Diff_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Diff is made visible.
function Diff_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Diff (see VARARGIN)

% Choose default command line output for Diff
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Diff wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Diff_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
load('Code\DefaultDir\FolderLoc\defaultdir.mat');
curDir = cd;
addpath(fullfile([cd '\Code'],'DefaultDir'));

% if the initial code directories do not exist, run a setup for directories
if strcmp(curDir,mainLoc) == 0
    newSt = questdlg('Diff installed, would you like to set up your directories now?',...
        'Installer','Install','Cancel','Cancel');
    switch newSt
        case 'Install'
            defaultDir;
            return
        case 'Cancel'
            return
    end
end

allCodeDir = codedirState(mainLoc);
addpath(allCodeDir.ProgramVersion);
chkVersion(allCodeDir,mainLoc);

handles.fileLoc = fileLoc;
handles.mainLoc = mainLoc;
handles.opFile = opFile;
handles.allCodeDir = allCodeDir;
    guidata(hObject,handles);

%--------------------------------------------------------------------------
%--------------------GUIDE buttons-----------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%-------------FILES DIRECTORY FUNCTION--------------------------------------
%--------------------------------------------------------------------------

function filedir_Callback(hObject, eventdata, handles)
% hObject    handle to filedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileLoc = handles.fileLoc;
mainLoc = handles.mainLoc;
allCodeDir = handles.allCodeDir;

addpath(allCodeDir.DirectoryFind);

allDataFound = 0;
handles.listbox1.Value = 1;

% declare starting directory to search files, throwing error if no
% directory exsists
startingFolder = fileLoc;
if ~isdir(startingFolder);
    errorMessage = sprintf('Error: The starting directory does not exist');
    uiwait(warndlg(errorMessage));
    return
end

% parent folder to search for files defined as selected folder
ParentFolderName = uigetdir(startingFolder,...
                         'Please select location of the parent directory');
  if isequal(ParentFolderName,0)
      return
  end
  
set(handles.listbox1,'String','');
set(handles.edit9,'String','');
set(handles.FileDirectory,'String','')

[foldsParent,checkDir,numSubs] = checkDirectory(ParentFolderName);

% determine if data is in the parent folder or not, search for data if not
if checkDir < numSubs;
    h = waitbar(0.5,'Please wait...searching directories...');
    while (allDataFound < 1) == 1;
        [uFP,allDataFound] = findFolds(foldsParent);
        foldsParent = []; % clear foldsParent dir
        foldsParent = uFP; % update foldsParent struct
    end
    waitbar(1,h,'Done!');
end    
   delete(h)
% count number of files located, throw warning if odd number found
countFiles = numel(foldsParent);
checkNumFile = mod(countFiles,2);
    if checkNumFile == 1;
        error('Uneven number of files found - check folders for extra files')
        return
    end

if isempty(foldsParent) == 1
    return
end

% get all folder names
for n = 1:size(foldsParent);
    folderCell{n} = foldsParent(n,:).folder;
end

% establish truncated forms of the folder names to display
uniqueFolders = unique(folderCell);
for iRow = 1:size(uniqueFolders,2);
    temp = uniqueFolders{iRow};
    [~,trunc{iRow},~] = fileparts(temp);
end

set(handles.listbox1,'String',trunc);
set(handles.edit9,'String',countFiles);
set(handles.FileDirectory,'String',fullfile(ParentFolderName));  
handles.startingFolder = startingFolder;
handles.foldsParent = foldsParent;
    guidata(hObject,handles);
  
%--------------------------------------------------------------------------
%------------------RUN FUNCTION--------------------------------------------
%--------------------------------------------------------------------------

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(get(handles.listbox1,'String'))
    msgbox('Please select some files for analysis');
    return
end


handles.HistoBinDiff.Value = 1; % reset listbox parameters
handles.MSDPlots.Value = 1; % reset listbox parameters
handles.listbox2.Value = 1;
allCodeDir = handles.allCodeDir;
set(handles.HistoBinnedDiff,'value',1);
set(handles.MSDplots,'value',1);
    addpath(allCodeDir.Formatting);

% redefine calculated variables
foldsParent = handles.foldsParent;
fileLoc = get(handles.listbox1,'Value');

% define basefile names to search for in selected folders
baseFND = 'AllROI-D.txt';
baseFNMSD = 'AllROI-MSD.txt';

% choose the selected folders to analyse
[foldersAnalyse,numFiles] = slctFolders(foldsParent,fileLoc);

addpath(allCodeDir.Calculations);
% analyse the diffusion coefficient files
[binMatTotal,logDiffMat,indicesArray,diffBinEdges,baseFileArray]... 
                              = diffCoeff(foldersAnalyse,baseFND,numFiles);
                          
% find the mobile and immobile fraction of the fractional diffusion
% coefficients
for n=1:size(binMatTotal,1);
    immobile = binMatTotal(n,[1:34]); mobile = binMatTotal(n,[35:61]);
    immobSum(:,n) = sum(immobile); mobSum(:,n) = sum(mobile);
end

% set summary values for immobile and mobile sum fractions
set(handles.Immobile,'String',immobSum(:,1));
set(handles.Mobile,'String',mobSum(:,1));

% analyse the mean square distance files
[firstTenMat,baseFileArrayMSD] = msd...
                          (foldersAnalyse,baseFNMSD,indicesArray,numFiles);
                      
% find the AUC for the MSD data points
for n = 1:size(firstTenMat,1);
    aucMSD(:,n) = trapz(firstTenMat(n,:));
end

% set summary data for AUC MSD
set(handles.AUC,'String',aucMSD(:,1));

% truncate the folder name
for n = 1:size(foldersAnalyse,1);
    stringTxt = foldersAnalyse{n};
    [~,foldName{n},~] = fileparts(stringTxt);
end

% update listboxes with the analysed folders
set(handles.HistoBinnedDiff,'String',foldName);
set(handles.MSDplots,'String',foldName);

% mean MSD data
MSD = mean(firstTenMat);
stdMSD = std(firstTenMat,1);
SEMMSD = stdMSD./sqrt(numFiles);
    plot(handles.axes3,firstTenMat(1,:),'ko');

% update axes in GUI to show the binning distribution
histogram(handles.BinnedDiffCoeff,logDiffMat,diffBinEdges);

% run stats, concatenate data, misc formatting
[binnedDiffCoeff,binMatTotal] = statDiff(binMatTotal,numFiles,diffBinEdges);

% update data structures in GUI
set(handles.TotalBinDiffCoeff,'Data',binnedDiffCoeff);   
contentsHistoDiff = get(handles.HistoBinnedDiff,'String');
set(handles.listbox2,'String',foldersAnalyse);
    
% set handles for data saving
handles.binMatTotal = binMatTotal;
handles.binnedDiffCoeff = binnedDiffCoeff;
handles.MSD = MSD;
handles.numFiles = numFiles;
handles.logDiffMat = logDiffMat;
handles.firstTenMat = firstTenMat;
handles.SEMMSD = SEMMSD;
handles.baseFileArray = baseFileArray;
handles.baseFileArrayMSD = baseFileArrayMSD;
handles.conentsHistoDiff = contentsHistoDiff;
handles.diffBinEdges = diffBinEdges;
handles.immobSum = immobSum;
handles.mobSum = mobSum;
handles.aucMSD = aucMSD;
handles.foldName = foldName;
    guidata(hObject,handles);

%--------------------------------------------------------------------------
%------------SAVE FILE CODE------------------------------------------------
%--------------------------------------------------------------------------

% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allCodeDir = handles.allCodeDir;
fileSave = get(handles.listbox2,'Value');

% define handles and output parameters
sheet1 = 1;
sheet2 = 2;
sheet3 = 3;
    binMatTotal = handles.binMatTotal;
    binnedDiffCoeff = handles.binnedDiffCoeff;
    MSD = handles.MSD;
    numFiles = handles.numFiles;
    logDiffMat = handles.logDiffMat;
    startingFolder = handles.startingFolder;
    firstTenMat = handles.firstTenMat;
    SEMMSD = handles.SEMMSD;
    baseFileArray = handles.baseFileArray;
    baseFileArrayMSD = handles.baseFileArrayMSD;
    diffBinEdges = -5:0.1:1;
    immobSum = handles.immobSum;
    mobSum = handles.mobSum;
    aucMSD = handles.aucMSD; aucMSD = aucMSD';
    foldName = handles.foldName;
    foldNameMSD = foldName';
    

% search for and set the save directory
[FileName,PathName] = uiputfile('Analysed Data.xlsx');
    saveFile = fullfile(PathName,FileName);
if FileName == 0;
    return;
end

addpath(allCodeDir.Formatting);
h = waitbar(0,'Saving beginning...');
%----OUTPUT DATA-----------------------------------------------------------
% re-define variables to only save selected files, if fewer files selected
% re-run statDiff to re-define binnedDiffCoeff & MSD
waitbar(0.1,h,'Checking output files...');
if numFiles > numel(fileSave);
[logDiffMat,baseFileArray,binnedDiffCoeff,baseFileArrayMSD,...
    MSD,binMatTotal,firstTenMat] = svFile(logDiffMat,baseFileArray,...
             binnedDiffCoeff,baseFileArrayMSD,MSD,binMatTotal,...
                                        firstTenMat,fileSave,diffBinEdges);
end

waitbar(0.2,h);

% suppress 'new sheet added' warning
warning('off','MATLAB:xlswrite:AddSheet');

waitbar(0.3,h,'Writing files...');
% Log Diff Coefficient
logDiffText = 'Log10 Diffusion Coefficients';,logDiffRange = 'A5';
logDiffTextRange = 'A3';
    xlswrite(saveFile,logDiffMat,sheet1,logDiffRange);
    xlswrite(saveFile,{logDiffText},sheet1,logDiffTextRange);

waitbar(0.4,h);
% Binned Diff Coefficients
binDiffText = 'Binned Diffusion Coefficients';,binDiffRange = 'AA5';
binDiffTextRange = 'AA3';
fileNameRange = 'AA4';
immobTxt = 'Immobile'; mobTxt = 'Mobile';
immobTxtRng = 'Z67'; mobTxtRng = 'Z68';
immobRng = 'AA67'; mobRng = 'AA68';
waitbar(0.5,h);
    xlswrite(saveFile,foldName,sheet1,fileNameRange);
    xlswrite(saveFile,binMatTotal,sheet1,binDiffRange);
    xlswrite(saveFile,{binDiffText},sheet1,binDiffTextRange);
    xlswrite(saveFile,{immobTxt},sheet1,immobTxtRng);
    xlswrite(saveFile,{mobTxt},sheet1,mobTxtRng);
    xlswrite(saveFile,immobSum,sheet1,immobRng);
    xlswrite(saveFile,mobSum,sheet1,mobRng);
    
waitbar(0.6,h);    
% Mean Binned Diff Coefficients and SEM
binNumText = 'Bin no.';,binNumRange = 'BB3';
meanText = 'Mean';,meanRange = 'BC3';
numText = 'Number';,numRange = 'BD3';
SEMText = 'SEM';,SEMRange = 'BE3';
binnedDiffCoeffRange = 'BB5';
waitbar(0.7,h);
    xlswrite(saveFile,binnedDiffCoeff,sheet1,binnedDiffCoeffRange);
    xlswrite(saveFile,{binNumText},sheet1,binNumRange);
    xlswrite(saveFile,{meanText},sheet1,meanRange);
    xlswrite(saveFile,{numText},sheet1,numRange);
    xlswrite(saveFile,{SEMText},sheet1,SEMRange);

waitbar(0.8,h,'Finishing...');

% MSD
firstTenText = 'MSD';,firstTenTextRange = 'C3';
firstTenRange = 'D5';
cellFileText = 'File names';,cellFileRange = 'C4';
baseFileMSDRange = 'C5';
aucTxt = 'Area under the curve'; aucTxtRng = 'O4';
aucRng = 'O5';
    xlswrite(saveFile,foldNameMSD,sheet2,baseFileMSDRange);
    xlswrite(saveFile,{cellFileText},sheet2,cellFileRange);
    xlswrite(saveFile,firstTenMat,sheet2,firstTenRange);
    xlswrite(saveFile,{firstTenText},sheet2,firstTenTextRange);
    xlswrite(saveFile,{aucTxt},sheet2,aucTxtRng);
    xlswrite(saveFile,aucMSD,sheet2,aucRng);
    
waitbar(0.9,h);
MSDText = 'Mean';,MSDTextRange = 'C30';
MSDRange = 'D30';
numMSDText = 'Number of files';,numMSDTextRange = 'C31';
semMSDText = 'SEM';,semMSDTextRange = 'C32';
semRange = 'D31';
numRange = 'D32';
waitbar(1,h,'Done!');
    xlswrite(saveFile,{numMSDText},sheet2,numMSDTextRange);
    xlswrite(saveFile,{semMSDText},sheet2,semMSDTextRange);
    xlswrite(saveFile,MSD,sheet2,MSDRange);
    xlswrite(saveFile,{MSDText},sheet2,MSDTextRange);
    xlswrite(saveFile,SEMMSD,sheet2,semRange);
    xlswrite(saveFile,numFiles,sheet2,numRange);
delete(h);
%--------------------------------------------------------------------------
%--------------------GUIDE EDIT BOXES & OTHER PANELS-----------------------
%--------------------------------------------------------------------------

function FileDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to FileDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FileDirectory as text
%        str2double(get(hObject,'String')) returns contents of FileDirectory as a double


% --- Executes during object creation, after setting all properties.
function FileDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in StimBox.
function StimBox_Callback(hObject, eventdata, handles)
% hObject    handle to StimBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StimBox

function MSDLocation_Callback(hObject, eventdata, handles)
% hObject    handle to MSDLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSDLocation as text
%        str2double(get(hObject,'String')) returns contents of MSDLocation as a double


% --- Executes during object creation, after setting all properties.
function MSDLocation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSDLocation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in HistoBinnedDiff.
function HistoBinnedDiff_Callback(hObject, eventdata, handles)
% hObject    handle to HistoBinnedDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns HistoBinnedDiff contents as cell array
%        contents{get(hObject,'Value')} returns selected item from HistoBinnedDiff
logDiffMat = handles.logDiffMat;
diffBinEdges = handles.diffBinEdges;
immobSum = handles.immobSum;
mobSum = handles.mobSum;
contents = cellstr(get(hObject,'String'));
    axesSet = contents{get(hObject,'Value')};
    locAxesSet = find(ismember(contents,axesSet));
    histoLogDiffMat = logDiffMat(:,[locAxesSet:locAxesSet]);
    set(handles.Immobile,'String',immobSum(:,[locAxesSet:locAxesSet]));
    set(handles.Mobile,'String',mobSum(:,[locAxesSet:locAxesSet]));
    
histogram(handles.BinnedDiffCoeff,histoLogDiffMat,diffBinEdges);

% --- Executes during object creation, after setting all properties.
function HistoBinnedDiff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HistoBinnedDiff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in MSDplots.
function MSDplots_Callback(hObject, eventdata, handles)
% hObject    handle to MSDplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MSDplots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MSDplots
firstTenMat = handles.firstTenMat;
aucMSD = handles.aucMSD;
    contentsMSD = cellstr(get(hObject,'String'));
    MSDplot = contentsMSD{get(hObject,'Value')};
    plotValue = find(ismember(contentsMSD,MSDplot));
    firstTenMatPlot = firstTenMat([plotValue:plotValue],[1:10]);
    firstTenMatPlot = firstTenMatPlot(:);
    set(handles.AUC,'String',aucMSD(:,[plotValue:plotValue]));
   
plot(handles.axes3,firstTenMatPlot,'ko');

% --- Executes during object creation, after setting all properties.
function MSDplots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSDplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------

function defaultdir_Callback(hObject, eventdata, handles)
% hObject    handle to defaultdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curDir = cd;
addpath(fullfile([curDir '\Code\DefaultDir']));
defaultDir



function Immobile_Callback(hObject, eventdata, handles)
% hObject    handle to Immobile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Immobile as text
%        str2double(get(hObject,'String')) returns contents of Immobile as a double


% --- Executes during object creation, after setting all properties.
function Immobile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Immobile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Mobile_Callback(hObject, eventdata, handles)
% hObject    handle to Mobile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Mobile as text
%        str2double(get(hObject,'String')) returns contents of Mobile as a double


% --- Executes during object creation, after setting all properties.
function Mobile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mobile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AUC_Callback(hObject, eventdata, handles)
% hObject    handle to AUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AUC as text
%        str2double(get(hObject,'String')) returns contents of AUC as a double


% --- Executes during object creation, after setting all properties.
function AUC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function DataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ClearData_Callback(hObject, eventdata, handles)
% hObject    handle to ClearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.FileDirectory,'String',[]);
set(handles.listbox1,'value',1);
set(handles.listbox1,'String','Folders...');
set(handles.listbox2,'value',1);
set(handles.listbox2,'String','Select files to output...'); 
set(handles.TotalBinDiffCoeff,'Data',[]); 
set(handles.HistoBinnedDiff,'value',1);
set(handles.HistoBinnedDiff,'String','Select histogram...');
set(handles.MSDplots,'value',1);
set(handles.MSDplots,'String','Select plot...');
set(handles.Immobile,'String',[]);
set(handles.Mobile,'String',[]);
set(handles.AUC,'String',[]);
cla(handles.BinnedDiffCoeff);
cla(handles.axes3);
set(handles.edit9,'String',[]);
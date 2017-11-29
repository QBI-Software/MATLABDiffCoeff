# MATLABDiffCoeff
MATLAB software to analyse diffusion coefficients and mean square displacement (Meunier)

MATLABDiffCoeff is a GUI based software operatable within versions of MATLAB 2016b and higher, it is recommended however that you install version 2016b to avoid issues involving removed or altered functions within MATLAB.

---INITIAL SETUP----
Installing Diff is easy, download the Diff folder and place it somewhere easily accessible (e.g. \Documents\MATLAB\Diff) and change the current folder in MATLAB to the directory containing Diff. Once the current folder is set, two files should be visible (Diff.m & Diff.fig) alongside a variety of folders in the 'Folders' panel in MATLAB. DO NOT click on Diff.m or Diff.fig to run Diff, instead in the command window simply type 'Diff' (without ' ') and the software will open.

Once opened, open the 'File' menu in the top left-hand corner and set your default directories. You must select the default directory for the location of the MATLAB code (e.g. \Documents\MATLAB\Diff). You do not need to specify specific folders, just the main Diff directory. You may also choose a default directory location for the files you wish to import and the export location. Once this is done, restart Diff and your new directories will be automatically imported.

---RUNNING ANALYSIS----
To calculate the diffusion coefficients and mean square displacement, click the 'File' menu and  select 'File directory'. A dialog box will open and you will select the location of your files. The folder selection can be a parent folder in which you organise your files into (e.g. a date, condition or experiment type) and Diff will automatically search through your directories for 'AllROI.txt' and 'AllMSD.txt'. NOTE that if these files are missing, Diff will prompt you that no files were able to be located.

Once files are loaded, a listbox will appear with all located file directories. Select which experiments you wish to analyse and hit 'Run calculations'. A waitbar will appear and the software will convert diffusion coefficients into a log scale and bin them between -5 and 1 as well as calculate the first 10 frames of the mean square displacement.

Summary data will appear on the screen and you can select files to view within the software. Histograms and plots will automatically update themselves with the selected files.

---OUTPUTTING ANALYSIS----
In order to output the analysis files, you will need to select which files for output you wish to save to an excel spreadsheet. By utilising the graphical summaries given within Diff, you are able to select certain files for output whilst leaving others from being output into your final data sheet.

Select the files and hit 'Save'. A dialog box will prompt you to select the folder you wish to output your data to. By default, the excel spreadsheet is titled "Analysed Data".

Within the excel spreadsheet, your data is organised the following way. Sheet1 contains the raw diffusion coefficients, binned log diffusion coefficients as well as the average, number, standard deviation and standard error of the mean. Sheet2 contains the first 10 data points of the mean square displacement from each cell with the average, number, standard deviation and standard error of the mean at the bottom.

---OTHER FUNCTIONS----
CLEARING DATA - To clear all data from the main GUI, simply go to the 'Data' menu and click 'Clear all data...'. Alterantively, you can also click CTRL+D.

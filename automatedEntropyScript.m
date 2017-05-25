%% automatic entropy from color and FSC/SSC data

[fileNames,path] = uigetfile('E:\zon_lab\FACS\*.fcs','Multiselect','On');

if iscell(fileNames) == 1
    numFiles = numel(fileNames);
else
    numFiles = 1;
    fileNames = {fileNames};
end

entropy = cell(numFiles,1);
score = cell(numFiles,1);

for kk = 1:numFiles
    [entropy{kk}, score{kk}] = autoEntropy(fullfile(path,fileNames{kk}),3);
end
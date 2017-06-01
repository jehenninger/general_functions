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
stdEntropy = cell(numFiles,1);
giniCoeff = cell(numFiles,1);
stdGiniCoeff = cell(numFiles,1);
rho = cell(numFiles,1);
sampleName = cell(numFiles,1);

multiWaitbar('analyzing files...',0);
for kk = 1:numFiles
    [entropy{kk}, stdEntropy{kk}, giniCoeff{kk}, stdGiniCoeff{kk}, rho{kk}, sampleName{kk}, score{kk}] = autoEntropy(fullfile(path,fileNames{kk}),3);
    multiWaitbar('analyzing files...', kk./numFiles);
end

multiWaitbar('CloseAll');


gini = [giniCoeff{:}]';

recombination = normalize_var(recomb,0,1);

modGini = gini.*recombination;

figure, hGiniRecomb = scatter(recomb,gini,50,'filled');
title('Recombation vs. Gini Coeff');

figure, hGini = stem(1:numFiles,gini);
title('Gini Coefficient');
xticks(1:numFiles);
xticklabels(sampleName);
xtickangle(45);
xlim([0, (numFiles + 1)]);
ylim([0 1]);

figure, hModGini = stem(1:numFiles, modGini);
title('Modified Gini');
xticks(1:numFiles);
xticklabels(sampleName);
xtickangle(45);
xlim([0, (numFiles + 1)]);
ylim([0,1]);
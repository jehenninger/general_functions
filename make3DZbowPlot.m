function [h] = make3DZbowPlot()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[fileNames,path] = uigetfile('E:\zon_lab\FACS\*.fcs','Multiselect','On');

if iscell(fileNames) == 1
    numFiles = numel(fileNames);
else
    numFiles = 1;
    fileNames = {fileNames};
end

h = cell(numFiles,1);

multiWaitbar('generating plots...',0);
for kk = 1:numFiles
    file = fullfile(path,fileNames{kk});
    [data,~,sampleName] = flowTransform(file);
    
    sampleName = strrep(sampleName,'_',' ');
    [cellColor,~,~,idx] = flowTransformCustom(file);
    
    cellColor = cellColor(:,idx);
    
    [sample, sampleIdx] = datasample(data,5000);
    cellColorSample = cellColor(sampleIdx,:);
    
    [rho, ~,~] = deltarho(sample, 1, 1);
    
    rho(rho>2) = 100*log2(rho(rho>2));
    
    
    figure,
    h{kk} = scatter3(sample(:,idx(1)),sample(:,idx(2)),sample(:,idx(3)), rho,cellColorSample,'filled');
    view(135,50);
    
    title(sampleName);
    drawnow;
    
    multiWaitbar('generating plots...',kk/numFiles);
end
multiWaitbar('CloseAll');

end


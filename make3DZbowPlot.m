function [h] = make3DZbowPlot(sampleSize, minMarkerSize, maxMarkerSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[fileNames,path] = uigetfile('E:\zon_lab\FACS\*.fcs','Multiselect','On');

if ~exist('sampleSize','var')
    sampleSize = 20000;
end

if ~exist('minMarkerSize','var')
    minMarkerSize = 15;
end

if ~exist('maxMarkerSize','var')
    maxMarkerSize = 1000;
end

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
    data(:,1) = normalize_var(data(:,1),0,1);
    data(:,2) = normalize_var(data(:,2),0,1);
    data(:,3) = normalize_var(data(:,3),0,1);
    
    
    sampleName = strrep(sampleName,'_',' ');
    [cellColor,~,~,idx] = flowTransformCustom(file);
    
    cellColor = cellColor(:,idx);
    cellColor = normalize_var(cellColor,0,1);
    
    if sampleSize < size(data,1)
        [sample, sampleIdx] = datasample(cellColor,sampleSize,'Replace', false);
        cellColorSample = cellColor(sampleIdx,:);
        x = data(sampleIdx, idx(1));
        y = data(sampleIdx, idx(2));
        z = data(sampleIdx, idx(3));
    else
        sample = cellColor;
        cellColorSample = cellColor;
        x = data(:,idx(1));
        y = data(:,idx(2));
        z = data(:,idx(3));
    end
    
    [rho, ~,~] = deltarho([x,y,z], 1, 1);
    
    %         rho = normalize_var(rho,15,1000);
    
    rho(rho<minMarkerSize) = minMarkerSize;
    %         rho(rho>maxMarkerSize) = maxMarkerSize;
    %
    %     rho(rho<minMarkerSize) = minMarkerSize;
    %     scaleFactor = minMarkerSize/(log2(minMarkerSize));
    %     rho(rho>minMarkerSize) = scaleFactor.*log2(rho(rho>minMarkerSize));
    
%     markerSize = rho;
            markerSize = 8;
    
    f = figure('Units','normalized','Position',[0.5 0 0.5 1]);
%     h{kk} = scatter3(x,y,z, markerSize,normalize_var(cellColorSample,0,1),'filled','MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
    h{kk} = scatter3(x, y, z, markerSize, cellColorSample,'filled');
    axis('equal');
    view(125,25);
    
    title(sampleName);
    drawnow;
    
    multiWaitbar('generating plots...',kk/numFiles);
end
multiWaitbar('CloseAll');

end


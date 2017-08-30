function [h, wOutput,file] = make3DZbowPlot(fileInput,sampleSize, markerSize, alpha,w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~exist('fileInput','var') || isempty(fileInput)
    error('Could not find or load file...');
end

if ~exist('sampleSize','var')|| isempty(sampleSize)
    sampleSize = 20000;
end

if ~exist('markerSize','var') || isempty(markerSize)
    markerSize = 15;
end

if ~exist('alpha','var') || isempty(alpha)
    alpha = 1;
end

file = fileInput;
if ~exist('w','var') || isempty(w)
    [data,~,sampleName,~,wOutput] = flowTransformCustom(file,'auto','auto','auto');
else
    %NOTE: w is vector of RGB w values in order
    [data,~,sampleName,~,wOutput] = flowTransformCustom(file,w(1),w(2),w(3)); %1.4 works very well for red here
end
for jj = 1:size(data,2)
    data(:,jj) = normalize_var(data(:,jj),0,1);
end


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

%     [rho, ~,~] = deltarho([x,y,z], 1, 1);
%
%     %         rho = normalize_var(rho,15,1000);
%
%     rho(rho<minMarkerSize) = minMarkerSize;
%         rho(rho>maxMarkerSize) = maxMarkerSize;
%
%     rho(rho<minMarkerSize) = minMarkerSize;
%     scaleFactor = minMarkerSize/(log2(minMarkerSize));
%     rho(rho>minMarkerSize) = scaleFactor.*log2(rho(rho>minMarkerSize));

%     markerSize = rho;

%     f = figure('Units','normalized','Position',[0.5 0 0.5 1]);
%     h{kk} = scatter3(x,y,z, markerSize,normalize_var(cellColorSample,0,1),'filled','MarkerFaceAlpha',1,'MarkerEdgeAlpha',1);
h = scatter3(x, y, z, markerSize, cellColorSample,'filled','MarkerFaceAlpha',alpha);
axis('equal');
view(125,25);

title(sampleName);
drawnow;

end


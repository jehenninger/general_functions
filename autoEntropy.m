function [entropy,score] = autoEntropy(file,kernel)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


[data, parameters, sampleName] = flowTransform(file);

data = datasample(data,50000,'Replace',false);

dataFSC = data(:,find(~cellfun(@isempty,regexp(parameters,'FSC-A'))));
dataSSC = data(:,find(~cellfun(@isempty,regexp(parameters,'SSC-A'))));
dataRed = data(:,find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*PE|(?=Comp).*Red)'))));
dataGreen = data(:,find(~cellfun(@isempty,regexp(parameters,'(?=Comp).*FITC'))));
dataBlue = data(:,find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*CFP|(?=Comp).*DAPI)'))));

combinedData = [dataFSC, dataSSC, dataRed, dataGreen, dataBlue];

[coeff, score] = pca(combinedData);

figure, scatter3(score(:,1),score(:,2),score(:,3),10,[dataRed, dataGreen, dataBlue],'filled');
title(sampleName);
drawnow;

% nBins = round(sqrt(size(data,1)));
nBins = 32;

[count edges mid loc] = histcn(combinedData,nBins,nBins,nBins,nBins,nBins);

if ~exist('kernel','var')
    kernel = 1:30;
end

movingSum = zeros((nBins+1)^5,1);
entropy = zeros(1,length(kernel));

for jj = 1:length(kernel)
    movingSum(:,jj) = reshape(movsum(count,kernel(jj)),(nBins+1)^5,1);
    movingSum(:,jj) = myNorm(movingSum(:,jj));
    entropy(:,jj) = shannon_entro(movingSum(movingSum(:,jj)>0,jj));
    
end

% figure, scatter(kernel, entropy, 50, 'filled');
% title(sampleName);

end


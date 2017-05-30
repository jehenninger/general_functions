function [meanEntropy,stdEntropy, meanGiniCoeff, stdGiniCoeff, rho, sampleName, score] = autoEntropy(file,kernel,pcaScatterPlot,entropyPlot)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


[data, parameters, sampleName] = flowTransform(file);

sampleName = strrep(sampleName,'_',' ');

dataFSC = data(:,find(~cellfun(@isempty,regexp(parameters,'FSC-A'))));
dataSSC = data(:,find(~cellfun(@isempty,regexp(parameters,'SSC-A'))));
dataRed = data(:,find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*PE|(?=Comp).*Red)'))));
dataGreen = data(:,find(~cellfun(@isempty,regexp(parameters,'(?=Comp).*FITC'))));
dataBlue = data(:,find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*CFP|(?=Comp).*DAPI)'))));

combinedData = [dataFSC, dataSSC, dataRed, dataGreen, dataBlue];


if exist('pcaScatterPlot','var')
    if pcaScatterPlot == 1
        [~, score] = pca(combinedData);
        
        figure, scatter3(score(:,1),score(:,2),score(:,3),10,[dataRed, dataGreen, dataBlue],'filled');
        title([sampleName, 'PCA scatter plot']);
        drawnow;
    else
        score = NaN;
    end
else
    score = NaN;
end

%% Rho method
nRep = 10;
repEntropy = zeros(nRep,1);
repGiniCoeff = zeros(nRep,1);
sampleSize = 5000;

if size(combinedData,1) > sampleSize
    for jj = 1:nRep %number of times to repeat
        
        sample = datasample(combinedData,sampleSize,'Replace',false);
        [rho, ~, ~] = deltarho(sample, 1, 1); %get Rho for subset of data
        repEntropy(jj) = shannon_entro(rho);
        repGiniCoeff(jj) = ginicoeff(rho);
    end
    meanEntropy = mean(repEntropy);
    stdEntropy = std(meanEntropy);
    
    meanGiniCoeff = mean(repGiniCoeff);
    stdGiniCoeff = std(repGiniCoeff);
else
    [rho, ~, ~] = deltarho(combinedData, 1, 1); %get Rho for subset of data
    
    meanEntropy = shannon_entro(rho);
    stdEntropy = NaN;
    
    meanGiniCoeff = ginicoeff(rho);
    stdGiniCoeff = NaN;
end




%% Kernel and moving sum method (may not be working as I intended!)
% % nBins = round(sqrt(size(data,1)));
% nBins = 32;
%
% [count edges mid loc] = histcn(combinedData,nBins,nBins,nBins,nBins,nBins);
%
% if ~exist('kernel','var')
%     kernel = 1:30;
% end
%
% movingSum = zeros((nBins+1)^5,1);
% entropy = zeros(1,length(kernel));
%
%
% for jj = 1:length(kernel)
%     movingSum(:,jj) = reshape(movsum(count,kernel(jj)),(nBins+1)^5,1);
%     movingSum(:,jj) = myNorm(movingSum(:,jj));
%     entropy(:,jj) = shannon_entro(movingSum(movingSum(:,jj)>0,jj));
%
% end
% if exist('entropyPlot','var')
%     if entropyPlot == 1
%         figure, scatter(kernel, entropy, 50, 'filled');
%         title([sampleName, ' entropy plot']);
%     end
% end

end


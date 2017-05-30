function [transformData,parameters,sampleName,idx] = flowTransformCustom(file)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if ~exist('file','var') || isempty(file)
    [file,path] = uigetfile('E:\zon_lab\FACS\*.fcs');
    file = fullfile(path,file);
end

[~,sampleName,~] = fileparts(file);
[data, header] = fca_readfcs(file);

if data == 0
    error('Could not read .fcs file or it contains empty data');
else
    parameters = {header.par.name};
    numOfPars = numel(parameters);
    

    redIdx = find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*PE|(?=Comp).*Red)')));
    greenIdx = find(~cellfun(@isempty,regexp(parameters,'(?=Comp).*FITC')));
    blueIdx = find(~cellfun(@isempty,regexp(parameters,'((?=Comp).*CFP|(?=Comp).*DAPI)')));
    idx = [redIdx,greenIdx,blueIdx];
    
    T = 2^18;
    M = 5;
    A = 0;
    
    % Auto width parameters
    w = zeros(numOfPars,1);
    for kk = 1:numOfPars
        
        w(kk) = (M - log10(T/abs(min(data(:,kk)))))/2;
        if w(kk) < 0
            w(kk) = 0;
        end
        
        if kk == redIdx
            w(kk) = 1.25;
        end
        
        if kk == greenIdx
            w(kk) = 1.5;
        end
        
        if kk == blueIdx
            w(kk) = 1.5;
        end
    end
    
    transformData = zeros(size(data));
    for ii = 1:numOfPars
        transformData(:,ii) = logicleTransform(data(:,ii), T, w(ii), M, A);
    end
    
    
end

end


function [transformData,parameters,sampleName] = flowTransform(file)
%flowTransform will take a fcs file and do the logicle transform
%   file is the full path of the .fcs file to transform
%   TO ADD: type is the type of transform ('default' or 'custom'). Custom requires
%   input of the (T,W,M,A) paramaters
% NOTE: May want to add a 'color' output with zbow specific parameters for
% display purposes

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

    T = 2^18;
    M = 4.5;
    A = 0;
    
    % Auto width parameters
    w = zeros(numOfPars,1);
    for kk = 1:numOfPars
        w(kk) = (M - log10(T/abs(min(data(:,kk)))))/2;
        if w(kk) < 0
            w(kk) = 0;
        end
    end
    
    transformData = zeros(size(data));
    for ii = 1:numOfPars
        transformData(:,ii) = logicleTransform(data(:,ii), T, w(ii), M, A);
    end
    
    
end

end


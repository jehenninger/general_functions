function fileList = getAllFiles(dirName, fileType)

if nargin == 2
    dirData = dir(fullfile(dirName,fileType));
else
    dirData = dir(dirName);      %# Get the data for the current directory
end

dirIndex = [dirData.isdir];  %# Find the index for directories
fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
        fileList,'UniformOutput',false);
end

end
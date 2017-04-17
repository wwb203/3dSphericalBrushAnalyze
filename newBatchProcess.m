clear;
durationFolder = {'30min'};%,'1H','2H','4H','8H'};
%durationFolder = {'0H','1H','2H','4H','8H'};
experimentFolder = {'rawData_1','rawData_2','rawData_3'};
rootFolder = 'D:\Project Material\PEA growth';
for idDuration = 1:length(durationFolder)
    for idExperiment = 1:length(experimentFolder)
        currentFolder = fullfile(rootFolder,durationFolder{idDuration},...
            experimentFolder{idExperiment});
        fileArray = dir(fullfile(currentFolder,'*.oib'));
        beadArray = cell(length(fileArray),1);
        for idBead = 1:length(fileArray)
            filename = fullfile(currentFolder,fileArray(idBead).name);
            sprintf('processing %s %s (%d/%d)',...
                durationFolder{idDuration}, experimentFolder{idExperiment},idBead,length(fileArray))
            beadArray{idBead} = processImgFile(filename);
        end
        save(sprintf('growth%s%s.mat',...
            durationFolder{idDuration}, experimentFolder{idExperiment}),...
            'beadArray');
    end
end

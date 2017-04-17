%script
clear
if exist('../imageAnalyze','dir')~=7
    mkdir('../imageAnalyze');
end
files = dir('../rawData/*.oib');
close all;
debug = false;
set(0,'DefaultFigureVisible','off');
BeadArray = struct(...
    'date',{},...
    'imgSize',{},...
    'pxlSize',{},...
    'numSlice',{},...
    'zStep',{},...
    'maxRadiusId',{},...
    'Ib',{},...
    'Ic',{},...
    'bRadius',...
    'cRadius',...
    'bCentroid',...
    'cCentroid',...
    'rBArray',{},...
    'bRadialI',{},...
    'cRadialI',{});
for fileId =1:length(files)
    
    filename = fullfile('../rawData',files(fileId).name);
    data = bfopen(filename);
    numSlice = size(data{1,1},1)/2;
    omeMeta = data{1,4};
    pxlSize = omeMeta.getPixelsPhysicalSizeX(0).getValue();%um
    imgSize = omeMeta.getPixelsSizeX(0).getValue();%pixel
    zStep = data{1,2}.get('Global [Axis 3 Parameters Common] Interval');
    zStep = str2double(zStep)/1000;%zStep size
    date = data{1,2}.get('Global [Acquisition Parameters Common] ImageCaputreDate');
    date= datenum(date(2:end-1),'yyyy-mm-dd HH:MM:SS');
    date = date*24*60;
    rBArray = zeros(numSlice,1);%radius Bead Array
    
    for idSlice = 1:numSlice
        Ib = data{1,1}{idSlice*2,1};%200nm image, first channel
        Ib = im2double(Ib);%convert [0,1] matrix
        Ic = data{1, 1}{idSlice*2 - 1, 1};
        Ic = im2double(Ic);
        centroid = zeros(1,2);
        [rBArray(idSlice),centroid,~,~,~] = ...
            funBeadRadiusB(Ib,centroid,15,imgSize,pxlSize,idSlice,false);
    end
    if max(rBArray) < 3
        bRadius = NaN;
        cRadius = NaN;
    else
        maxRadiusId = find(rBArray==max(rBArray),1,'last');
        Ib = data{1, 1}{maxRadiusId*2, 1};
        Ib = im2double(Ib);
        Ic = data{1, 1}{maxRadiusId*2 - 1, 1};
        Ic = im2double(Ic);
        centroid = zeros(1,2);
        [bRadius,bCentroid,bRadialI,~,bErrorFlag] = ...
            funBeadRadiusB(Ib,centroid,25,imgSize,pxlSize,maxRadiusId,false);
        [cRadius,cCentroid,cRadialI,~,cErrorFlag] = ...
            funBeadRadiusR(Ic,centroid,imgSize,pxlSize,maxRadiusId,0.5,false);
        sprintf('process %d out of %d\n',fileId,length(files))
    end
end
set(0,'DefaultFigureVisible','on');
thicknessRaw = cRadius - bRadius;
thickness = thicknessRaw(~isnan(thicknessRaw));
save('thicknessRaw.mat','thicknessRaw','cRadius','bRadius');
h_fig = figure(555);
hold on
title(sprintf('Thickness (um) %d beads',length(thickness)));
hist(thickness,sshist(thickness))
hold off
saveas(h_fig,'thickness.tiff');
close(h_fig)
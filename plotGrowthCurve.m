clear;
numMeasurement = 9;
dataFile = cell(numMeasurement,1);
for i = 1:numMeasurement
    dataFile{i} = sprintf('desorption4H35C_1rawData_%d.mat',i);
end
cRadiusCell = cell(length(dataFile),1);
bRadiusCell = cell(length(dataFile),1);
timeCell = cell(length(dataFile),1);
%load data
for idData = 1:length(dataFile)
    cRadius = [];
    bRadius = [];
    time = [];
    load(dataFile{idData,1},'beadArray')
    counter = 0;
for idBead = 1:length(beadArray)
    if beadArray{idBead,1}.errorFlag == 0
        counter = counter + 1;
        cRadius(counter) = beadArray{idBead,1}.cRadius;
        bRadius(counter) = beadArray{idBead,1}.bRadius;
        time(counter) = beadArray{idBead,1}.date;
    end
end
cRadiusCell{idData,1} = cRadius;
bRadiusCell{idData,1} = bRadius;
timeCell{idData,1} = time;
end
cRadiusArray = [];
bRadiusArray = [];
timeArray = [];
cRadiusMedianArray = [];
cRadiusMeanArray = [];
timeMedianArray = [];
for idData = 1:length(dataFile)
    cRadiusArray = cat(1,cRadiusArray,cRadiusCell{idData,1}');
    bRadiusArray = cat(1,bRadiusArray,bRadiusCell{idData,1}');
    timeArray = cat(1,timeArray,timeCell{idData,1}');
    tmp = cRadiusCell{idData,1};
    tmp = tmp(~isnan(tmp));
    tmp = tmp(tmp>0);
    tmp = tmp(tmp<10);
    cRadiusMedianArray(idData) = median(tmp);
    cRadiusMeanArray(idData) = mean(tmp);
    timeMedianArray(idData) = timeCell{idData,1}(1)-timeCell{1,1}(1);
end
thicknessArray = cRadiusArray - 7.75/2;

index = ~isnan(thicknessArray);
thicknessArray = thicknessArray(index);
timeArray = timeArray(index);
index = thicknessArray>0;
thicknessArray = thicknessArray(index);
timeArray = timeArray(index);
timeArray = timeArray - timeArray(1);
h_fig = figure(33);
thicknessMedianArray = cRadiusMedianArray-7.75/2;
thicknessMeanArray = cRadiusMeanArray-7.75/2;
hold on
title('4 Hour Growth, 35 C Desorption');
plot(timeArray/60,thicknessArray,'.k');
plot(timeMedianArray/60,thicknessMeanArray,'-b');
xlabel('Time (Hour)');
ylabel('Thickness (\mum)');
h_leg = legend('data point','mean');
set(h_leg,'location','best');
set(gca,'FontSize',15);
saveas(h_fig,'decayCurve_1.png');
hold off
densityArray = thicknessMedianArray;
densityArray = densityArray./densityArray(1);
densityArray = densityArray.^3;
figure(34)
plot(timeMedianArray,densityArray)
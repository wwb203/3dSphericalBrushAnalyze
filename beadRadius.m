clear;
%durationFolder = {'30min','1H','2H','4H','8H'};
durationFolder = {'0H','30min','1H','2H','4H','8H'};
experimentFolder = {'rawData_1','rawData_2','rawData_3'};
rootFolder = 'D:\Project Material\PEA growth';
meanThickness = zeros(length(durationFolder),1);
stdThickness = zeros(length(durationFolder),1);
for idDuration = 1:length(durationFolder)
            cRadiusArray = [];
            bRadiusArray = [];
    for idExperiment = 1:length(experimentFolder)
            load(sprintf('growth%s%s.mat',...
            durationFolder{idDuration}, experimentFolder{idExperiment}),...
            'beadArray');
        for idBead = 1:length(beadArray)
            bead = beadArray{idBead,1};
            if bead.errorFlag==0
            cRadiusArray = cat(1,cRadiusArray,bead.cRadius);
            bRadiusArray = cat(1,bRadiusArray,bead.bRadius);
            end
            if (idBead>50)&&(idDuration==5)&&(idExperiment==1)
                break;
            end
        end
    end
    thickness = bRadiusArray;
    thickness = thickness(~isnan(thickness));
    meanThickness(idDuration) = mean(thickness);
    stdThickness(idDuration) = std(thickness);
%     h_fig = figure(555);
% hold on
% %title(sprintf('%s Thickness (um) %d beads, mean %.2f, std %.2f',durationFolder{idDuration},length(thickness),mean(thickness),std(thickness)));
% %hist(thickness,sshist(thickness))
% hist(thickness,10)
% set(gca,'FontSize',24);
% xlim([3,4.5]);
% box on
% hold off
% saveas(h_fig,sprintf('thickness%s.tiff',durationFolder{idDuration}));
%close(h_fig)
end
time = [0,1,2,3,4,5];
h_fig = figure(1);
hold on
errorbar(time,meanThickness, stdThickness,'k','LineWidth',2);
plot([0,8],[3.735,3.735],'b','LineWidth',1);
plot([0,8],[4.015,4.015],'b','LineWidth',1);
hold off
ylim([3,5])
xlim([-0.2,5.5])
box on
%title('PEA Growth Curve');
xlabel('Growth Duration (hour)');
ylabel('Glass Bead Radius (\mum)');
set(gca,'FontSize',18);
set(gca,'XTick',[0 1 2 3 4 5])
labelsx = [' 0 ';
           '0.5';
          ' 1 ';
          ' 2 ';
          ' 4 ';
          ' 8 ';];
set(gca,'XTickLabel',labelsx);
saveas(h_fig,'beadRadius.tiff');
close(h_fig);
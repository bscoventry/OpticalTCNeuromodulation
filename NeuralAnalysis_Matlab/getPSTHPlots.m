%load('JPSTHCell.mat')
[nrows,ncols]= size(JPSTHCell);
nElec=zeros(nrows,1);
cor=zeros(nrows,1);
dist=zeros(nrows,1);
for ck = 1:nrows
    nElec(ck) = JPSTHCell{ck,2};
    cor(ck) = JPSTHCell{ck,3};
    dist(ck) = JPSTHCell{ck,4};
    corStim(ck) = JPSTHCell{ck,5};
    distStim(ck) = JPSTHCell{ck,6};
    JPval(ck) = JPSTHCell{ck,11};
    SPval(ck) = JPSTHCell{ck,12};
end
JPvalIDX = find(JPval<0.05);
SPvalIDX = find(SPval<0.05);
nelecJ = nElec(JPvalIDX);
nelecS = nElec(SPvalIDX);
cor = cor(JPvalIDX);
corStim = corStim(SPvalIDX);
dist = dist(JPvalIDX);
distStim = distStim(SPvalIDX);
figure(1)
boxplot(nElec);
figure(2)
%subplot(2,1,2)
boxplot(cor,dist);
title('Response Connectivity Correlation')
%subplot(2,1,1)
figure(3)
boxplot(corStim,distStim)
title('Stimulus-induced correlation')
saveFlag = 1;
if saveFlag == 1
    saveTable = [nElec,cor,dist,corStim',distStim'];
    tableLabels = cell(1,5);
    %tableLabels{1,1} = 'Responses';
    tableLabels{1,1} = 'ActiveElectrodes';
    tableLabels{1,2} = 'MaxCorr';
    tableLabels{1,3} = 'MaxDist';
    tableLabels{1,4} = 'MaxCorrStim';
    tableLabels{1,5} = 'MaxDistStim';
    statTable = array2table(saveTable,'VariableNames',tableLabels);
    writetable(statTable,'C:\CodeRepos\SpikeAnalysis\JPSTHTable.csv');
end

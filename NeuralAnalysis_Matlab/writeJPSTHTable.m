TabNames = cell(3,1);
TabNames{1} = 'nElecJ';
TabNames{2} = 'nElecS';
TabNames{3} = 'DistJ';
TabNamesS = cell(3,1);
TabNamesS{1} = 'DistStim';
TabNamesS{2} = 'CorJ';
TabNamesS{3} = 'CorStim';

JPSTHMat = zeros(4743,3);
JPSTHMat(:,1) = nelecJ;
JPSTHMat(:,2) = dist;
JPSTHMat(:,3) = cor;

StimMat = zeros(4490,3);
StimMat(:,1) = nelecS;
StimMat(:,2) = distStim;
StimMat(:,3) = corStim;

tabJ = array2table(JPSTHMat,'VariableNames',TabNames);
tabS = array2table(StimMat,'VariableNames',TabNamesS);

writetable(tabJ,'JPSTHTable.csv')
writetable(tabS,'JPSTHTableStim.csv')
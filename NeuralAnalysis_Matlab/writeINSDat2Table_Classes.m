tabNames = cell(1,5);

tabNames{1} = 'NumPulses';
tabNames{2} = 'Xenergy';
tabNames{3} = 'XISI';
tabNames{4} = 'Classes';
tabNames{5} = 'ClassVar';

%tabNames{26} = 'BARS_Mean_True';
%tabNames{27} = 'Stand_BARS_Z';
%tabNames{28} = 'Max_BARS_Z';
%load('INS_dataStore.mat');
statTable = cell2table(INSClassTable,'VariableNames',tabNames);
writetable(statTable,'C:\CodeRepos\SpikeAnalysis\INS_statTable_MKVI_UseForClasses.csv');


load('INS_dataStore_MkX.mat')
[animalnames,iA,iC] = unique(INSDataTable(:,1));
JPSTHCell = cell(1,length(animalnames));

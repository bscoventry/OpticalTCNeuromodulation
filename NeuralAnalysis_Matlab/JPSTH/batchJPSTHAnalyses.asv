load('INS_dataStore_MkX.mat')
[animalnames,iA,iC] = unique(INSDataTable(:,1));
JPSTHCell = cell(1,length(animalnames));
for ii = 1:length(animalnames)
    JPSTHCell{ii} = animalnames(ii);
end
pointer = 1;
% while pointer<length(iC)
nameList = INSDataTable(:,1);
for ck = 1:length(JPSTHCell)
    searchWin = JPSTHCell{ck}{1};
    nameIdx = find(strcmp(nameList,searchWin));
    tempStore = INSDataTable(nameIdx,1:10);
    dateList = unique(tempStore(:,2));
    for bc = 1:length(dateList)
        curDate = dateList(bc);
        JPSTHCell{ck}{bc} = curDate;
        dateIDX = find(strcmp(curDate,tempStore(:,2)));
        dateStore = tempStore(dateIDX,1:10);
        [row,~] = size(dateStore);
        elecStore = cell(1);
        for jk = 1:row
            elecStore{jk} = strcat(num2str(cell2mat(dateStore(jk,3))),' Pulses ', num2str(cell2mat(dateStore(jk,4))),' PW ', num2str(cell2mat(dateStore(jk,5))),' ISI');
        end
        stimList = unique(elecStore);
        for ee = 1:length(stimList)
            curStim = stimList{ee};
            JPSTHCell{ck}{bc}{ee} = curStim;
            stimIDX = find(strcmp(curStim,elecStore));
            stimStore = dateStore(stimIDX,1:10);
            [row,~] = size(stimStore);
            electrodeList = unique(stimStore(:,6));
            if length(electrodeList) > 1
                for ll =  
    end
end
%         dateStore = tempStore(bc,:);
%         [row, ~] = size(dateStore);
%         stimNameStore = cell(1);
%         for rr = 1:row
%             stimNameStore{rr} = strcat(num2str(cell2mat(dateStore(rr,3))),' Pulses ', num2str(cell2mat(dateStore(rr,4))),' PW ', num2str(cell2mat(dateStore(rr,5))),' ISI');
%             for jk = 1:length(stimStore)
%                 JPSTHCell{ck}{bc}{jk} = stimNameStore(jk);
%             end
%         end
%     end
% end


     
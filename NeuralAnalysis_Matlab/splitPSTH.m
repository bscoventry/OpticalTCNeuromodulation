function dataArray = splitPSTH(PSTH,waveforms,inputCat)
uniqueCat = unique(inputCat);
PSTHCell = cell(1,length(uniqueCat));
waveFormCell = cell(1,length(uniqueCat));
uniqueWhere = cell(1,length(uniqueCat));
[~,numBins] = size(PSTH);
for ck = 1:length(uniqueCat)
    curVal = uniqueCat(ck);
    curLoc = find(curVal == inputCat);
    uniqueWhere{ck} = curLoc;
end
for ck = 1:length(uniqueCat)
    curVals = uniqueWhere{ck};
    curPSTH = zeros(length(curVals),numBins);
    curWave = zeros(length(curVals),numBins);
    for bc = 1:length(curVals)
        curPSTH(bc,:) = PSTH(curVals(bc),:);
        curWave(bc,:) = waveforms(curVals(bc),:);
    end
    PSTHCell{ck} = curPSTH;
    waveFormCell{ck} = curWave;
end
%Get into info theory form
dataArray = cell(1,length(uniqueCat));
for ck = 1:length(uniqueCat)
    [numTrials,~] = size(PSTHCell{1,ck});
    tempArray = zeros(1,numBins,numTrials);
    tempArray(1,:,:) = PSTHCell{1,ck}';
    %tempArray(2,:,:) = waveFormCell{1,ck}';
    cellStore = cell(1,1);
    cellStore{1,1} = tempArray;
    %cellStore{2,1} = reshape(ck*ones(1,numBins),1,1,numBins);
    dataArray{ck} = cellStore;
end
%dataArray = PSTHCell;

function Score = getZScoreSingle(data,condition,bins)
if strcmp(condition,'spont')
    startBin = bins(1);
    endBin = bins(2);
    spont = data(startBin:endBin);
    mSpont = mean(spont);
    sdSpont = std(spont');
    Score = (data-mSpont)/sdSpont;
else
    mData = mean(data);
    sdData = std(data');
    Score = (data-mData)/sdData;
end

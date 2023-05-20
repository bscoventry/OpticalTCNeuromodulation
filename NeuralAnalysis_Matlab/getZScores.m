function zScores = getZScores(PSTH,binSize,condition,spontTimes,fs)
if strcmp('full',condition) == 1
    %Use the full data to calculate zscore. More conservative estimate
    [psthRow,psthCol] = size(PSTH);
    zScores = zeros(psthRow,psthCol);
    for ck = 1:psthRow
        curVal = PSTH(ck,:);
        curZ = zscore(curVal);
        zScores(ck,:) = curZ;
    end
elseif strcmp('spont',condition) == 1
    %Get mean and st.dev from spontaneous rates
    spontTimeStart = spontTimes(1);
    spontTimesEnd = spontTimes(2);
    if spontTimeStart == 0
        spontBinStart = 1;
    else
        spontBinStart = 0.001*spontTimeStart*fs;
    end
    spontBinEnd = 0.001*spontTimesEnd*fs;
    [psthRow,psthCol] = size(PSTH);
    binStart = round((spontBinStart/fs)*psthCol)+1;
    binEnd = round((spontBinEnd/fs)*psthCol);
    zScores = zeros(psthRow,psthCol);
    for ck = 1:psthRow
        curPSTH = PSTH(ck,:);
        spontSpikes = curPSTH(binStart:binEnd);
        meanSpont = mean(spontSpikes);
        stDevSpont = std(spontSpikes);
        zScores(ck,:) = (curPSTH - meanSpont)/(stDevSpont);
    end
else
    disp('ZScore condition not set');
end
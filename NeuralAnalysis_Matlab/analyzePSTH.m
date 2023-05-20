function [responseClass,bars,delayedOnsetFlag,inhibFlag,onsetFlag,onsetSusFlag,multiPeakedFlag] = analyzePSTH(PSTH,ZScores,binSize,PW,ISI,numPulses,onset,ZThresh,spontTimes,numBarsTrials)
onsetThresh = 50;          %If less than this thresh (ms) then onset class
onsetThreshBin = round(onsetThresh/binSize);
peakSusRatio = 3;           %Peak sus ration 3/1. Greater than this is sustained. Below is onset-sus
delayedOnset = 20;         %If latency greater than this, delayed onset category
delayedOnsetBin = round(delayedOnset/binSize);
inhibSurpress = 0.05;        % If drop by this percentage (converted already) from basal, inhibited.
%Now let's generate the stimulus times
delayedOnsetFlag = 0;         %Flag if the onset is delayed.
stimTime = 0;
onsetBin = round(onset/binSize);       %Get onset bin time.
onsetFlag = 0;
spontTime = round(spontTimes(1)/binSize):round(spontTimes(2)/binSize);
spontTimeBin = spontTime+1;
postStimInhibTime = round(50/binSize);
responseClass = cell(1);
onSusFlag = 0;
lat = 15;
latBin = round(lat/binSize);
if numPulses > 1
    PWISI = PW+ISI;           %Account for time between pulses here.
    timeMult = PWISI*(numPulses-1);
    stimTime = timeMult;
end
stimTime = stimTime+PW;       %Accounts for both single and multi-pulses from above
stimTimeBin = round(stimTime/binSize);
stimWindow = onsetBin:(onsetBin+stimTimeBin);
PSTHWin = PSTH(stimWindow);
ZWin = ZScores(stimWindow);
sigBinTime = find(ZWin >= (1.96*ZThresh));
offsetFlag = 0;
if isempty(sigBinTime)
    offsetFlag = 1;
else
    onsetBinTime = sigBinTime(1);
    if onsetBinTime-latBin >= delayedOnsetBin
        delayedOnsetFlag = 1;
    end
end
maxRate = max(PSTHWin);
maxWhere = find(PSTHWin >= (.95*maxRate));
decayFlag = 0;
multiPeakedFlag = 0;
onsetSusFlag = 0;
spontRate = PSTH(spontTimeBin);
meanspontRate = mean(spontRate);
inhibFlag = 0;
onsetCounter = 0;
for ck = 1:length(PSTHWin)
    curPSTHVal = PSTHWin(ck);
    if any(ck == maxWhere)       %Just in case there are many maxes.
        if decayFlag == 1
            decayFlag = 0;
            multiPeakedFlag = 1;
        end
        onsetCounter = 1;
    end
    if curPSTHVal <= meanspontRate && onsetCounter >= onsetThreshBin
        onsetFlag = 1;
        onsetCounter = 0;
    end
    curPSTHRatio = maxRate/curPSTHVal;
    if curPSTHRatio >= peakSusRatio && curPSTHVal > meanspontRate
        if onSusFlag == 1
            onsetSusFlag = 1;
        else
            onSusFlag = 1;
        end
    end
    if curPSTHVal <= (meanspontRate - (meanspontRate*inhibSurpress))
        inhibFlag = 1;
    end
    if onsetCounter > 1
        onsetCounter = onsetCounter + 1;
    end
end
PSTHPost = PSTH(stimWindow(1):(stimWindow(1)+postStimInhibTime));
for bc = 1:length(PSTHPost)
    curVal = PSTHPost(bc);
    if curVal <= (meanspontRate - (meanspontRate*inhibSurpress))
        inhibFlag = 1;
    end
end
if onsetFlag == 1
    if inhibFlag == 1
        if delayedOnsetFlag == 1
            responseClass{1} = 'onset+inhib+delayed';
        else
            responseClass{1} = 'onset+inhib';
        end
    else
        responseClass{1} = 'onset';
    end
elseif onsetSusFlag == 1
    if inhibFlag == 1
        if delayedOnsetFlag == 1
            responseClass{1} = 'onsetSus+inhib+delayed';
        else
            responseClass{1} = 'onsetSus+inhib';
        end
    else
        responseClass{1} = 'onsetSus';
    end
else
    if inhibFlag == 1
        if delayedOnsetFlag == 1
            responseClass{1} = 'Sus+inhib+delayed';
        else
            responseClass{1} = 'Sus+inhib';
        end
    else
        responseClass{1} = 'Sus';
    end
end
if offsetFlag == 1
    responseClass{1} = 'Offset';
end
if isempty(responseClass{1})
    responseClass{1} = 'Brandon you missed a class';
end

numBins = round(1000/binSize);
bars = [];
%bars = barsP(PSTH,0:numBins,numBarsTrials);
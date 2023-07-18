%load('JPSTHCell.mat')
[numRows,~] = size(JPSTHCell);
numiter = 5000;
for ck = 1:numRows
    curJP1 = JPSTHCell{ck,7};
    curJP2 = JPSTHCell{ck,8};
    curSP1 = JPSTHCell{ck,9};
    curSP2 = JPSTHCell{ck,10};
    sigCounterJ = 0;
    sigCounterS = 0;
    curXCorr = JPSTHCell{ck,3};
    curSCorr = JPSTHCell{ck,5};
    parfor bc = 1:numiter
        shufIDX1 = randperm(200);
        shufIDX2 = randperm(200);
        n2 = curJP2(:,shufIDX1);
        n2s = curSP2(:,shufIDX2);
        JPSTHShuff = jpsth_withCov(curJP1,n2,10);
        StimShuff =  jpsth_withCov(curSP1,n2s,10);
        corVal = max(JPSTHShuff.xcorrHist);
        corSVal = max(StimShuff.xcorrHistCov);
        if corVal>curXCorr
            sigCounterJ = sigCounterJ+1;
        end
        if corSVal > curSCorr
            sigCounterS = sigCounterS+1;
        end
    end
    pvalC = sigCounterJ./numiter;
    pvalS = sigCounterS./numiter;
    JPSTHCell{ck,11} = pvalC;
    JPSTHCell{ck,12} = pvalS;
end
    
% addpath(genpath('C:\CodeRepos\JPSTH\jpsth'))
% numShuffles = 10000;
% [rows,~]= size(JPSTHCell);
% curHistBin = 10;
% for ck = 1:rows
%     stimCorr = JPSTHCell{ck,5};
%     JPSTHCor = JPSTHCell{ck,3};
%     psth1 = JPSTHCell{ck,7};
%     psth2 = JPSTHCell{ck,8};
%     psth1Cor = JPSTHCell{ck,9};
%     psth2Cor = JPSTHCell{ck,10};
%     counterJPSTH = 0;
%     counterJPSTHCor = 0;
%     for bc = 1:numShuffles
%         pSize = length(psth2);
%         idx = randperm(pSize);
%         psthRe = psth2(idx);
%         JPSTH = jpsth_withCov(psth1,psthRe,curHistBin);
%         if max(JPSTH.xcorrHist) > JPSTHCor
%             counterJPSTH = counterJPSTH+1;
%         end
%     end
%     for bc = 1:numShuffles
%         pSize = length(psthCor2);
%         idxCor = randperm(pSize);
%         psthReCor = psth2Cor(idxCor);
%         JPSTH = jpsth_withCov(psth1Cor,psthReCor,curHistBin);
%         if max(JPSTH.xcorrHist) > stimCorr
%             counterJPSTHCor = counterJPSTHCor+1;
%         end
%     end
%     pValJ = counterJPSTH./numShuffles;
%     pValS = counterJPSTHCor./numShuffles;
%     JPSTHCell{ck,11} = pValJ;
%     JPSTHCell{ck,12} = pValS;
% end

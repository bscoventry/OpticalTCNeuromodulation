%-------------------------------------------------------------------------
% Author: Brandon S Coventry
% Goal: To transform data from raster into Infotheory toolbox (Timme) form
% Date: 01/10/2023
%--------------------------------------------------------------------------
%Data storage shape
% n stimulus conditionsxresponse rasterxn trials. A second output will
% contain stimulus numbers between 1-12, corresponding to what stimulus was
% given.
close all;clear all;
addpath(genpath('C:\CodeRepos\JPSTH\jpsth'))
dataCell = cell(10,10);
homeDir = pwd;
dataDir = 'C:\DataRepos\INS';
animalNamesCell = cell(1,5);
animalNamesCell{1} = 'INS2102';
animalNamesCell{2} = 'INS2015';
animalNamesCell{3} = 'INS2013';
animalNamesCell{4} = 'INS2008';
animalNamesCell{5} = 'INS2007';
numAnimals = size(animalNamesCell);
numAnimals = numAnimals(2);
binsize = 0.005;
curHistBin = 10;
keepflag = 0;
%INS2102
Dates2102 = cell(1,6);
%Data Cell params
%Animal name     Date   NumPulses   PW  ISI  Energies  Rasters   TE   MI
% JPSTH = cell(1,9);
% MIDataCellCounter = 1;
% jPSTHCell{1,1} = 'C:\DataRepos\INS\INS2102\02_26_21\5PU_10PW_50ISI';
% jPSTHCell{1,2} = [5,10,50];
% jPSTHCell{2,1} = 'C:\DataRepos\INS\INS2102\02_25_21\5PU_10PW_50ISI';
% jPSTHCell{2,2} = [5,10,50];
% jPSTHCell{3,1} = 'C:\DataRepos\INS\INS2102\02_25_21\5PU_0_7PW_0_5ISI';
% jPSTHCell{3,2} = [5,0.7,0.5];
% jPSTHCell{4,1} = 'C:\DataRepos\INS\INS2102\02_22_21\20PU_0_2PW_0_5ISI';
% jPSTHCell{4,2} = [20,0.2,0.5];
% jPSTHCell{5,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_5PW_5ISI';
% jPSTHCell{5,2} = [10,5,5];
% jPSTHCell{6,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_1PW_1ISI';
% jPSTHCell{6,2} = [10,1,1];
% jPSTHCell{7,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_0_7PW_0_5ISI';
% jPSTHCell{7,2} = [10,0.7,0.5];
% jPSTHCell{8,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_0_5PW_1ISI';
% jPSTHCell{8,2} = [10,0.5,1];
% jPSTHCell{9,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_0_2PW_1ISI';
% jPSTHCell{9,2} = [10,0.2,1];
% jPSTHCell{10,1} = 'C:\DataRepos\INS\INS2102\02_22_21\10PU_0_2PW_0_5ISI';
% jPSTHCell{10,2} = [10,0.2,0.5];

%% Guess I'm brute forcing it
% for ck = 1:12
%     dataCell{ck,1} = 'INS2015';
%     dataCell{ck,2} = '12_14_20';
%     dataCell{ck,3} = 5;
%     dataCell{ck,4} = 10;
% %     dataCell{ck,5} = 5;
% if ~exist('INSDataTable','var')
%     load('INS_dataStore_MkX.mat');
% end
% [numrows,numcols] = size(INSDataTable);
% counter = 0;
% for ck = 1:numrows
%     if ck ~= numrows
%         if INSDataTable{ck+1,6} >= INSDataTable{ck,6} || isnan(INSDataTable{ck+1,7})
%             counter = counter + 1;
%         else
%             disp('here')
%             loadfile = strcat(dataDir,'\',INSDataTable{ck,1},'\',INSDataTable{ck,2},'\',num2str(INSDataTable{ck,3}),'PU_');
%             if INSDataTable{ck,4} >= 1
%                 PWstr = num2str(INSDataTable{ck,4});
%             elseif INSDataTable{ck,4} == 0.5
%                 PWstr = '0_5';
%             elseif INSDataTable{ck,4} == 0.3
%                 PWstr = '0_3';
%             elseif INSDataTable{ck,4} == 0.25
%                 PWstr = '0_25';
%             else
%                 disp('Brandon you missed one PW')
%                 disp(ck)
%             end
%             if INSDataTable{ck,5} >= 1
%                 ISIstr = num2str(INSDataTable{ck,5});
%             elseif INSDataTable{ck,5} == 0.5
%                 ISIstr = '0_5';
%             elseif INSDataTable{ck,5} == 0.3
%                 ISIstr = '0_3';
%             elseif INSDataTable{ck,5} == 0.25
%                 ISIstr = '0_25';
%             else
%                 disp('Brandon you missed one ISI')
%                 disp(ck)
%             end
%             loadfile = strcat(loadfile,PWstr,'PW_',ISIstr,'ISI');
%             try
%                 cd(loadfile)
%             curElec = INSDataTable{ck,6};
%             
%             load('spikeSortRaster1.mat')
%             
%             
%             load('spikeSortRaster2.mat')
%             spikeSortRaster = spikeSortRaster1;
%             for bbc = 1:8
%                 spikeSortRaster{bbc+8} = spikeSortRaster2{bbc};
%             end
%             
%             end
%         end
%     end
% end
load('jPSTH_5msBinsRaw.mat')
[numRows,numCols] = size(MIDataCell);
counter = 1;
%jPSTHCell = cell(1,3);
globalCounter = 1;
JPSTHcellCounter = 1;
JPSTHCell = cell(1,1);
psthCell = cell(1,1);
numactiveSites = [];
storeJPSTH = cell(1,1);
for ck = 1:round(numRows)
    
    if JPSTHcellCounter == 16
            disp('cray')
    end
    animalName = MIDataCell{ck,1};
    animalDate = MIDataCell{ck,2};
    nPulse = MIDataCell{ck,3};
    PW = MIDataCell{ck,4};
    ISI = MIDataCell{ck,5};
    nanimalName = MIDataCell{ck+1,1};
    nanimalDate = MIDataCell{ck+1,2};
    nnPulse = MIDataCell{ck+1,3};
    nPW = MIDataCell{ck+1,4};
    nISI = MIDataCell{ck+1,5};
    curAn = strcat(animalName,animalDate,num2str(nPulse),num2str(PW),num2str(ISI));
    nextAn = strcat(nanimalName,nanimalDate,num2str(nnPulse),num2str(nPW),num2str(nISI));
    if strcmp(curAn,nextAn) == 1
        counter = counter + 1;
        globalCounter = globalCounter + 1;
    else
        if JPSTHcellCounter == 16
            disp('cray')
        end
        numTests = counter;
        counter = 1;
        if strcmp(animalName,'INS2008')==0     %2008 received a michigan style array
            psthCell = cell(1,1);
            elecCounter = [];
            for bc = 1:numTests
                psthCell{bc,1} = MIDataCell{ck-(bc-1),7};
                psthCell{bc,2} = MIDataCell{ck-(bc-1),6};
                psthCell{bc,3} = MIDataCell{ck-(bc-1),12};
                psthCell{bc,4} = MIDataCell{ck-(bc-1),13};
                elecCounter = [elecCounter MIDataCell{ck-(bc-1),13}];
            end
            totElec = length(unique(elecCounter));
            [srow,~] = size(psthCell);
            if numTests > 1
                cmpVec = nchoosek(1:srow,2);
            else
                cmpVec = [1,1];
            end
            [crow,~] = size(cmpVec);
            trueJPSTHStore = cell(crow,1);
            maxCorr = -1;
            maxCorrStim = -1;
            for bc = 1:crow
                curCombo = cmpVec(bc,:);
                psth1 = psthCell{curCombo(1),1};
                psth2 = psthCell{curCombo(2),1};
                JPSTHStorage = cell(12,1);
                for jvk = 1:12
                    curPSTH1 = squeeze(psth1{1,jvk}{1,1})';
                    curPSTH2 = squeeze(psth2{1,jvk}{1,1})';
                    curEnergy = psthCell{curCombo(1),2}(jvk);
                    zscoreVal1 = getPSTHWBin(curPSTH1,0.005,nPulse,ISI,PW);
                    zscoreVal2 = getPSTHWBin(curPSTH1,0.005,nPulse,ISI,PW);
                    if zscoreVal1 >= 3
                        if zscoreVal2 >= 3
                            keepflag = 1;
                    try
                    JPSTH = jpsth_withCov(curPSTH1,curPSTH2,curHistBin);
                    
                    JPSTH.energy = curEnergy;
                    JPSTH.neuronNums = [psthCell{curCombo(1),3},psthCell{curCombo(2),3}];
                    JPSTH.electrode = [psthCell{curCombo(1),4},psthCell{curCombo(2),4}];
                    JPSTH.distance = calcTDTDist(JPSTH.electrode(1),JPSTH.electrode(2));
                    JPSTH.animalName = animalName;
                    JPSTH.animalDate = animalDate;
                    JPSTH.pulsePWISI = [nPulse,PW,ISI];
                    %[pvalJ,pvalS]=shuffleJPSTH(curPSTH1,curPSTH2,curHistBin,1000,max(JPSTH.xcorrHist),max(JPSTH.xcorrHistCov));
                    maxCorVal = max(JPSTH.covariogram(JPSTH.sigPeakEndpoints));
                    if max(JPSTH.xcorrHist) > maxCorr
                        %if pvalJ < 0.05
                            storeJFlag = 0;
                            maxCorr = max(JPSTH.xcorrHist);
                            maxDist = JPSTH.distance;
                            mPSTH1 = curPSTH1;
                            mPSTH2 = curPSTH2;
                            %sigValJ = pvalJ;
                        %end
                    end
                    if max(JPSTH.stimCovariance) > maxCorrStim
                        %if pvalS < 0.05
                            maxCorrStim = max(JPSTH.stimCovariance);
                            maxDistStim = JPSTH.distance;
                            sPSTH1 = curPSTH1;
                            sPSTH2 = curPSTH2;
                            %sigValS = pvalS;
                        %end
                    end
                    if max(JPSTH.xcorrHist) >= 0.5
                        disp('whoa!')
                    end
                    
%                     if jvk == 12
%                         numactiveSites(JPSTHcellCounter) = 
%                         covar(1,JPSTHcellCounter+1) = max(JPSTH.xcorrHist);
%                         covar(2,JPSTHcellCounter+1) = JPSTH.distance;
%                         JPSTHcellCounter = JPSTHcellCounter+1;
%                         
%                     end
                        JPSTHStorage{jvk,1} = JPSTH;
                        clear("JPSTH")
                     catch
                        %disp('here')
                     end
                    
                   
                        end
                    end
                end
                if keepflag == 1
                trueJPSTHStore{bc,1} = JPSTHStorage;
                JPSTHCell{JPSTHcellCounter,1} = trueJPSTHStore;
                    clear("trueJPSTHStore")
                    JPSTHCell{JPSTHcellCounter,2} = totElec;
                    JPSTHCell{JPSTHcellCounter,3} = maxCorr;
                    JPSTHCell{JPSTHcellCounter,4} = maxDist;
                    JPSTHCell{JPSTHcellCounter,5} = maxCorrStim;
                    JPSTHCell{JPSTHcellCounter,6} = maxDistStim;
                    JPSTHCell{JPSTHcellCounter,7} = mPSTH1;
                    JPSTHCell{JPSTHcellCounter,8} = mPSTH2;
                    JPSTHCell{JPSTHcellCounter,9} = sPSTH1;
                    JPSTHCell{JPSTHcellCounter,10} = sPSTH2;
                    JPSTHcellCounter = JPSTHcellCounter+1;               %JPSTHCell{JPSTHcellCounter,1} = JPSTHStorage;
                %JPSTHcellCounter = JPSTHcellCounter+1;
                keepflag = 0;
                end
            end
            
                
             
        end
    end
end
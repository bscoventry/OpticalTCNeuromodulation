%-------------------------------------------------------------------------
% Author: Brandon S Coventry
% Goal: To transform data from raster into Infotheory toolbox (Timme) form
% Date: 01/10/2023
%--------------------------------------------------------------------------
%Data storage shape
% n stimulus conditionsxresponse rasterxn trials. A second output will
% contain stimulus numbers between 1-12, corresponding to what stimulus was
% given.
addpath(genpath('C:\CodeRepos\InfoTheoryToolbox\Code\Neuroscience Information Theory'))
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
%INS2102
Dates2102 = cell(1,6);
%Data Cell params
%Animal name     Date   NumPulses   PW  ISI  Energies  Rasters   TE   MI
MIDataCell = cell(1,9);
MIDataCellCounter = 1;
startTime = 0.2./binsize;
% Dates2102(1) = '02_26_21';
% Dates2102(2) = '02_25_21';
% Dates2102(3) = '02_22_21';
% Dates2102(4) = '02_19_21';
% Dates2102(5) = '02_16_21';
% Dates2102(6) = '02_15_21';
%% Guess I'm brute forcing it
%for ck = 1:12
    %dataCell{ck,1} = 'INS2015';
    %dataCell{ck,2} = '12_14_20';
    %dataCell{ck,3} = 5;
    %dataCell{ck,4} = 10;
    %dataCell{ck,5} = 5;
if ~exist('INSDataTable','var')
    load('INS_dataStore_MkX.mat');
end
[numrows,numcols] = size(INSDataTable);
counter = 0;
for ck = 1:numrows
    if ck ~= numrows
        if INSDataTable{ck+1,7} > INSDataTable{ck,7} || isnan(INSDataTable{ck+1,7})
            counter = counter + 1;
        else
            disp('here')
            loadfile = strcat(dataDir,'\',INSDataTable{ck,1},'\',INSDataTable{ck,2},'\',num2str(INSDataTable{ck,3}),'PU_');
            if INSDataTable{ck,4} >= 1
                PWstr = num2str(INSDataTable{ck,4});
            elseif INSDataTable{ck,4} == 0.5
                PWstr = '0_5';
            elseif INSDataTable{ck,4} == 0.3
                PWstr = '0_3';
            elseif INSDataTable{ck,4} == 0.25
                PWstr = '0_25';
            elseif INSDataTable{ck,4} == 0.20
                PWstr = '0_2';
            else
                disp('Brandon you missed one PW')
                disp(ck)
            end
            if INSDataTable{ck,5} >= 1
                ISIstr = num2str(INSDataTable{ck,5});
            elseif INSDataTable{ck,5} == 0.5
                ISIstr = '0_5';
            elseif INSDataTable{ck,5} == 0.3
                ISIstr = '0_3';
            elseif INSDataTable{ck,5} == 0.25
                ISIstr = '0_25';
            elseif INSDataTable{ck,5} == 0.20
                ISIstr = '0_2';
            else
                disp('Brandon you missed one ISI')
                disp(ck)
            end
            loadfile = strcat(loadfile,PWstr,'PW_',ISIstr,'ISI');
            try
                cd(loadfile)
            curElec = INSDataTable{ck,6};
            if curElec < 9
                load('spikeSortRaster1.mat')
                spikeSortRaster = spikeSortRaster1;
            else
                load('spikeSortRaster2.mat')
                spikeSortRaster = spikeSortRaster2;
            end
            cd(homeDir);
            numEnergies = counter;
            energyVec = zeros(numEnergies+1,1);
            ISIVec = zeros(numEnergies+1,1);
            for totEnergy1 = 1:counter+1
                curIt=(ck-counter)+(totEnergy1-1);
                energyVec(totEnergy1) = INSDataTable{curIt,15};
                
            end
            energyPerPulse = energyVec./INSDataTable{ck,4};
            ISIVec = INSDataTable{ck,5};
            counter = 0;
            trueElec = curElec;
            if INSDataTable{ck,24} == 1
                if curElec >= 9
                    curElec = curElec-8;
                end
                cellNum = INSDataTable{ck,8};
                curData = spikeSortRaster{1,curElec}{1,cellNum};
                curPSTH = getPSTHIT(curData,24415,binsize);
                [numTotTrials,~] = size(curData);
                if numEnergies >= 11
                    stimpeaks = load('INSvoltagevals.mat');
                    laserVoltages = double(stimpeaks.stimpeaks);
                    laserVoltages = laserVoltages(1:611);
                    [waveForms,conditions] = getStims(INSDataTable{ck,3},INSDataTable{ck,4},INSDataTable{ck,5},24415,binsize,611,laserVoltages,startTime);
                    dataArray = splitPSTH(curPSTH,waveForms,laserVoltages);
                    [~,nT] = size(waveForms);
                    categories = unique(laserVoltages);
                    %dataArray{2,1} = reshape(laserVoltages,1,1,length(laserVoltages));
                    %dataArray{1,1} = curPSTH';
                    %[infoPSTH,numTrialVec] = prepInfoBreakTool(dataArray);
%                     opts.nt = numTrialVec;
%                     opts.method = 'gs';
%                     opts.bias = 'qe';
%                     opts.verbose = false;
%                     [MI] = information(infoPSTH,opts,'I');
                     %MethodAssign = {
                         %1,1,'UniCB',{100};...
                         %};
                      %dataRaster = cell(2,1);
%                     %dataRaster{1} = dataArray;
%                     %dataRaster{2} = conditions;
                     %dataRaster1 = zeros(1,1000,611);
                     %dataRaster1(1,:,:) = curPSTH';
                     %dataRaster1(2,:,:) = waveForms';
                     %dataRaster{1,1} = dataRaster1;
                     %dataRaster{2,1} = conditions;
                     %StatesRaster = data2states(dataArray,MethodAssign);
%                     %Split into n categories, by power level.
                     %nT = 1000;%size(StatesRaster,2);
%                     TE = cell(1,12);
%                     TEVals = NaN([1,nT]);
%                     Method = 'TE';
%                     %for bT = 1:12
%                         for iT = 2:nT
%                             VariableIDs = {1,1,iT;1,1,iT - 1;1,2,iT - 1};
%                             TEVals(iT) = instinfo(StatesRaster, Method, VariableIDs);
%                         end
                        %TE{bT} = TEVals;
                    %end
%                     % Stimulus encoding by Neurons
%                      ME = NaN(12,nT);
%                      MIE2Vals = NaN([nT,1]);
%                      Method = 'Ent';
%                      for bT = 1:12
%                          curData = dataArray{bT};
%                          curData = curData{1}(:,1:200,:);
%                          MethodAssign = {
%                          1,1,'UniCB',{100};...
%                          };
%                          StatesRaster = data2states(curData,MethodAssign);
%                          for iT = 1:200
%                                  VariableIDs = {1,1,iT};
%                                  basal(iT) = instinfo(StatesRaster, Method, VariableIDs);
%     % %                         end
%     % %                         ME{bT} = MIE2Vals;
%                          end
%                          
%                      end
%                      medChange = mean(basal);
%                      for bT = 1:12
%                          curData = dataArray{bT};
%                          MethodAssign = {
%                          1,1,'UniCB',{100};...
%                          };
%                          StatesRaster = data2states(curData,MethodAssign);
%                          for iT = 1:nT
%                                  VariableIDs = {1,1,iT};
%                                  [MIE2Vals(iT),p(iT)] = instinfo(StatesRaster, Method, VariableIDs,'MCpThresh', 0.01);
%                                  response(iT) = MIE2Vals(iT) - medChange;
%     % %                         end
%     % %                         ME{bT} = MIE2Vals;
%                          end
%                          ME(bT,:) = MIE2Vals;
%                          MEResp(bT,:) = response;
%                      end
                    
                     
                     binsofStim = round((INSDataTable{ck,3}*INSDataTable{ck,4})+((INSDataTable{ck,3}-1)*INSDataTable{ck,5}))+100;
                    if MIDataCellCounter == 69
                        disp('here')
                    end
                    MIDataCell{MIDataCellCounter,1} = INSDataTable{ck,1};
                    MIDataCell{MIDataCellCounter,2} = INSDataTable{ck,2};
                    MIDataCell{MIDataCellCounter,3} = INSDataTable{ck,3};
                    MIDataCell{MIDataCellCounter,4} = INSDataTable{ck,4};
                    MIDataCell{MIDataCellCounter,5} = INSDataTable{ck,5};
                    MIDataCell{MIDataCellCounter,7} = dataArray;
%                     MIDataCell{MIDataCellCounter,8} = MEResp;
%                     MIDataCell{MIDataCellCounter,9} = ME;
                    MIDataCell{MIDataCellCounter,10} = energyPerPulse;
                    MIDataCell{MIDataCellCounter,11} = ISIVec;
                    MIDataCell{MIDataCellCounter,12} = INSDataTable{ck,8};
                    MIDataCell{MIDataCellCounter,13} = trueElec;
                    energyCal = 0:numEnergies;
                    powerVec = zeros(1,length(energyCal));
                    for jk = 1:length(energyCal)
                        powerVec(jk) = INSDataTable{ck-energyCal(jk),7};
                    end
                    powerVec = fliplr(powerVec);
                    MIDataCell{MIDataCellCounter,6} = powerVec;
                    MIDataCellCounter = MIDataCellCounter + 1;
                end
            end
            catch
                disp('Did not find')
                disp(loadfile)
            end
        end
    end
end
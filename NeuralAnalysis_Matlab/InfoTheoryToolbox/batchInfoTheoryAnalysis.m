%-------------------------------------------------------------------------
% Author: Brandon S Coventry
% Goal: To transform data from raster into Infotheory toolbox (Timme) form
% Date: 01/10/2023
%--------------------------------------------------------------------------
%Data storage shape
% n stimulus conditionsxresponse rasterxn trials. A second output will
% contain stimulus numbers between 1-12, corresponding to what stimulus was
% given.
addpath(genpath('C:\CodeRepos\Information Breakdown ToolBox - v.1.0.3'))
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
binsize = 0.001;
%INS2102
Dates2102 = cell(1,6);
%Data Cell params
%Animal name     Date   NumPulses   PW  ISI  Energies  Rasters   TE   MI
MIDataCell = cell(1,9);
MIDataCellCounter = 1;
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
            else
                disp('Brandon you missed one ISI')
                disp(ck)
            end
            loadfile = strcat(loadfile,PWstr,'PW_',ISIstr,'ISI');
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
            counter = 0;
            if INSDataTable{ck,24} == 1
                cellNum = INSDataTable{ck,8};
                curData = spikeSortRaster{1,curElec}{1,cellNum};
                curPSTH = getPSTHIT(curData,24415,binsize);
                [numTotTrials,~] = size(curData);
                if numEnergies >= 11
                    stimpeaks = load('INSvoltagevals.mat');
                    laserVoltages = double(stimpeaks.stimpeaks);
                    laserVoltages = laserVoltages(1:611);
                    [waveForms,conditions] = getStims(INSDataTable{ck,3},INSDataTable{ck,4},INSDataTable{ck,5},24415,0.001,611,laserVoltages);
                    dataArray = splitPSTH(curPSTH,waveForms,laserVoltages);
                    %categories = unique(laserVoltages);
                    %dataArray{2,1} = reshape(categories,1,1,length(categories));
                    MethodAssign = {2,1,'Nat',{};...
                        1,1,'UniCB',{1000};...
                        1,2,'UniCB',{1000};...
                        };
                    %dataRaster = cell(2,1);
                    %dataRaster{1} = dataArray;
                    %dataRaster{2} = conditions;
                    StatesRaster = data2states(dataArray,MethodAssign);
                    %Split into n categories, by power level.
                    nT = size(StatesRaster{1},2);
                    TE = cell(1,12);
                    TEVals = NaN([1,nT]);
                    Method = 'TE';
                    for bT = 1:12
                        for iT = 2:nT
                            VariableIDs = {1,1,iT;1,1,iT - 1;2,1,iT - 1};
                            TEVals(iT) = instinfo(StatesRaster, Method, VariableIDs);
                        end
                        TE{bT} = TEVals;
                    end
                    % Stimulus encoding by Neurons
%                     ME = cell(1,12);
%                     MIE2Vals = NaN([1,nT]);
%                     Method = 'PairMI';
%                     for bT = 1:12
%                         for iT = 1:nT
%                             VariableIDs = {bT,1,iT;bT,2,1};
%                             MIE2Vals(iT) = instinfo(StatesRaster, Method, VariableIDs);
%                         end
%                         ME{bT} = MIE2Vals;
%                     end
                    MIDataCell{MIDataCellCounter,1} = INSDataTable{ck,1};
                    MIDataCell{MIDataCellCounter,2} = INSDataTable{ck,2};
                    MIDataCell{MIDataCellCounter,3} = INSDataTable{ck,3};
                    MIDataCell{MIDataCellCounter,4} = INSDataTable{ck,4};
                    MIDataCell{MIDataCellCounter,5} = INSDataTable{ck,5};
                    MIDataCell{MIDataCellCounter,7} = dataArray;
                    MIDataCell{MIDataCellCounter,8} = TE;
                    %MIDataCell{MIDataCellCounter,9} = ME;
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
        end
    end
end
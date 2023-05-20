%--------------------------------------------------------------------------
% Purpose: Generate stimulus waveforms and power conditions for IT analysis
%--------------------------------------------------------------------------
function [waveForms,conditions] = getStims(numPulses,PW,ISI,fs,binSize,numtrials,energyVec,startTime)
binsPerSamp = fs*binSize;
numtotal = ceil(fs/binsPerSamp);
waveForms = zeros(numtrials,numtotal);
%startTime = 200;
binPulses = round(PW/(binSize*10^3));

ISIPulses = round(ISI/(binSize*10^3));
uniqueConditions = unique(energyVec);
binCounter = startTime;
waveFormsGen = zeros(1,numtotal);
for ck = 1:numPulses
    waveFormsGen(binCounter:binCounter+binPulses) = 1;
    binCounter = binCounter+binPulses;
    waveFormsGen(binCounter:binCounter+ISIPulses) = 0;
    binCounter = binCounter+ISIPulses;
end
conditions = zeros(1,1,numtrials);
for bc = 1:numtrials
    waveForms(bc,:) = waveFormsGen*energyVec(bc);
    conditions(1,1,bc) = find(uniqueConditions==energyVec(bc));
end

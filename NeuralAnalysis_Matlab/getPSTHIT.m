function PSTH = getPSTHIT(data,fs,binsize)
[numrows,numcols] = size(data);
if isempty(gcp('nocreate'))
    parpool();
end
binsPerSamp = fs*binsize;
numtotal = ceil(fs/binsPerSamp);
PSTH = zeros(numrows,numtotal);
for ck = 1:numrows
    curRas = data(ck,:);
    counter = 1;
    tempBins = zeros(1,numtotal);
    for bc = 1:numtotal
        tempBins(bc)=sum(curRas(counter:counter+round(binsPerSamp)));
        counter = counter+round(binsPerSamp);
    end
    PSTH(ck,:) = tempBins;
end
[numrow,numcols] = size(INSDataTable);
binsize = 5;
downtime = 4; %4 bins, 20ms
for ck = 1:numrow
    curBars = BARSFits(ck,:);
    if sum(curBars)>0
        INSDataTable{ck,26} = curBars;
        spontStartTime = 1;
        spontEndTime = 39;
        INSDataTable{ck,27} = getZScoreSingle(curBars,'spont',[spontStartTime spontEndTime]);
        totStimTime = round((INSDataTable{ck,3}*INSDataTable{ck,4})+((INSDataTable{ck,3} -1)*INSDataTable{ck,5})/binsize);
        totTime = totStimTime+downtime;
        win = curBars(40:40+totTime);
        INSDataTable{ck,28} = max(win);
    else
        INSDataTable{ck,26} = nan;
        INSDataTable{ck,27} = nan;
        INSDataTable{ck,28} = nan;
    end
end

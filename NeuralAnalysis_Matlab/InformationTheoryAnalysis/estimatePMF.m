function pmf = estimatePMF(data)
data = squeeze(data);  %Theres and extra 1 dimension that we need to remove
dataCounters = sum(data,2);
pmf = dataCounters./sum(dataCounters);
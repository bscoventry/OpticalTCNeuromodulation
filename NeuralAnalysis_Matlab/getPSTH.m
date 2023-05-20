function psth = getPSTH(raster,binSize,fs)
bin = 1:(binSize*0.001*fs);
binlen = length(bin);

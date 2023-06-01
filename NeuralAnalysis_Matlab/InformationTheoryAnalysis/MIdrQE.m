%--------------------------------------------------------------------------
% Author: Brandon S Coventry
% Date: 06/01/2023
% Purpose: This function calculates I(R|Sx) the mutual information given
% a stimulus as outlines in Borst and Theunissen 1999. We use the direct
% method here with quadratic estimation bias correction. QE was adapted
% from code by Bryan Krause, Banks lab UW Madison
% Inputs:
%   RS - Conditional response given stimulus S in the form of
%   trialsxbincounts
%   R - Total response across all stimuli. Form of trialsxbincounts
% Outputs:
%   I - Direct mutual information per stimulus
%   Iqe - Bias corrected mutual information per stimulus.
%   bias - Estimated bias reference to conditional response on stimulus.
% Note here, bias is estimated with respect to p(R|Sx), due to the fact
% that bias is going to be more broadly expressed in lower sampled p(R|S)
% than p(R). This should be explored more.
%--------------------------------------------------------------------------
function [I, Iqe,bias] = MIdrQE(RS,R)
%Get the number of trials in both RS and R
[nTrials,~] = size(R);
[nTrialsPerS,~] = size(RS);
%Fractions of data to use for QE estimate; randomly drawn so we repeat a
%few times
fractions = [1 .5 .5 .5 .5 .25 .25 .25 .25 .25 .25 .25 .25];

useTrials = round(fractions*nTrials);
useTrialsPerS = round(fractions*nTrialsPerS);
partMIestimates = zeros(size(useTrials));

%Now estimate empirical probability mass functions (since this is discrete
%counts.
pR = estimatePMF(R);
pRS = estimatePMF(RS);

[numBinsR,~] = size(pR);
[numBinsRS,~] = size(pRS);
if numBinsR ~= numBinsRS
    error("Value Error: Number of bins in R and RS are not equal. Estimates of probability need to have equal numbers of bins");
end
IperBin = pRS.*log2(pRS./pR); %Borst 1999.
%Remove any infs. This is allowable from MacKay's "Information Theory,
%Inference, and Learning Algorithms" where 0xlog(0/0) = 0 by convention.
IperBin(isinf(IperBin)|isnan(IperBin)) = [];
I = sum(IperBin);
%We have the direct estimate now. Now let's estimate the bias.
for ck=1:length(useTrials)
    kR = randperm(nTrials);
    kRS = randperm(nTrialsPerS);
    RSamp = R(kR(1:useTrials(ck)),:);
    RSSamp = RS(kRS(1:useTrialsPerS(ck)));
    pRSamp = estimatePMF(RSamp);
    pRSSamp = esimatePMF(RSSamp);
    IperBinSamp = pRSSamp.*log2(pRSSamp./pRSamp);
    IperBinSamp(isinf(IperBinSamp)|isnan(IperBinSamp)) = [];
    partMIestimates(ck) = sum(IperBinSamp);
end
[p,S,mu] = polyfit(1./useTrialsPerS,partMIestimates,2);
Iqe = polyval(p,0,S,mu);
bias = polyval(p,1/nTrialsPerS,S,mu)-Iqe;

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
%--------------------------------------------------------------------------
function [I Ieq] = MIdrQE(RS,R)
%Get the number of trials in both RS and R
[nTrials,~] = size(R);
[nTrialsPerS,~] = size(RS);
%Fractions of data to use for QE estimate; randomly drawn so we repeat a
%few times
fractions = [1 .5 .5 .5 .5 .25 .25 .25 .25 .25 .25 .25 .25];

useTrials = round(fractions*nTrials);
useTrialsPerS = round(fractions*nTrialsPerS);
partMIestimates = zeros(size(useTrials));

pR = 
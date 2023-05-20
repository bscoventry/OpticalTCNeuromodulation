%--------------------------------------------------------------------------
% Author: Georgia Lawlor
% Date: 1/24/21
% Purpose: Create jPSTHs for a set of binned data from a specific input
% file which is described below. 
% Revision History: 
%    2/18/21 - Simplified code, reformatted code so the jPSTH, coincidence,
%    and cross-correlogram are computed here and not throuhg a function
% Notes: Input data to be sorted by neurons on each channel of the format:
%    totDataINS.mat -> Struct .totDataINS to reveal a 1x12 cell array
%    Columns of cell array:
%    1. Animal Name 
%    2. Date 
%    3. Series 
%    4. Sampling Frequency 
%    5. Num Pulses 
%    6. ISI 
%    7. Pulse Width 
%    8. Stim Onset(time) 
%    9. Stim Onset(samples) 
%    10. Power Levels
%    11. Raster (binned) 
%    12. PSTH (sorted) 
%    13. PSTH (unsorted) 
%    14. Z Scores (sorted)
%
% This program will create an additional column for the output:
%    15. Outputs (contains neuron comparisons and resulting jPSTH data)
%
% Required Functions
%    gaussfilt()      - gaussian smoothing of histograms
%
% Revisions to be made
%     - Check normailzation strategies
%     - Maybe include more bins in coincidence
%     - Write own gaussian smoothing?
%     - Create new file for plotting that reads in dataTable that already has
%           outputs
%     - include brandon's z-score ignore function
%     
%--------------------------------------------------------------------------
clear; clc;

%% User Inputs are Defined here
input_file = 'totDataINS.mat';         % Input file name
binSize_T  = 5;                        % Time contained in each bin (ms)
sigma      = 2;                        % Gaussian Smoothing Factor
CCbins     = 20;                       % Bin Size for Cross-Correlogram

%% Unpack Data from input file
% Load the data from the .mat file (use .struct designator to fully unpack) 
dataTable = load('totDataINS.mat').totDataINS;

% Step through each row to calculated outputs for each experiement 
for seriesRow = 2:size(dataTable,1)
    
    % Unpack Data for each experiment
    Fs          = dataTable{seriesRow,4};   % Sampling frequency (Hz)
    num_pulse   = dataTable{seriesRow,5};   % Number of stim pulses
    ISI         = dataTable{seriesRow,6};   % Time between stim pulses 
    pulseWidth  = dataTable{seriesRow,7};   % Pulse width in ms
    stimOnset_T = dataTable{seriesRow,8};   % Stim onset in ms
    stimOnset_S = dataTable{seriesRow,9};   % Stim onset in samples
    powerLevels = dataTable{seriesRow,10};  % Power levels tested
    binned      = dataTable{seriesRow,11};  % Binned data

    % Find binned data specific information
    binSize_I = round((binSize_T/1000)/(1/Fs));  % Bin width - indicies
    nchan     = length(binned);                  % Number of Channels
    nbins     = size(binned{1}{1}{1},2);         % Number of Bins

    % Find total number of neurons recorded by each channel
    neuron_list = zeros(1,16);
    for chan = 1:nchan
        neuron_list(chan) = length(binned{chan});
    end
    
    % Total number of jPSTHs that must be computed
    tot_jPSTH = round(factorial(sum(neuron_list))/(2*factorial(sum(neuron_list)-2)));

    % Step through each power level to compare all neurons at that level
    for pow = 1:12 %length(powerLevels)
        
        % Write column titles to the output cell
        dataTable{seriesRow,15}{pow}{1,1} = 'Neuron 1';
        dataTable{seriesRow,15}{pow}{1,2} = 'Neuron 2';
        dataTable{seriesRow,15}{pow}{1,3} = 'jPSTH'; 
        dataTable{seriesRow,15}{pow}{1,4} = 'Coincidence'; 
        dataTable{seriesRow,15}{pow}{1,5} = 'Cross-Correlogram';
        
        increment = 2;  % Row of output to write data to
        
        % Step through each channel
        for chan = 1:nchan
            
            % Step through each neuron for the current channel
            for neuron = 1:neuron_list(chan)
                data1 = binned{chan}{neuron}{pow};   % store first neuron binned data
                n = neuron;  % set the second data neuron counter
                c = chan;    % set the second data channel counter
                flag = 0;    % initialize the reset flag
                
                % While the second neuron does not exceed all neurons
                while flag == 0
                    % Increment n if there are more neurons on the channel
                    if n < neuron_list(c)
                        n = n + 1;
                    % Reset n and increment channel if number of neurons in
                    % previous channel was exceeded
                    elseif c < nchan
                        n = 1;
                        c = c + 1;
                    % Otherwise set the flag because all neurons were
                    % compared to the one stored in data1
                    else
                        flag = 1;
                    end
                    
                    if flag ~= 1
                        %% Calcualte the jPSTH
                        data2 = binned{c}{n}{pow}; % store second neuron binned data
                        
                        % If the 2 neurons being compared have different
                        % numbers of trials, set ntrials to the lowest
                        ntrials = size(data1,1);
                        if ntrials >= size(data2,1)
                            ntrials = size(data2,1);
                        end
                        
                        % Store the PSTHs for the 2 neurons being compared
                        PSTH1 = dataTable{seriesRow,12}{chan}{neuron}(pow,:);
                        PSTH2 = dataTable{seriesRow,12}{c}{n}(pow,:);
                        norm = std(PSTH1,1)*std(PSTH2,1);   % Normalization via population STD
                        outerP = PSTH1'*PSTH2;              % Outer product
                        jPSTH_raw = (data1'*data2)/ntrials; % Raw jPSTH
                        
                        % Shift Predictor
                        jPSTH = jPSTH_raw;%(jPSTH_raw - outerP)/norm;

                        %% Calculate the Coincidence
                        coincidence_diag = diag(jPSTH); % Central major diagonal
                        % Average the three most central diagonals,
                        % dropping the last point of the central diagonal
                        coincidence = (coincidence_diag(1:end-1)+diag(jPSTH,1)+diag(jPSTH,-1))/3;
                        % Use a gaussian filter to smooth the output
                        coincidence = gaussfilt(0:nbins,coincidence',sigma);

                        %% Calculate the Cross-Correlogram
                        jPSTH_norm_flip = flip(jPSTH); % flip the jPSTH
                        cross_corr = zeros(1,2*nbins-1); % Initialize cross-correlogram array
                        
                        % Sum paradiagonals (opposite to coincidence
                        % diagonals), leaving a spot in the middle for the
                        % major paradiagonal
                        for i = 1:nbins/2
                            left = diag(jPSTH_norm_flip,i);
                            cross_corr(nbins-i) = mean(left);
                            right = diag(jPSTH_norm_flip,-i);
                            cross_corr(nbins+i) = mean(right);
                        end
                        % Add the major paradiagonal to the array
                        cross_corr(nbins) = sum(diag(jPSTH_norm_flip))/nbins;
                        
                        % Bin the crosscorrelogram into the specified
                        % number of bins
                        cross_corr_binned = zeros(1,floor(length(cross_corr)/CCbins));
                        for i = 0:length(cross_corr_binned)-1
                            cross_corr_binned(i+1) = sum(cross_corr(i*CCbins+1:i*CCbins+CCbins))/(CCbins);
                        end
                        
                        % Use a gaussian filter to smooth the output
                        cross_corr = gaussfilt(1:length(cross_corr_binned),cross_corr_binned',sigma)';

                        %% Write the Output
                        % Write neurons being compared and their resutls to
                        % the output cell
                        dataTable{seriesRow,15}{pow}{increment,1} = chan+"."+neuron;
                        dataTable{seriesRow,15}{pow}{increment,2} = c+"."+n;
                        dataTable{seriesRow,15}{pow}{increment,3} = jPSTH; 
                        dataTable{seriesRow,15}{pow}{increment,4} = coincidence; 
                        dataTable{seriesRow,15}{pow}{increment,5} = cross_corr;

                        increment = increment + 1; % Increment row of output to write data to
                    end
                end
            end
        end
    end
end

%% Plot Something
% figure(1)
% 
% % User Define what to plot
% power_level = 1;
% row = 2; 
% 
% neuron1 = dataTable{seriesRow,15}{power_level}{row,1};
% neuron2 = dataTable{seriesRow,15}{power_level}{row,2};
% jPSTH_to_plot = dataTable{seriesRow,15}{power_level}{row,3};
% coincidence_to_plot = dataTable{seriesRow,15}{power_level}{row,4};
% cross_corr_to_plot = dataTable{seriesRow,15}{power_level}{row,5};
% neuron1_num = strsplit(neuron1,'.');
% neuron2_num = strsplit(neuron2,'.');
% PSTH1_to_plot = dataTable{seriesRow,12}{str2num(neuron1_num(1))}{str2num(neuron1_num(2))}(power_level,:);
% PSTH1_to_plot = dataTable{seriesRow,12}{str2num(neuron2_num(1))}{str2num(neuron2_num(2))}(power_level,:);
% 
% jPSTH_plot(jPSTH_to_plot,PSTH1,PSTH2,coincidence_to_plot,cross_corr_to_plot,'jPSTH',neuron1,neuron2);

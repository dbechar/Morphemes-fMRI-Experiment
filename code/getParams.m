function [params] = getParams(window, trialList)

%% INITIAL params
params.nTrials = height(trialList); % number of trials per block
params.nBlocks = 2; % number of blocks per condition
params.nBlocksTotal = 4 % total number of blocks

%% TIMING params
params.firstFixationDuration = 0.3; % duration of first fixation cross
params.firstDuration = 0.6; % duration of first word presentation
params.secondFixationDuration = 0.3 + 0.4 * rand(); % duration of second fixation cross between 300 and 700 ms
params.secondDuration = 1; % duration of the second word presentation
params.blankScreen = 3.0 - (params.firstFixationDuration + params.firstDuration + params.secondFixationDuration + params.secondDuration);
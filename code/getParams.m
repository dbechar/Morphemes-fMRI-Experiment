function [params] = getParams(window, trialList)

%% INITIAL params
params.nTrials = height(trialList); % number of trials per block
params.nBlocks = 2; % number of blocks per condition
params.nBlocksTotal = 4 % total number of blocks

%% TIMING params
params.FixationDuration = 0.4; % duration of first fixation cross
params.firstDuration = 0.6; % duration of first word presentation
params.maskDuration = 0.5 % duration of the mask
params.secondDuration = 1; % duration of the second word presentation
params.blankScreen = 3.0 - (params.FixationDuration + params.firstDuration + params.maskDuration + params.secondDuration);
function [params] = getParams(window, trialList)

%% INITIAL params
params.nTrials = height(trialList); % total number of trials in triallist
params.nBlocks = 2; % number of blocks
params.nTrialsPerBlock = ceil(params.nTrials/params.nBlocks); % number of trials per block

%% TIMING params
params.firstFixationDuration = 0.3; % duration of first fixation cross
params.firstDuration = 0.6; % duration of first word presentation
params.secondFixationDuration = 0.2 + 0.4 * rand(); % duration of second fixation cross between 200 and 600 ms
params.secondDuration = 1.0; % duration of the second word presentation
params.blankScreen = 2.5 - (params.firstFixationDuration + params.firstDuration + params.secondFixationDuration + params.secondDuration);
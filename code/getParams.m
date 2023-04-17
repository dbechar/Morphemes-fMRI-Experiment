function [params] = getParams(trialList)

%% get device index
params.deviceIndex = getdeviceIndex();

%% INITIAL params
params.nTrials = height(trialList); % total number of trials in triallist
params.nBlocks = 2; % number of blocks
params.nTrialsPerBlock = params.nTrials/params.nBlocks; % number of trials per block

%% TEXT params
params.font_size = 30; % Fontsize for words presented at the screen center

%% TIMING params
params.firstFixationDuration = 0.2; % duration of first fixation cross
params.firstDuration = 0.6; % duration of first word presentation
params.secondFixationDuration = 0.2 + 0.2 * rand(); % duration of second fixation cross between 200 and 400 ms
params.secondDuration = 0.8; % duration of the second word presentation
params.blankScreen = 2 - (params.firstFixationDuration + params.firstDuration + params.secondFixationDuration + params.secondDuration);
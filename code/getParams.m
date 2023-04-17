function [params] = getParams()

%% INITIAL params
params.nTrials = 10; % total number of trials
params.nTrialsPerBlock = 5; % number of trials per block
params.nBlocks = 2; % at the end the total number of trials should be divided by 5 

%% TEXT params
params.font_size = 30; % Fontsize for words presented at the screen center

%% TIMING params
params.firstFixationDuration = 0.3; % duration of first fixation cross
params.wordDuration = 0.6; % duration of first and second word presentation
params.secondFixationDuration = 0.2 + 0.5 * rand(); % duration of second fixation cross between 200 and 500 ms
params.blankScreen = 2 - (params.firstFixationDuration + 2 * params.wordDuration + params.secondFixationDuration);
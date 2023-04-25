function [params] = getParams(window, trialList)

%% INITIAL params
params.nTrials = height(trialList); % total number of trials in triallist
params.nBlocks = 2; % number of blocks
params.nTrialsPerBlock = ceil(params.nTrials/params.nBlocks); % number of trials per block

%% TEXT params
params.font_size = 30; % Fontsize for words presented at the screen center
%params.font1 = Screen('TextFont', window, 'Arial');
%params.font2 = Screen('TextFont', window, 'Comic Sans MS');

%% TIMING params
params.firstFixationDuration = 0.4; % duration of first fixation cross
params.firstDuration = 1.0; % duration of first word presentation
params.secondFixationDuration = 0.2 + 0.4 * rand(); % duration of second fixation cross between 200 and 600 ms
params.secondDuration = 1.0; % duration of the second word presentation
params.blankScreen = 3 - (params.firstFixationDuration + params.firstDuration + params.secondFixationDuration + params.secondDuration);
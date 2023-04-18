%% MAIN SCRIPT 
clear all; close all; clc

%% initialization
cd(fileparts(mfilename('fullpath')));
KbName('UnifyKeyNames')
addpath(fullfile('..','functions'));

% Running on PTB-3? Abort otherwise.
AssertOpenGL;

%% collect subject info (what other information?)
subjectNumber = input('Please enter subject number: '); % prompt the user to enter subject number

%% randomly choose the correct key (f or j)
responseKeys = {'f', 'j'};
correctKeyIndex = randi(2);
correctKey = responseKeys{correctKeyIndex};
differentKey = setdiff(responseKeys, correctKey);

%% set up the screen and some initial variables
Screen('Preference', 'SkipSyncTests', 1); 
[window, rect] = Screen('OpenWindow', 0); % open a window on the primary monitor

% load stimuli and log
fileName = [sprintf('../triallists/%d.csv', subjectNumber)]; % construct filename based on subject number
trialList = readtable(fullfile('../triallists', fileName));
fid_log = createLogFile(subjectNumber); % open log

%% get params
[params] = getParams(trialList);

%% start experiment
% loop over trials and blocks
try  
    % randomize the order of trials
    trialOrder = randperm(height(trialList));
    trialList = trialList(trialOrder, :);
    KbStrokeWait;
    KbQueueCreate(params.deviceIndex);
    KbQueueStart (params.deviceIndex);
    HideCursor()
    presentIntroSlide(window, params, correctKey, differentKey);
    nCorrect = 0; % set the number of correct responses to 0
    for i = 1:params.nTrials
        % determine whether this is the last trial in a block
        blockNumber = ceil(i/params.nTrialsPerBlock);
        isLastTrialInBlock = (mod(i, params.nTrialsPerBlock) == 0) || (i == params.nTrials);
        
        % get the current trial information
        first = trialList.first(i);
        second = trialList.second(i);
        is_error = trialList.is_error(i);
        
        % initialize run_starttime
        run_starttime = GetSecs();

        %% get trigger from scanner
        % receiveTrigger('t', 'ESCAPE');

        % present fixation cross
        Screen('TextSize', window, params.font_size);
        Screen('FillRect', window, 128);
        DrawFormattedText(window, '+', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.firstFixationDuration);
        
        % present first word
        firstChar = first{1};
        DrawFormattedText(window, firstChar, 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.firstDuration);
        
        % present second fixation cross (jittered presentation)
        DrawFormattedText(window, '+', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.secondFixationDuration);

        % present second word
        %secondWordStart = GetSecs();
        secondChar = second{1};
        DrawFormattedText(window, secondChar, 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.secondDuration);

        % get response and check if it's correct
        %while GetSecs < secondWordStart + params.secondDuration + params.blankScreen
        [keyCode, correct, nCorrect, rt] = waitForKeyPress(correctKey, differentKey, is_error, nCorrect, run_starttime);
        %end 

        % blank screen until trial length = 2s
        Screen('FillRect', window, 128);
        DrawFormattedText(window, ' ', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.blankScreen);

        fprintf(fid_log, '%s,%s,%d,%s,%s,%d,%f,%s,%s,%s,%s,%s,%d,%s,%d,%d,%s,%s\n', ...
                first{1}, second{1}, is_error, correctKey, KbName(keyCode), correct, rt, ...
                trialList.condition{i}, trialList.prefixes{i}, trialList.root{i}, ...
                trialList.suffixes{i}, trialList.target_type{i}, trialList.wordlength(i),...
                trialList.error_to_which_morpheme{i}, trialList.i_morpheme(i), trialList.i_within_morpheme(i),...
                trialList.target_letter_before_error{i}, trialList.letter_after_error{i});        

        % show feedback after every block
        presentFeedbackMsg (window, isLastTrialInBlock, blockNumber, nCorrect, params)
        
        if isLastTrialInBlock
        nCorrect = 0;
        end

        if i == params.nTrials
            fclose(fid_log);
        end
    end
catch
    sca
    psychrethrow(psychlasterror);
    KbQueueRelease;
    fprintf('Error occured\n')
end

%% close all - end experiment
fprintf('Done\n')
KbQueueRelease;
sca
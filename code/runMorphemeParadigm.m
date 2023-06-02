%% MAIN SCRIPT 
clear all; close all; clc

%% initialization
language = 'english'; % pulls different triallists depending on language
cd(fileparts(mfilename('fullpath')));
KbName('UnifyKeyNames')
addpath(fullfile('..','functions'));
deviceIndex = getdeviceIndex();

% Running on PTB-3? Abort otherwise.
AssertOpenGL;

%% collect subject info
subjectNumber = input('Please enter subject number (0 - 20): '); % prompt the user to enter subject number
blockNumber = input ('Please enter block number (1, 2, 3, or 4): '); % prompt the user to enter block number

%% choose the correct key (b or y) based on subject number 
responseKeys = {'b', 'y'};

if mod(subjectNumber, 2) == 0
    correctKey = 'b';
    differentKey = 'y';
else
    correctKey = 'y';
    differentKey = 'b';
end

%% set up the screen and some initial variables
Screen('Preference', 'SkipSyncTests', 1); 
%[window, rect] = Screen('OpenWindow', 1); % CENIR open a window on the primary monitor
[window, rect] = Screen('OpenWindow', 0); % open a window on the primary monitor
Screen('TextFont', window, 'Arial');

%% load stimuli and log
path =   [sprintf('../triallists/%s/%d.csv', language, subjectNumber)]; % construct filename based on language and subject number
fullTrialList = readtable(path);

blockName = sprintf('block%d', blockNumber); % Construct the block name string
trialList = fullTrialList(strcmp(fullTrialList.block, blockName), :); % Filter the trials based on the block number

% Load the mask image
mask = imread('../mask.jpg');
texture = Screen('MakeTexture', window, mask);

%% start experiment
% loop over all trials of block
try  
    KbQueueCreate(deviceIndex);
    KbQueueStart (deviceIndex);
    HideCursor()
    [params] = getParams(window, trialList); % get params

    % present intro slide
    presentIntroSlide(window, correctKey, differentKey, responseKeys, blockNumber);

    nCorrect = 0; % set the number of correct responses to 0
    fid_log = createLogFile(subjectNumber, blockNumber); % open log
    
    % get trigger from scanner
    experimentStart = receiveTrigger('t', 'ESCAPE', window);

    for i = 1:params.nTrials
        % determine whether this is the last trial in a block
        isFirstTrialInBlock = mod(i-1, params.nTrials) == 0;
        isLastTrialInBlock = (i == params.nTrials);

        % get the current trial information
        first = trialList.first(i);
        second = trialList.second(i);
        is_error = trialList.is_error(i);

        % present fixation cross
        FixationOnset = GetSecs - experimentStart;
        Screen('FillRect', window, 128);
        Screen('TextSize', window, 40);
        DrawFormattedText(window, '+', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.FixationDuration);
        fprintf(fid_log, '%s,%f,%d,%d\n', 'firstFixation', FixationOnset, blockNumber, i);

        % present first word
        firstWordOnset = GetSecs() - experimentStart;
        firstChar = first{1};
        DrawFormattedText(window, firstChar, 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.firstDuration);
        fprintf(fid_log, '%s,%f,%d,%d\n', 'firstWord', firstWordOnset, blockNumber, i);
        
        % present mask (jittered presentation)
        maskOnset = GetSecs() - experimentStart;
        Screen('DrawTexture', window, texture, [], [], 0);
        Screen('Flip', window);
        WaitSecs(params.maskDuration);
        fprintf(fid_log, '%s,%f,%d,%d,%s\n', 'mask', maskOnset, blockNumber, i, first{1});

        % present second word
        secondWordOnset = GetSecs() - experimentStart;
        secondChar = upper(second{1});
        Screen('TextFont', window, 'Times New Roman');
        Screen('TextStyle', window, 2); % set the text style to cursive
        DrawFormattedText(window, secondChar, 'center', 'center', 0);
        Screen('Flip', window);

        % get response and check if it's correct
        [keyName, correct, nCorrect, rt] = waitForKeyPress(correctKey, differentKey, is_error, nCorrect, params, secondWordOnset, experimentStart);
        
        WaitSecs(params.secondDuration);
        Screen('TextStyle', window, 0); % reset the text style to normal
        Screen('TextFont', window, 'Arial'); % reset font to Arial

        fprintf(fid_log, '%s,%f,%d,%d,%s,%s,%d,%s,%s,%d,%f,%s,%s,%s,%s,%s,%d,%s,%d,%d,%s,%s,%s,%s\n', ...
                'secondWord', secondWordOnset, blockNumber, i, first{1}, second{1}, is_error, correctKey, keyName, correct, rt, ...
                trialList.condition{i}, trialList.prefixes{i}, trialList.root{i}, ...
                trialList.suffixes{i}, trialList.target_type{i}, trialList.wordlength(i),...
                trialList.error_to_which_morpheme{i}, trialList.i_morpheme(i), trialList.i_within_morpheme(i),...
                trialList.target_letter_before_error{i}, trialList.letter_after_error{i}, ...
                trialList.error_word{i}, trialList.type{i});        
        
        % blank screen until trial length = 2s
        blankScreenOnset = GetSecs() - experimentStart;
        Screen('FillRect', window, 128);
        DrawFormattedText(window, ' ', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.blankScreen);
        fprintf(fid_log, '%s,%f,%d,%d\n', 'blankScreen', blankScreenOnset, blockNumber, i);

        % show feedback after every block
        presentFeedbackMsg (window, isLastTrialInBlock, blockNumber, nCorrect, params)
        
        if isLastTrialInBlock
            nCorrect = 0;
            blockEndOnset = GetSecs () - experimentStart;
            fprintf(fid_log, '%s,%f,%d,%d\n', 'blockEnd', blockEndOnset, blockNumber, i);
            fprintf('Block %d finished\n', blockNumber)
        end

        if i == params.nTrials
            fclose(fid_log);
            fprintf('Data is saved correctly\n')
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
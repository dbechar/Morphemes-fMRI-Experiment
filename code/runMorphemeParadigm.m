%% MAIN SCRIPT 
clear all; close all; clc

%% initialization
cd(fileparts(mfilename('fullpath')));
KbName('UnifyKeyNames')
addpath(fullfile('..','functions'));
[params] = getParams();

% Running on PTB-3? Abort otherwise.
AssertOpenGL;

%% collect subject info (what other information?)
subjectNumber = input('Please enter subject number: '); % prompt the user to enter subject number

dataDir = '../triallists/'; % directory where the triallists are stored
fileName = [num2str(subjectNumber) '.csv']; % construct the filename based on subject number

%% randomly choose the correct key 
responseKeys = {'f', 'j'};
correctKeyIndex = randi(2);
correctKey = responseKeys{correctKeyIndex};
differentKey = setdiff(responseKeys, correctKey);

%% set up the screen and some initial variables
Screen('Preference', 'SkipSyncTests', 0); % should I skip screen test?
[window, rect] = Screen('OpenWindow', 0); % open a window on the primary monitor (1 if on another window)

% load stimuli and log
trialList = readtable(fullfile(dataDir, fileName));
fid_log = createLogFile(subjectNumber); % OPEN LOG

%% start experiment
% loop over trials and blocks
try  
    % randomize the order of trials
    trialOrder = randperm(height(trialList));
    trialList = trialList(trialOrder, :);
    KbStrokeWait;
    %KbQueueStart;
    presentIntroSlide(window, params, correctKey, differentKey);
    nCorrect = 0; % set the number of correct responses to 0
    for i = 1:params.nTrials
        % determine whether this is the last trial in a block
        blockNumber = ceil(i/params.nTrialsPerBlock);
        isLastTrialInBlock = (mod(i, params.nTrialsPerBlock) == 0) || (i == params.nTrials);
        
        % get the current trial information
        first = trialList.first(i);
        second = trialList.second(i);
        is_error = trialList.is_error(i) == 0;
        
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
        WaitSecs(params.wordDuration);
        
        % present second fixation cross (jittered presentation)
        DrawFormattedText(window, '+', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.secondFixationDuration);
        
        % present second word
        secondChar = second{1};
        DrawFormattedText(window, secondChar, 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.wordDuration);

        % get response and check if it's correct
        [keyCode, correct, rt] = waitForKeyPress (correctKey, is_error, nCorrect, run_starttime);

        % blank screen until trial length = 2s
        Screen('FillRect', window, 128);
        DrawFormattedText(window, ' ', 'center', 'center', 0);
        Screen('Flip', window);
        WaitSecs(params.blankScreen);

        % get response and check if it's correct
        %[keyCode, correct, rt] = waitForKeyPress (correctKey, is_error, nCorrect, run_starttime);

        fprintf(fid_log, '%s,%s,%d,%s,%s,%d,%f\n', first{1}, second{1}, is_error, correctKey, KbName(keyCode), correct, rt);        

        % show feedback after every block
        if isLastTrialInBlock
            if blockNumber == params.nBlocks % check if this is the last block
                feedbackMsg = sprintf ('You got %d out of %d correct! This was the last block.', nCorrect, params.nTrialsPerBlock);
            else
                feedbackMsg = sprintf('You got %d out of %d correct! Press spacebar to continue.', nCorrect, params.nTrialsPerBlock);
            end
            DrawFormattedText(window, feedbackMsg, 'center', 'center', 0);
            Screen('Flip', window);
            while 1 % wait for spacebar press
                [keyIsDown, ~, keyCode] = KbCheck();
                if keyIsDown && keyCode(KbName('space'))
                    break;
                end
                WaitSecs(0.01);
            end
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
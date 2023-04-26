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

%% collect subject info (what other information?)
subjectNumber = input('Please enter subject number: '); % prompt the user to enter subject number

%% randomly choose the correct key (b or y)
responseKeys = {'b', 'y'};
correctKeyIndex = randi(2);
correctKey = responseKeys{correctKeyIndex};
differentKey = setdiff(responseKeys, correctKey);

%% set up the screen and some initial variables
Screen('Preference', 'SkipSyncTests', 0); 
[window, rect] = Screen('OpenWindow', 0); % open a window on the primary monitor
%[window, rect] = Screen('OpenWindow', 1); % open a window on the primary monitor
Screen('TextFont', window, 'Arial');

% load stimuli and log
pseudoFileName = [sprintf('../triallists/%s_pseudo/%d.csv', language, subjectNumber)]; % construct filename based on subject number and language
realFileName = [sprintf('../triallists/%s_real/%d.csv', language, subjectNumber)];
trialLists = {readtable(fullfile('../triallists', pseudoFileName)), readtable(fullfile('../triallists', realFileName))};

%% start experiment
% loop over trials and blocks
try  
    KbQueueCreate(deviceIndex);
    KbQueueStart (deviceIndex);
    HideCursor()
    presentIntroSlide(window, correctKey, differentKey, responseKeys);
    nCorrect = 0; % set the number of correct responses to 0
    fid_log = createLogFile(subjectNumber); % open log
    
    % get trigger from scanner
    experimentStart = receiveTrigger('t', 'ESCAPE', window);
    
    %% randomly choose the order of the trial lists
    trialListOrder = randperm(2);
    bigBlockCount = 0;

    % iterate over the triallists (randomly chose which one is shown first)
    for t = trialListOrder
        trialList = trialLists{t};
        trialOrder = randperm(height(trialList)); % randomize the order of trials
        trialList = trialList(trialOrder, :);
        bigBlockCount = bigBlockCount+1;
            
        %% get params
        [params] = getParams(window, trialList);

        for i = 1:params.nTrials
            % determine whether this is the last trial in a block
            blockNumber = ceil(i/params.nTrialsPerBlock);
            isLastTrialInBlock = (mod(i, params.nTrialsPerBlock) == 0) || (i == params.nTrials);

            % get the current trial information
            first = trialList.first(i);
            second = trialList.second(i);
            is_error = trialList.is_error(i);
    
            % present fixation cross
            firstFixationOnset = GetSecs - experimentStart;
            Screen('FillRect', window, 128);
            Screen('TextSize', window, 40);
            DrawFormattedText(window, '+', 'center', 'center', 0);
            Screen('Flip', window);
            WaitSecs(params.firstFixationDuration);
            fprintf(fid_log, '%s,%f,%d,%d,%d\n', 'firstFixation', firstFixationOnset, t, blockNumber, i);

            % present first word
            firstWordOnset = GetSecs() - experimentStart;
            firstChar = first{1};
            DrawFormattedText(window, firstChar, 'center', 'center', 0);
            Screen('Flip', window);
            WaitSecs(params.firstDuration);
            fprintf(fid_log, '%s,%f,%d,%d,%d\n', 'firstWord', firstWordOnset, t, blockNumber, i);
            
            % present second fixation cross (jittered presentation)
            secondFixationOnset = GetSecs() - experimentStart;
            DrawFormattedText(window, '+', 'center', 'center', 0);
            Screen('Flip', window);
            WaitSecs(params.secondFixationDuration);
            fprintf(fid_log, '%s,%f,%d,%d,%d\n', 'secondFixation', secondFixationOnset, t, blockNumber, i);
    
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
    
            fprintf(fid_log, '%s,%f,%d,%d,%d,%s,%s,%d,%s,%s,%d,%f,%s,%s,%s,%s,%s,%d,%s,%d,%d,%s,%s\n', ...
                    'secondWord', secondWordOnset, t, blockNumber, i, first{1}, second{1}, is_error, correctKey, keyName, correct, rt, ...
                    trialList.condition{i}, trialList.prefixes{i}, trialList.root{i}, ...
                    trialList.suffixes{i}, trialList.target_type{i}, trialList.wordlength(i),...
                    trialList.error_to_which_morpheme{i}, trialList.i_morpheme(i), trialList.i_within_morpheme(i),...
                    trialList.target_letter_before_error{i}, trialList.letter_after_error{i});        
            
            % blank screen until trial length = 2s
            Screen('FillRect', window, 128);
            DrawFormattedText(window, ' ', 'center', 'center', 0);
            Screen('Flip', window);
            WaitSecs(params.blankScreen);

            % show feedback after every block
            presentFeedbackMsg (window, isLastTrialInBlock, blockNumber, nCorrect, params, bigBlockCount)
            
            if isLastTrialInBlock
            nCorrect = 0;
            fprintf('Block %d finished\n', blockNumber)
            end
    
            if i == params.nTrials && bigBlockCount == 2
                fclose(fid_log);
                fprintf('Data is saved correctly\n')
            end
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
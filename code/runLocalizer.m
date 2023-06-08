%% LOCALIZER SCRIPT 
clear all; close all; clc

%% initialization
cd(fileparts(mfilename('fullpath')));
KbName('UnifyKeyNames')
addpath(fullfile('..','functions'));
deviceIndex = getdeviceIndex();

% Running on PTB-3? Abort otherwise.
AssertOpenGL;

%% collect subject info
subjectNumber = input('Please enter subject number (0 - 20): '); % prompt the user to enter subject number
localizer = input('Please enter which localizer should be played (word or number): ', 's');  % Specify 's' to treat the input as a string

%% set up the screen and some initial variables
Screen('Preference', 'SkipSyncTests', 1); 
%[window, rect] = Screen('OpenWindow', 1); % CENIR open a window on the primary monitor
[window, rect] = Screen('OpenWindow', 0); % open a window on the primary monitor
Screen('TextFont', window, 'Arial');

%% load localizer file
path =   [sprintf('../triallists/%s_localizer.csv', localizer)]; % construct filename based on localizer
trialList = readtable(path);

try
    KbQueueCreate(deviceIndex);
    KbQueueStart(deviceIndex);
    HideCursor();
    [params] = getParams(window, trialList); % get params
    
    % set font, font size, and color
    %% OR SHOULD I INCLUDE INTRO SCREEN
    Screen('TextFont', window, 'Arial');
    Screen('TextSize', window, 45);
    Screen('FillRect', window, 128); 

    fid_log = createLocalizerLogFile(subjectNumber, localizer); % open log

    % get trigger from scanner
    experimentStart = receiveTrigger('t', 'ESCAPE', window);

    %% Show each item without a pause between
    for i = 1:height(trialList)
        item = trialList(i, :);
        value = item{1, 1}; % Get the value from the first column

        eventOnset = GetSecs() - experimentStart;

        if ischar(value) % If it's a string, words localizer
            DrawFormattedText(window, value, 'center', 'center', 0);
            fprintf(fid_log, '%s,%f,%d,%d,%s,%s,\n', 'localizer', eventOnset, i, value, 'word');
        else 
            DrawFormattedText(window, num2str(value), 'center', 'center', 0);
            fprintf(fid_log, '%s,%f,%d,%s,%s,\n', 'localizer', eventOnset, i, num2str(value), 'number');
        end
        Screen('Flip', window); 
        WaitSecs(params.locDuration); % Wait for the duration of the 

        % Check if escape key is pressed
        [keyIsPressed, ~, keyCode] = KbQueueCheck(deviceIndex);
        if keyIsPressed && keyCode(KbName('ESCAPE'))
            error('Escape key pressed. Experiment terminated by user.');
        end

        if i == height(trialList)
            fclose(fid_log);
            fprintf('Data is saved correctly\n')
        end
    end
catch
    sca;
    psychrethrow(psychlasterror);
    KbQueueRelease;
    fprintf('Error occurred\n');
end

%% close all - end localizer script
fprintf('Done\n');
KbQueueRelease;
sca;

function [keyCode, correct, nCorrect, rt] = waitForKeyPress(correctKey, differentKey, is_error, nCorrect, run_starttime)

if ~nargin
    correctKey = [];
end

% initialize variables
correct = 0;

% get response and check if it's correct
while 1
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown
        rt = (secs - run_starttime); % calculate reaction time
        keyName = KbName(keyCode);
        if strcmp(keyName, correctKey) && is_error == 0 % check if the key pressed is correct and there is no error
            correct = 1;
            nCorrect = nCorrect + 1;
        elseif strcmp(keyName, differentKey) && is_error == 1 % check if the key pressed is different and there is an error
            correct = 1;
            nCorrect = nCorrect + 1;
        elseif strcmp(keyName, correctKey) && is_error == 1 % check if the key pressed is correct and there is an error
            correct = 0;
        elseif strcmp(keyName, differentKey) && is_error == 0 % check if the key pressed is different and there is no error
            correct = 0;
        elseif strcmp(keyName, 'ESCAPE') % check for escape key
            error('Escape key pressed. Experiment terminated by user.');
        else % ignore all other keys
            continue;
        end
        break; % exit loop once a key has been pressed
    end
end

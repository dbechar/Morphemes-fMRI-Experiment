function [keyName, correct, nCorrect, rt] = waitForKeyPress(correctKey, differentKey, is_error, nCorrect, params, secondWordOnset, experimentStart)

if ~nargin
    correctKey = [];
end

% initialize variables
correct = 0;
keyName = NaN;
rt = NaN;
responded = 0;

% get response and check if it's correct
while GetSecs() - experimentStart < secondWordOnset + params.secondDuration
    if ~responded % only check for key response if it hasn't been given already
        [keyIsDown, secs, keyCode] = KbCheck();
        if keyIsDown
            rt = ((secs - experimentStart) - secondWordOnset); % calculate reaction time
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
            fprintf('key response given\n')
            responded = 1; % mark that a response has been given
        else
            % fprintf ('no response given\n')
        end
    end
end
end

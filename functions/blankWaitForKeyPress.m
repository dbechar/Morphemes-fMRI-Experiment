function [keyName, correct, nCorrect, rt] = blankWaitForKeyPress(correctKey, differentKey, is_error, nCorrect, params, secondWordOnset, experimentStart, blankScreenOnset)

if ~nargin
    correctKey = [];
end

% initialize variables
correct = 0;
keyName = NaN;
rt = NaN;
responded = 0;

% get response and check if it's correct
while GetSecs() - experimentStart < blankScreenOnset + params.blankScreen
    if ~responded % only check for key response if it hasn't been given already
        [keyIsDown, secs, keyCode] = KbCheck();
        if keyIsDown
            rt = ((secs - experimentStart) - secondWordOnset); % calculate reaction time
            keyName = KbName(keyCode);
            if strcmp(keyName, correctKey) && (is_error == 0 || is_error == 2)  % check if the key pressed is correct and there is no error
                correct = 1;
                nCorrect = nCorrect + 1;
            elseif strcmp(keyName, differentKey) && (is_error == 1 || is_error == 3) % check if the key pressed is different and there is an error
                correct = 1;
                nCorrect = nCorrect + 1;
            elseif strcmp(keyName, correctKey) && (is_error == 1 || is_error == 3) % check if the key pressed is correct and there is an error
                correct = 0;
            elseif strcmp(keyName, differentKey) && (is_error == 0 || is_error == 2) % check if the key pressed is different and there is no error
                correct = 0;
            elseif strcmp(keyName, 'ESCAPE') % check for escape key
                error('Escape key pressed. Experiment terminated by user.');
            else % ignore all other keys
                continue;
            end
            fprintf('key response given\n')
            responded = 1; % mark that a response has been given
        else
        end
    end
end
end

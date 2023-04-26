function scanner_starttime = receiveTrigger(trigger, escapeKey, window)

text = sprintf('Waiting for the MRI signal');

% display text
DrawFormattedText(window, text, 'center', 'center', 0);
Screen('Flip', window);

% wait for the scanner trigger to start trial
fprintf('Waiting for the trigger... \n')
% Set the default values of the input arguments if they're not provided.
if nargin < 1
    trigger = 't';
end
if nargin < 2
    escapeKey = 'ESCAPE';
end

key_trigger = KbName(trigger);
key_escape  = KbName(escapeKey);

% wait for the trigger or escape key to be pressed.
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(key_trigger)
            scanner_starttime = secs; % Start the experiment.
            break;
        elseif keyCode(key_escape)
            Priority(0);
            sca();
            error('Escape key pressed. Experiment terminated by user.');
        end
    end
end

fprintf('Trigger received! \n')
% Wait for a short duration to avoid KbCheck detecting the trigger key.
% WaitSecs(0.5);

end
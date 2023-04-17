function receive_trigger(trigger, escapeKey)
%% adapted from a script by Annahita Sarré
% wait for the scanner trigger to start trial
fprintf('### Waiting for the trigger... \n')
% Set the default values of the input arguments if they're not provided.
if nargin < 1
    trigger = 't';
end
if nargin < 2
    escapeKey = 'ESCAPE';
end

% wait for the trigger or escape key to be pressed.
TTL = 0;
keyIsDown = 0;
while TTL == 0
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if strcmp(KbName(keyCode), trigger) == 1
            TTL = 1; % Start the experiment.
            break;
        elseif strcmp(KbName(keyCode), escapeKey) == 1
            Priority(0);
            ShowCursor;
            error('Escape key pressed. Experiment terminated by user.');
        else
            TTL = 0;
        end
    end
end

fprintf('### Trigger received \n')
% Wait for a short duration to avoid KbCheck detecting the trigger key.
WaitSecs(0.5);

end
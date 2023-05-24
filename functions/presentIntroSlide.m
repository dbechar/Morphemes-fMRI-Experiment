function present_intro_slide(window, correctKey, differentKey, responseKeys, blockNumber)

responseKeyCodes = KbName(responseKeys);

% set font, font size, and color
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 30);
Screen('FillRect', window, 128); 

% set intro text
intro_text = sprintf(['In this experiment, you will first see a letter string, for example "rekagable". You will have to memorize this string.' ...
    '\n\n The string will then disappear from the screen, and after a short delay another string will appear.' ...
    '\n\n If the two letter strings are the SAME press the %s key. If they are DIFFERENT press the %s key. ' ...
    '\n\n \n\n Please fixate on the cross and do not move your eyes.' ...
    '\n\n \n\n If you are ready to start the experiment, press a key'], char(correctKey), char(differentKey));

% display intro text (depending on which block is played intro text varies)
if blockNumber == 1
    DrawFormattedText(window, intro_text, 'center', 'center', 0);
    Screen('Flip', window);
    fprintf ('Waiting for button press by participant to start block.\n')
    while 1 % wait for keypress
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown && any(keyCode(responseKeyCodes))
            break;
        elseif keyIsDown && keyCode(KbName ('ESCAPE')) % check for escape key
            error('Escape key pressed. Experiment terminated by user.');
        end
        WaitSecs(0.1);
    end
    
else 
    presentationStart = GetSecs();
    DrawFormattedText(window, 'The next block will start in 30 seconds', 'center', 'center', 0);
    Screen('Flip', window);
    fprintf('Presenting block intro message. Block will start in 30 seconds.\n');
    
    duration = 30;  % Duration of the presentation in seconds
    escapeKeyPressed = false;
    
    while GetSecs() - presentationStart < duration
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown && keyCode(KbName('ESCAPE')) % Check for escape key
            escapeKeyPressed = true;
            break; % Exit the loop if escape key is pressed
        end
    end
    
    if escapeKeyPressed
        error('Escape key pressed. Experiment terminated by user.');
    end
end




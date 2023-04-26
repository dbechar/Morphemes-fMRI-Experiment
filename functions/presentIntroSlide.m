function present_intro_slide(window, correctKey, differentKey, responseKeys)

responseKeyCodes = KbName(responseKeys);

% set font, font size, and color
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 30);
Screen('FillRect', window, 128); 

% set intro text
intro_text = sprintf(['In this experiment, you will first see a letter string, for example "rekagable". You will have to memorize this string.' ...
    '\n\n The string will then disappear from the screen, and after a short delay another string will appear.' ...
    '\n\n If the two letter strings are the SAME press the %s key. If they are DIFFERENT press the %s key. ' ...
    '\n\n \n\n Please fixate on the cross and do not move your eyes.'], char(correctKey), char(differentKey));

% display intro text
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
end


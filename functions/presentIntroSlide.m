function present_intro_slide(window, params, correctKey, differentKey)
    % set font size and color
    Screen('TextSize', window, params.font_size);
    Screen('FillRect', window, 128); 

    % set intro text
    intro_text = sprintf('Fixate on the cross. If the two letter strings are the same press the %s key. If they are different press the %s key', char(correctKey), char(differentKey));
    
    % display intro text
    DrawFormattedText(window, intro_text, 'center', 'center', 0);
    Screen('Flip', window);
    
    % wait for spacebar keypress
    spacebar_pressed = false;
    while ~spacebar_pressed
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(KbName('space'))
            spacebar_pressed = true;
        end
    end
end
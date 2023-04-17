function presentFeedbackMsg (window, isLastTrialInBlock, blockNumber, nCorrect, params)
if isLastTrialInBlock
    if blockNumber == params.nBlocks % check if this is the last block
        feedbackMsg = sprintf (['You got %d out of %d correct! \n\n ' ...
                        ' \n\n This was the last block, congratulations on completing the experiment. ' ...
                        '\n\n Thank you for your participation!'], nCorrect, params.nTrialsPerBlock);
    else
        feedbackMsg = sprintf(['You got %d out of %d correct! \n\n ' ...
                        ' \n\n You can take a short pause now. ' ...
                        'When you are ready to continue with the next block, press the spacebar.'], ...
                        nCorrect, params.nTrialsPerBlock);
    end
    DrawFormattedText(window, feedbackMsg, 'center', 'center', 0);
    Screen('Flip', window);
    while 1 % wait for spacebar press
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown && keyCode(KbName('space'))
            break;
        elseif keyIsDown && keyCode(KbName ('ESCAPE')) % check for escape key
            error('Escape key pressed. Experiment terminated by user.');
        end
        WaitSecs(0.1);
    end
end

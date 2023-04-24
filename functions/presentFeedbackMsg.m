function presentFeedbackMsg (responseKeys, window, isLastTrialInBlock, blockNumber, nCorrect, params, t)
if isLastTrialInBlock
    if blockNumber == params.nBlocks && t == 2 % check if this is the last block of the second triallist 
        feedbackMsg = sprintf (['You got %d out of %d correct! \n\n ' ...
                        ' \n\n This was the last block, congratulations on completing the experiment. ' ...
                        '\n\n Thank you for your participation!'], nCorrect, params.nTrialsPerBlock);
    else
        feedbackMsg = sprintf(['You got %d out of %d correct! \n\n ' ...
                        ' \n\n You can take a short pause now. ' ...
                        'When you are ready to continue with the next block, press a button.'], ...
                        nCorrect, params.nTrialsPerBlock);
    end
    DrawFormattedText(window, feedbackMsg, 'center', 'center', 0);
    Screen('Flip', window);
    while 1 % wait for keypress
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown && any(keyCode(responseKeys))
            break;
        elseif keyIsDown && keyCode(KbName ('ESCAPE')) % check for escape key
            error('Escape key pressed. Experiment terminated by user.');
        end
        WaitSecs(0.1);
    end
end

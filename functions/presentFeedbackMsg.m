function presentFeedbackMsg (window, isLastTrialInBlock, blockNumber, nCorrect, params)

if isLastTrialInBlock
    if blockNumber == params.nBlocksTotal  % check if this is the last block
        feedbackMsg = sprintf (['You got %d out of %d correct! \n\n' ...
                                '\n\n This was the last block, congratulations on completing the experiment.' ...
                                '\n\n Thank you for your participation!'], nCorrect, params.nTrialsPerBlock);
    else
        feedbackMsg = sprintf('You got %d out of %d correct! \n\n \n\n The next block will start soon. ', nCorrect, params.nTrials);
    end
    Screen('TextSize', window, 30);
    fprintf ('Presenting feedback message.\n')
    DrawFormattedText(window, feedbackMsg, 'center', 'center', 0);
    Screen('Flip', window);
    startTime = GetSecs(); % record the start time

    while (GetSecs() - startTime) < 10 % wait for 10 seconds
        [keyIsDown, ~, keyCode] = KbCheck();
        if keyIsDown && keyCode(KbName ('ESCAPE')) % check for escape key
            error('Escape key pressed. Experiment terminated by user.');
        end
    end
end
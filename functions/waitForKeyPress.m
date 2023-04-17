function [keyCode, correct, rt, nCorrect] = waitForKeyPress(correctKey, is_error, nCorrect, run_starttime)   % get response and check if it's correct
    [keyIsDown, secs, keyCode] = KbCheck();
    if keyIsDown
        if keyCode(correctKey)
            nCorrect = nCorrect + 1;
            correct = 1;
        else
            correct = 0;
        end
        rt = secs - run_starttime;
    else
    correct = NaN;
    rt = NaN;
    end
function fid_log=createLogFileMorphemeParadigm(subjectNumber)

timestamp=gettimestamp();
resultsFileName = fullfile('..', 'subject_data', ['log' timestamp '_' num2str(subjectNumber) '.csv']); % filename for results file
headers = {'eventName', 'eventOnset', 'condition','block','trial', 'first', 'second', 'is_error', ...
            'correctKey', 'responseKey', 'correct', 'rt', 'condition', ...
            'prefix', 'root', 'suffix', 'target_type', 'wordlength', 'error_to_which_morpheme',...
            'i_morpheme', 'i_within_morpheme', 'target_letter_before_error', 'letter_after_error'}; % headers for results file
fid_log = fopen(resultsFileName, 'w');
fprintf(fid_log, '%s,', headers{1:end-1});
fprintf(fid_log, '%s\n', headers{end});

end
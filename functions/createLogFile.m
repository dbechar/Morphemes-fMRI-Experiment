function fid_log=createLogFile(subjectNumber, blockNumber)

timestamp=gettimestamp();
resultsFileName = fullfile('..', 'subject_data', ['par' num2str(subjectNumber) '_block' num2str(blockNumber) '_' timestamp '.csv']); % filename for results file
headers = {'eventName', 'eventOnset','block','trial', 'first', 'second', 'is_error', ...
            'correctKey', 'responseKey', 'correct', 'rt', 'condition', ...
            'prefix', 'root', 'suffix', 'target_type', 'wordlength', 'error_to_which_morpheme',...
            'i_morpheme', 'i_within_morpheme', 'target_letter_before_error', 'letter_after_error',...
            'error_word', 'type'}; % headers for results file
fid_log = fopen(resultsFileName, 'w');
fprintf(fid_log, '%s,', headers{1:end-1});
fprintf(fid_log, '%s\n', headers{end});

end
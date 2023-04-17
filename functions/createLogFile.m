function fid_log=createLogFileMorphemeParadigm(subjectNumber)

timestamp=gettimestamp();
resultsFileName = fullfile('..', 'subject_data', ['log' timestamp '_' num2str(subjectNumber) '.csv']); % filename for results file
headers = {'first', 'second', 'is_error', 'correctKey', 'responseKey', 'correct', 'rt'}; % headers for results file
fid_log = fopen(resultsFileName, 'w');
fprintf(fid_log, '%s,', headers{1:end-1});
fprintf(fid_log, '%s\n', headers{end});

end
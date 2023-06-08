function fid_log = createLocalizerLogFile(subjectNumber, localizer)
    timestamp = gettimestamp();
    resultsFileName = fullfile('..', 'subject_data', 'localizer', ['par' num2str(subjectNumber) '_localizer_' timestamp '.csv']);
    headers = {'eventName', 'eventOnset', 'trial', 'event', 'eventType'}; % headers for results file
    fid_log = fopen(resultsFileName, 'w');
    fprintf(fid_log, '%s,', headers{1:end-1});
    fprintf(fid_log, '%s\n', headers{end});
end

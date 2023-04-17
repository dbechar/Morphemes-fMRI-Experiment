function deviceIndex = getdeviceIndex()
% Load Psychtoolbox for accessing the keyboard
PsychDefaultSetup(2);

% Get a list of all input devices connected to the computer
devices = PsychHID('Devices');

% Find the index of the keyboard device
deviceIndex = [];
for i = 1:length(devices)
    if contains(devices(i).product, 'keyboard', 'IgnoreCase', true)
        deviceIndex = devices(i).index;
        break;
    end
end

% Display the index of the keyboard device
if ~isempty(deviceIndex)
    fprintf('Keyboard index: %d\n', deviceIndex);
else
    disp('No keyboard found');
end

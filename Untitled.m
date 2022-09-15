
[FileName,PathName] = uigetfile('*.wav', 'Select audio file.');
if isequal(FileName,0) || isequal(PathName,0)
    return
end
file = fullfile(PathName,FileName);
info = audioinfo(file);
[y,fs] = audioread(file);
disp(length(y));
disp(info);
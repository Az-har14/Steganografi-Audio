close all; clear ; clc;

[FileName,PathName] = uigetfile('*.wav', 'Select audio file.');
if isequal(FileName,0) || isequal(PathName,0)
    return
end


audio.file = fullfile(PathName,FileName);
[~,audio.name] = fileparts(FileName);
[audio.data, audio.fs] = audioread(audio.file);

[FileName1,PathName1] = uigetfile('*.txt', 'Select text file.');
if isequal(FileName1,0) || isequal(PathName1,0)
    return
end

file = fullfile(PathName1,FileName1);
fid  = fopen(file, 'r');
text = fread(fid,'*char')';
fclose(fid);
save('myfile.mat','file');

out = phase_enc(audio.data, text);
audiowrite([audio.name,'_stego.wav'], out, audio.fs);

disp(['Stego signal is saved in ', PathName, audio.name, '_stego.wav']);
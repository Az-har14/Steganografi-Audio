close all; clear; clc;

[FileName,PathName] = uigetfile('*.wav', 'Select audio file.');
[audio.data, audio.fs] = audioread([PathName FileName]);

load('myfile.mat');
file1 = file;
fid  = fopen(file1, 'r');
text = fread(fid,'*char')';
fclose(fid);

msg = phase_dec(audio.data, length(text));
audio_raw = raw(audio.data,length(text));
audiowrite('test.wav',audio_raw,audio.fs);
fprintf('Text: %s\n', msg); 
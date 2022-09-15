function varargout = Hide(varargin)
% HIDE MATLAB code for Hide.fig
%      HIDE, by itself, creates a new HIDE or raises the existing
%      singleton*.
%
%      H = HIDE returns the handle to a new HIDE or the handle to
%      the existing singleton*.
%
%      HIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIDE.M with the given input arguments.
%
%      HIDE('Property','Value',...) creates a new HIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Hide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Hide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Hide

% Last Modified by GUIDE v2.5 14-May-2022 20:51:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Hide_OpeningFcn, ...
                   'gui_OutputFcn',  @Hide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before Hide is made visible.
function Hide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Hide (see VARARGIN)

% Choose default command line output for Hide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Hide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Hide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_file_Callback(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_file as text
%        str2double(get(hObject,'String')) returns contents of edit_file as a double


% --- Executes during object creation, after setting all properties.
function edit_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global file
file = 0;
save('myfile.mat','file');

% --- Executes on button press in add_btn.
function add_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
[audio.FileName,audio.PathName] = uigetfile('*.wav', 'Select audio file.');
if isequal(audio.FileName,0) || isequal(audio.PathName,0)
    audio.filea = 0;
end
audio.filea = fullfile(audio.PathName,audio.FileName);
[audio.data, audio.fs] = audioread(audio.filea);
string1 = audio.filea;

handles.edit_file.String = string1;
axes(handles.axes_carrier);
plot(audio.data);
title('Audio Carrier');
ylabel('Amplitude');
xlabel('Sample Number');

audio.a = 0;
guidata(hObject,audio);


% --- Executes on button press in rec_btn.
function rec_btn_Callback(hObject, eventdata, handles)
% hObject    handle to rec_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

audio = guidata(hObject);

    audio.Fs = 44100;%Sampling frequency in hertz
    audio.ch = 2;%Number of channels--2 options--1 (mono) or 2 (stereo)
    audio.datatype = 'uint8';
    audio.nbits = 16;%8,16,or 24
    audio.Nseconds = str2double(get(handles.edit_time,'String'));
    
if ~isempty((get(handles.edit_time,'String')))    
    % to record audio data from an input device ...
    audio.recorder = audiorecorder(audio.Fs,audio.nbits,audio.ch);
    disp('Start speaking..')
    msgbox("Record starting...","Record","help");

    %Record audio to audiorecorder object,...
    recordblocking(audio.recorder,audio.Nseconds);

    disp('End of Recording.');
    
    %Store recorded audio signal in numeric array
    audio.a = getaudiodata(audio.recorder,audio.datatype);
    fprintf('Audio has been recorded.');
    handles.edit_file.String = 'Audio has been recorded.';
    axes(handles.axes_carrier);
    plot(audio.a);
    ylabel('Amplitude');
    xlabel('Sample Number');
    audiowrite('record.wav',audio.a,audio.Fs);

    msgbox("Record ended...","Record","help");
    audio.data = 0;
else
  c = msgbox("Set the duration first!","Warning!","warn");  
end
guidata(hObject,audio);


function edit_msg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_msg as text
%        str2double(get(hObject,'String')) returns contents of edit_msg as a double


% --- Executes during object creation, after setting all properties.
function edit_msg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addtext_btn.
function addtext_btn_Callback(hObject, eventdata, handles)
% hObject    handle to addtext_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
global file text;
load('myfile.mat','file');
[audio.FileName1,audio.PathName1] = uigetfile('*.txt', 'Select text file.');
if isequal(audio.FileName1,0) || isequal(audio.PathName1,0)
    return
end
file = fullfile(audio.PathName1,audio.FileName1);
fid  = fopen(file, 'r');
text = fread(fid,'*char')';
fclose(fid);
save('myfile.mat','file','-append');
string3 = file;
handles.edit_msg.String = string3;
guidata(hObject,audio);


function psnr_edit_Callback(hObject, eventdata, handles)
% hObject    handle to psnr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of psnr_edit as text
%        str2double(get(hObject,'String')) returns contents of psnr_edit as a double


% --- Executes during object creation, after setting all properties.
function psnr_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to psnr_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play_btn.
function play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
persistent player

if isempty(player)
    if audio.data == 0
        player = audioplayer(audio.a, audio.Fs);
    else
        player = audioplayer(audio.data, audio.fs);
    end
    set(handles.play_btn,'string','Stop');
    play(player);
else
    stop(player);
    set(handles.play_btn,'string','Play');
    player = [];
end
guidata(hObject,audio);

% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
q = get(handles.edit_file,'String');
if isempty(q)
    c = msgbox("Audio Stego not found.","Warning!","warn");
else
    [audio.FileName2,audio.PathName2] = uiputfile('*.wav', 'Save audio file.');
    if isequal(audio.FileName2,0) || isequal(audio.PathName2,0)
        return
    else
        audio.carrier = fullfile(audio.PathName2,audio.FileName2);
        if audio.data == 0
            audiowrite(audio.carrier,audio.a,audio.Fs);
            c = msgbox("Audio File saved","Saved","help");
        else
            audiowrite(audio.carrier,audio.data,audio.fs);
            c = msgbox("Audio File saved","Saved","help");
        end      
    end
end

% --- Executes on button press in back_btn.
function back_btn_Callback(hObject, eventdata, handles)
% hObject    handle to back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Dashboard;
close Hide;

% --- Executes on button press in enc_btn.
function enc_btn_Callback(hObject, eventdata, handles)
% hObject    handle to enc_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file text;
audio = guidata(hObject);
q = get(handles.edit_file,'String');
s = get(handles.edit_msg,'String');
t = 'Audio has been recorded.';
if isempty(q) || isempty(s)
    f = msgbox("Audio file or Message file not found","Error","error");
else
    if isequal(audio.data,0) || isequal(q,t)
        [~,audio.name] = fileparts('record.wav');
        [audio.data, audio.fs] = audioread('record.wav');
    else
        [~,audio.name] = fileparts(audio.FileName);
        [audio.data, audio.fs] = audioread(audio.filea);
    end

    load('myfile.mat','file');
    if isequal(file,0)
        s = get(handles.edit_msg,'String');

        file = 'newtest.txt';
        filee = fopen(file,'w');
        t = cellstr(s);
        fprintf(filee,'%s\n',t{:});

        text1 = fread(filee,'*char');
        fclose(filee);

        save('myfile.mat','file','-append');

        fid  = fopen(file, 'r');
        text = fread(fid,'*char')';
        fclose(fid);
    else 
        fid  = fopen(file, 'r');
        text = fread(fid,'*char')';
        fclose(fid);
        save('myfile.mat','file','-append');
    end

    audio.out = phase_enc(audio.data, text, length(audio.data));
    %audio.out = [audio.out1 audio.out1];

    axes(handles.axes_stego);
    plot(audio.out);
    title('Audio Stego');
    ylabel('Amplitude');
    xlabel('Sample Number');

    [r,c] = size(audio.out);
    MSE = sum(sum((double(audio.out) - double(audio.data(:,1))).^2))/(r*c);
    disp(MSE);

    PSNR = 10*log10(1*1/ MSE);
    disp(PSNR);
    handles.psnr_edit.String = PSNR;

    %audiowrite([audio.name,'_stego.wav'], audio.out, audio.fs);

    if audio.out == 0
        f = msgbox("Invalid Value","Error","error");
    else
        f = msgbox("The operation has been successfully completed","Success","help");
    end
    guidata(hObject,audio);
end

% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear; clc;
close Hide;
Hide;


% --- Executes on button press in play1.
function play1_Callback(hObject, eventdata, handles)
% hObject    handle to play1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
persistent player1

if isempty(player1)
    if audio.out == 0

    else
        player1 = audioplayer(audio.out, audio.fs);
        set(handles.play1,'string','Stop');
        play(player1);        
    end
    %[audio.out,audio.fs] = audioread(audio.name,'_stego.wav');
else
    stop(player1);
    set(handles.play1,'string','Play');
    player1 = [];
end
guidata(hObject,audio);

% --- Executes on button press in save1.
function save1_Callback(hObject, eventdata, handles)
% hObject    handle to save1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
p = get(handles.psnr_edit,'String');
if isempty(p)
    c = msgbox("Audio Stego not found.","Warning!","warn");
else
    [audio.FileName3,audio.PathName3] = uiputfile('*.wav', 'Save file.');
    if isequal(audio.FileName3,0) || isequal(audio.PathName3,0)
        return
    else
        audio.carrier = fullfile(audio.PathName3,audio.FileName3);
        if audio.data == 0

        else
            audiowrite(audio.carrier, audio.out, audio.fs);
            disp(['Stego signal is saved in ', audio.PathName3, audio.FileName3]);
            c = msgbox("Audio Stego File saved","Saved","help");
        end      
    end
end
guidata(hObject,audio);



function edit_time_Callback(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_time as text
%        str2double(get(hObject,'String')) returns contents of edit_time as a double


% --- Executes during object creation, after setting all properties.
function edit_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

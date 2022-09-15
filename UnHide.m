function varargout = UnHide(varargin)
% UNHIDE MATLAB code for UnHide.fig
%      UNHIDE, by itself, creates a new UNHIDE or raises the existing
%      singleton*.
%
%      H = UNHIDE returns the handle to a new UNHIDE or the handle to
%      the existing singleton*.
%
%      UNHIDE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNHIDE.M with the given input arguments.
%
%      UNHIDE('Property','Value',...) creates a new UNHIDE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UnHide_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UnHide_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UnHide

% Last Modified by GUIDE v2.5 30-Apr-2022 21:55:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UnHide_OpeningFcn, ...
                   'gui_OutputFcn',  @UnHide_OutputFcn, ...
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


% --- Executes just before UnHide is made visible.
function UnHide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UnHide (see VARARGIN)

% Choose default command line output for UnHide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UnHide wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UnHide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_edit as text
%        str2double(get(hObject,'String')) returns contents of file_edit as a double


% --- Executes during object creation, after setting all properties.
function file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_btn.
function add_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
[audio.FileName,audio.PathName] = uigetfile('*.wav', 'Select audio file.');
if isequal(audio.FileName,0) || isequal(audio.PathName,0)
    return
end
audio.file = fullfile(audio.PathName,audio.FileName);
[audio.data, audio.fs] = audioread(audio.file);
string1 = audio.file;

handles.file_edit.String = string1;
axes(handles.axes1);
plot(audio.data);
title('Audio Stego');
ylabel('Amplitude');
xlabel('Sample Number');

guidata(hObject,audio);


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


% --- Executes on button press in play_stego.
function play_stego_Callback(hObject, eventdata, handles)
% hObject    handle to play_stego (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
persistent player

if isempty(player)
    if audio.data == 0
        return
    else
        player = audioplayer(audio.data, audio.fs);
    end
    set(handles.play_stego,'string','Stop');
    play(player);
else
    stop(player);
    set(handles.play_stego,'string','Play');
    player = [];
end

% --- Executes on button press in save_stego.
function save_stego_Callback(hObject, eventdata, handles)
% hObject    handle to save_stego (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
q = get(handles.file_edit,'String');
if isempty(q)
    msgbox("Audio not found.","Warning!","warn");
else
    [audio.FileName1,audio.PathName1] = uiputfile('*.wav', 'Save audio file.');
    if isequal(audio.FileName1,0) || isequal(audio.PathName1,0)
        return
    else
        audio.stego = fullfile(audio.PathName1,audio.FileName1);
        if audio.data == 0
            c = msgbox("Data not found.","Warning!","warn");
        else
            audiowrite(audio.stego,audio.data,audio.fs);
            c = msgbox("Audio File saved","Saved","help");
        end      
    end
end
% --- Executes on button press in play_raw.
function play_raw_Callback(hObject, eventdata, handles)
% hObject    handle to play_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
persistent player

if isempty(player)
    if isequal(audio.raw,0)
        return
    else
        player = audioplayer(audio.raw, audio.fs);
    end
    set(handles.play_raw,'string','Stop');
    play(player);
else
    stop(player);
    set(handles.play_raw,'string','Play');
    player = [];
end

% --- Executes on button press in save_raw.
function save_raw_Callback(hObject, eventdata, handles)
% hObject    handle to save_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
s = get(handles.edit_msg,'String');
if isempty(s)
    c = msgbox("Data not found.","Warning!","warn");
else
    [audio.FileName3,audio.PathName3] = uiputfile('*.wav', 'Save audio file.');
    if isequal(audio.FileName3,0) || isequal(audio.PathName3,0)
        return
    else
        audio.carrier = fullfile(audio.PathName3,audio.FileName3);
        if audio.data == 0
            c = msgbox("Data not found.","Warning!","warn");
        else
            audiowrite(audio.carrier,audio.raw,audio.fs);
            c = msgbox("Audio File saved","Saved","help");
        end      
    end
end
% --- Executes on button press in save_msg.
function save_msg_Callback(hObject, eventdata, handles)
% hObject    handle to save_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
s = get(handles.edit_msg,'String');
if isempty(s)
    q = msgbox("Data not found.","Warning!","warn");
else
    [audio.FileName2,audio.PathName2] = uiputfile('*.txt', 'Select text file.');
    if isequal(audio.FileName2,0) || isequal(audio.PathName2,0)
        return
    else
        s = get(handles.edit_msg,'String');
        file = fullfile(audio.PathName2,audio.FileName2);
        filee = fopen(file,'wt');
        t = cellstr(s);
        fprintf(filee,'%s\n',t{:});
        fclose(filee);

        q = msgbox("Message saved","Saved","help");
    end
end

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Dashboard;
close UnHide;

% --- Executes on button press in dec_btn.
function dec_btn_Callback(hObject, eventdata, handles)
% hObject    handle to dec_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = guidata(hObject);
load('myfile.mat','file');
q = get(handles.file_edit,'String');
if isempty(q)
    msgbox("Audio not found.","Warning!","warn");
else
    fid  = fopen(file, 'r');
    text1 = fread(fid,'*char')';
    fclose(fid);

    msg = phase_dec(audio.data, length(text1),length(audio.data));
    fprintf('Text: \n%s\n', msg);
    set(handles.edit_msg,'Max', 100);
    handles.edit_msg.String = msg;

    audio_raw = raw(audio.data,length(text1),length(audio.data));
    audio.raw = [audio_raw audio_raw];
    axes(handles.axes2);
    plot(audio.raw);
    title('Audio Carrier');
    ylabel('Amplitude');
    xlabel('Sample Number');

    guidata(hObject,audio);
end

% --- Executes on button press in ref_btn.
function ref_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ref_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close UnHide;
UnHide;


function edit_msg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_msg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_msg as text
%        str2double(get(hObject,'String')) returns contents of edit_msg as a double

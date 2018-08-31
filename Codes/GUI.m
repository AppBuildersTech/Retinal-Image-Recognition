function varargout = GUI(varargin)
gui_Singleton = 1;

gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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

function GUI_OpeningFcn(hObject, eventdata, handles, varargin)

% ��ǰ�Ƿ���ڽ�ͼ��
global cutbool;
cutbool = false;

% ����ͼƬ����
set(handles.imageaxes,'visible','off')

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

% ѡ��ť
function choosebutton_Callback(hObject, eventdata, handles)

%���ļ�
[filepath,filename] = uigetfile({'*.jpg';'*.bmp'},'Select the Image');

if isempty(filename)
    msgbox('Empty File !!','Warning','warn');
else
    currentfile = [filename,filepath];
    currentimage = imread(currentfile);
    axes(handles.imageaxes);
    imshow(currentimage);
    title('ԭʼͼƬ');
    handles.currentimage = currentimage;
    % == ���ļ�·�����ļ������浽handles���� == %
    handles.filepath = filepath;
    handles.filename = filename;
    
    guidata(hObject,handles);
end

% ��ͼ��ť
function cutbutton_Callback(hObject, eventdata, handles)

global cutbool

if cutbool == false
    h = imcrop();
    axes(handles.imageaxes);
    imshow(h);
    title('��ȡ��ͼƬ');
    imwrite(h,'eg.jpg');
    currentimage = handles.currentimage;
    cutimage = imcrop(currentimage,h);
    handles.cutimage = cutimage;
    cutbool = true;
    guidata(hObject,handles);
end

% ȡ����ť
function cancelbutton_Callback(hObject, eventdata, handles)

global  hh1 hh2 hh3;

h = 0;
if ishandle(hh1)
    delete(hh1);h=1;
end
if ishandle(hh2)
    delete(hh2);h=1;
end
if ishandle(hh3)
    delete(hh3);h=1;
end
if h
    handles.imageaxes = axes('parent',handles.imagepanel);
end

cla(handles.imageaxes,'reset');
set(handles.imageaxes,'visible','off')


% ���㰴ť
function confirmbutton_Callback(hObject, eventdata, handles)

ImageRecognition()
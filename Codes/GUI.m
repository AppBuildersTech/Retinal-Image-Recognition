function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 15-Jul-2018 16:12:57

% Begin initialization code - DO NOT EDIT
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
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

%��ǰ�Ƿ���ڽ�ͼ��
global cutbool;
cutbool = false;

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosebutton.
function choosebutton_Callback(hObject, eventdata, handles)
% hObject    handle to choosebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%���ļ�
[filepath,filename] = uigetfile({'*.jpg';'*.bmp'},'Select the Image');

if isempty(filename)
    msgbox('Empty File !!','Warning','warn');
else
    currentfile = [filename,filepath];
    currentimage = imread(currentfile);
    axes(handles.imageaxes);
    imshow(currentimage);
    handles.currentimage = currentimage;
    
    % == ���ļ�·�����ļ������浽handles���� == %
    handles.filepath = filepath;
    handles.filename = filename;
    
    % Update handles structure
    guidata(hObject,handles);
end

% --- Executes on button press in cutbutton.
function cutbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cutbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cutbool

%setFixedAspectRatioMode(h,true); % == �̶������ == %
% rect = getPosition(h);
%h = imrect(handles.imageaxes);
h = imcrop();
%rect = wait(h);
figure;imshow(h);
imwrite(h,'eg.jpg');
if cutbool == false
    currentimage = handles.currentimage;
    cutimage = imcrop(currentimage,h);
    handles.cutimage = cutimage;
    cutbool = true;
    guidata(hObject,handles);
end


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


% --- Executes on button press in confirmbutton.
function confirmbutton_Callback(hObject, eventdata, handles)
% hObject    handle to confirmbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear
%D:\����\978-7-302-46774-8MATLAB�����㷨����\Intelligent algorithm\10\s10_4\Lenna.bmp'));%
close all
img= imread('eg.jpg');%more quickly
%D:\yaoxl\��2\ͼ��\KPIS\KPIS001.bmp

%img=t(:,:,1);
%imshow(img)
%img=histeq(img);
%img=double(img)+0.006*double(img) .*(255-double(img));
img=rgb2gray(img);
cluster_num = 2;%���÷�����
maxiter = 60;%����������
%-------------�����ʼ����ǩ----------------
%label = randi([1,cluster_num],size(img));
%-----------kmeans��Ϊ��ʼ��Ԥ�ָ�----------
label = kmeans(img(:),cluster_num);
label = reshape(label,size(img));
iter = 0;
b=label;
while iter < maxiter
    %-------�����������---------------
    %�����Ҳ��õ������ص��3*3����ı�ǩ��ͬ
    %�������Ϊ�������
    %------�ռ���������б�Ȱ˸�����ı�ǩ--------
    label_u = imfilter(label,[0,1,0;0,0,0;0,0,0],'replicate');
    label_d = imfilter(label,[0,0,0;0,0,0;0,1,0],'replicate');
    label_l = imfilter(label,[0,0,0;1,0,0;0,0,0],'replicate');
    label_r = imfilter(label,[0,0,0;0,0,1;0,0,0],'replicate');
    label_ul = imfilter(label,[1,0,0;0,0,0;0,0,0],'replicate');
    label_ur = imfilter(label,[0,0,1;0,0,0;0,0,0],'replicate');
    label_dl = imfilter(label,[0,0,0;0,0,0;1,0,0],'replicate');
    label_dr = imfilter(label,[0,0,0;0,0,0;0,0,1],'replicate');
    p_c = zeros(cluster_num,size(label,1)*size(label,2));
    %�������ص�8�����ǩ�����ÿһ�����ͬ����
    for i = 1:cluster_num
        label_i = i * ones(size(label));
        temp = ~(label_i - label_u) + ~(label_i - label_d) + ...
            ~(label_i - label_l) + ~(label_i - label_r) + ...
            ~(label_i - label_ul) + ~(label_i - label_ur) + ...
            ~(label_i - label_dl) +~(label_i - label_dr);
        p_c(i,:) = temp(:)/8;%�������
    end
    p_c(find(p_c == 0)) = 0.001;%��ֹ����0
    %---------------������Ȼ����----------------
    mu = zeros(1,cluster_num);
    sigma = zeros(1,cluster_num);
    %���ÿһ��ĵĸ�˹����--��ֵ����
    for i = 1:cluster_num
        index = find(label == i);%�ҵ�ÿһ��ĵ�
        data_c = double(img(index));
        mu(i) = mean(data_c);%��ֵ
        sigma(i) = var(data_c);%����
    end
    p_sc = zeros(cluster_num,size(label,1)*size(label,2));
%     for i = 1:size(img,1)*size(img,2)
%         for j = 1:cluster_num
%             p_sc(j,i) = 1/sqrt(2*pi*sigma(j))*...
%               exp(-(img(i)-mu(j))^2/2/sigma(j));
%         end
%     end
    %------����ÿ�����ص�����ÿһ�����Ȼ����--------
    %------Ϊ�˼������㣬��ѭ����Ϊ����һ�����--------
    for j = 1:cluster_num
        MU = repmat(mu(j),size(img,1)*size(img,2),1);
        p_sc(j,:) = 1/sqrt(2*pi*sigma(j))*...
            exp(-(double(img(:))-MU).^2/2/sigma(j));
    end 
    %�ҵ�����һ�����������Ϊ��ǩ��ȡ������ֵֹ̫С
    [~,label] = max(log(p_c) + log(p_sc));
    %�Ĵ�С������ʾ
    label = reshape(label,size(img));
    %---------��ʾ----------------
    if ~mod(iter,6) 
        figure;
        n=1;
    end
    subplot(2,3,n);
    imshow(label,[]);
    t=label;
    title(['iter = ',num2str(iter)]);
    pause(0.1);
    n = n+1;
    iter = iter + 1;
end
m=numel(t);
x=length(find(t==1));
y=min(x,m-x);
%I=imread('D:\����\978-7-302-46774-8MATLAB�����㷨����\Intelligent algorithm\10\s10_4\rice_noise.tif');
BW1=edge(t,'Roberts',0.04);    	%Roberts����
BW2=edge(t,'Sobel',0.04);    	%Sobel����
BW6=edge(b,'Sobel',0.04);    	%Sobel����
BW3=edge(t,'Prewitt',0.04);        	%Prewitt����
BW4=edge(t,'LOG',0.004);         	% LOG����
BW5=edge(t,'Canny',0.04);         	% Canny����
figure;
subplot(2,3,1),
imshow(t,[])
title('�ָ��ͼ��')
subplot(2,3,2),
imshow(BW1)
title('Roberts ')
subplot(2,3,3),
imshow(BW2)
title(' Sobel ')
subplot(2,3,4),
imshow(BW3)
title(' Prewitt ')
subplot(2,3,5),
imshow(BW4)
title(' LOG ')
subplot(2,3,6),
imshow(BW5)
title('Canny ')
g1=length(find(BW1==1))/2;
g2=length(find(BW2==1))/2;
g3=length(find(BW3==1))/2;
g4=length(find(BW4==1))/2;
g5=length(find(BW5==1))/2;
g6=length(find(BW6==1))/2;
h1=y/g1
h2=y/g2
h3=y/g3
h4=y/g4
h5=y/g5
h6=y/g6



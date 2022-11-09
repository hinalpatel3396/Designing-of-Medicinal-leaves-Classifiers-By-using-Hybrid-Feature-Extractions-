function varargout = LeafGUI(varargin)
% LEAFGUI MATLAB code for LeafGUI.fig
%      LEAFGUI, by itself, creates a new LEAFGUI or raises the existing
%      singleton*.
%
%      H = LEAFGUI returns the handle to a new LEAFGUI or the handle to
%      the existing singleton*.
%
%      LEAFGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEAFGUI.M with the given input arguments.
%
%      LEAFGUI('Property','Value',...) creates a new LEAFGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LeafGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LeafGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LeafGUI

% Last Modified by GUIDE v2.5 24-Feb-2019 08:39:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LeafGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @LeafGUI_OutputFcn, ...
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


% --- Executes just before LeafGUI is made visible.
function LeafGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LeafGUI (see VARARGIN)

% Choose default command line output for LeafGUI
handles.output = hObject;
clc
warning off
a=ones(512,512);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LeafGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LeafGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]=uigetfile('*.*','Select Leaf Image');
img=imresize(imread([path file]),[128 128]);
axes(handles.axes1);
imshow(img);
handles.img=img;
guidata(hObject, handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img;
gr=rgb2gray(img);
gr=medfilt2(gr);
axes(handles.axes2);
imshow(gr);
handles.gr=gr;
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mt=get(handles.popupmenu2,'Value');
gr=handles.gr;
switch(mt)
    case 1 %otsu's thresholding
th=graythresh(gr);
seg=~im2bw(gr,th);
axes(handles.axes3);
imshow(seg);
    case 2%canny edge detection
seg=edge(gr,'canny');
axes(handles.axes3);
imshow(seg);
th=graythresh(gr);
seg=~im2bw(gr,th);
    case 3%Contourlet Transform
addpath('nsct_toolbox/')
% Parameteters:
nlevels = 2;        % Decomposition level
filterB = 'pkva' ;              % Pyramidal filter
%filterB = 'dmaxflat7'; %'cd' ;              % Directional filter
% Nonsubsampled Contourlet decomposition
coeffs = nsdfbdec( double(gr), filterB, nlevels );
coun=uint8(coeffs{1});
seg=im2bw(coun,graythresh(coun)); 
seg=~seg;
axes(handles.axes3);
imshow(seg); 
    case 4%active Contour
mask = false(size(gr));
mask(25:end-25,25:end-25) = true;
seg = activecontour(gr, mask, 300);  
axes(handles.axes3);
imshow(seg);
end
handles.seg=seg;
guidata(hObject, handles);




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mt1=get(handles.popupmenu1,'Value');
handles.mt1=mt1;
img=handles.img;
gr=handles.gr;
seg=handles.seg;
switch(mt1)
    case 1
%shap
F1= shapE(seg);
%color
F2=colorF(img);
%texture
F3= textF(gr,seg);
%invarient
F4= Zk_Hu_Feat(img,seg);
F=[F1,F2,F3,F4];
F11=zeros(4,26);
F11=[F1;[F2,zeros(1,26-length(F2))];[F3,zeros(1,26-length(F3))];[F4,zeros(1,26-length(F4))]];
set(handles.uitable1,'Data',F11);
handles.F=F;
    case 2
%S
F1 = ShapP(seg);
%c
F2=colorMoments(img);
%T
offsets = [0 1; -1 1;-1 0;-1 -1];
glcms= graycomatrix(gr,'Offset',offsets);
F3 = graycoprops(glcms);
F3=cell2mat(struct2cell(F3));
F3=F3(:)';
%V
F4=veinF(seg,gr);
F=[F1,F2,F3,F4];
F11=zeros(4,16);
F11=[[F1,zeros(1,16-length(F1))];[F2,zeros(1,16-length(F2))];F3;[F4,zeros(1,16-length(F4))]];
set(handles.uitable1,'Data',F11);        
handles.F=F;
end
guidata(hObject, handles);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
F=handles.F;
mt1=handles.mt1;

tic;
cls=get(handles.popupmenu3,'Value');
load('Train_Dataset.mat');


switch(cls)
    case 1
switch(mt1)
    case 1
load('svmModel1.mat')
load('annModel1.mat') 
    case 2
load('svmModel2.mat')
load('annModel2.mat')
end
        q=1;
predFinalQueryImg=round(net(F'));
for k = 1:numel(svmModel)
    %# test
    predQueryImg(:, k) = svmclassify(svmModel{k}, F); % queryImage = x.jpg, row=x from dataset
end
predFinalQueryImg = mode(predQueryImg, 2);
    case 2
switch(mt1)
    case 1
load('svmModel1.mat')
    case 2
load('svmModel2.mat')
end        
        q=1;
for k = 1:numel(svmModel)
    %# test
    predQueryImg(:, k) = svmclassify(svmModel{k}, F); % queryImage = x.jpg, row=x from dataset
end
predFinalQueryImg = mode(predQueryImg, 2);

    case 3
switch(mt1)
    case 1
load('RF1.mat')
    case 2
load('RF2.mat')
end
q=1;
predFinalQueryImg = str2num(cell2mat(B.predict(F)));
end
t=toc;
if q==1
set(handles.edit1,'String',cell2mat(fdata(predFinalQueryImg)));
switch(predFinalQueryImg)
    case 1
        msgbox('The effect of public health-oriented drug law reform on HIV incidence in people who inject drugs in Tijuana');
    case 2

end
set(handles.edit5,'String',num2str(t));
set(handles.edit4,'String',num2str(final_acc));
set(handles.edit6,'String',num2str(sum(precision)/16));
set(handles.edit7,'String',num2str(sum(recall)/16));
end
guidata(hObject, handles);








% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function pushbutton5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

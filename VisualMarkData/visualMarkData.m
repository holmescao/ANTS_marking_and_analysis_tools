function varargout = visualMarkData(varargin)
% VISUALMARKDATA MATLAB code for visualMarkData.fig
%      VISUALMARKDATA, by itself, creates a new VISUALMARKDATA or raises the existing
%      singleton*.
%
%      H = VISUALMARKDATA returns the handle to a new VISUALMARKDATA or the handle to
%      the existing singleton*.
%
%      VISUALMARKDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALMARKDATA.M with the given input arguments.
%
%      VISUALMARKDATA('Property','Value',...) creates a new VISUALMARKDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualMarkData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualMarkData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualMarkData

% Last Modified by GUIDE v2.5 03-Oct-2021 23:13:24

% Begin initialization code - DO NOT EDIT
% global clickcounts
% clickcounts=0;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualMarkData_OpeningFcn, ...
                   'gui_OutputFcn',  @visualMarkData_OutputFcn, ...
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
end

% --- Executes just before visualMarkData is made visible.
function visualMarkData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualMarkData (see VARARGIN)

% Choose default command line output for visualMarkData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes visualMarkData wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = visualMarkData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Startbutton.
end


function Startbutton_Callback(hObject, eventdata, handles)
global clickcounts
global N
global rect 
global location
global filepath
global origindataset_filepath
global maindir
global startFrame
global antID
global x
global ant_num

location = [];
clickcounts = 1;
x(1)=0;
x(2)=0;

startFrame = str2num(get(handles.keepstart,'String'));
guidata(hObject,handles);

if startFrame > 0 
    clickcounts = startFrame;
end

set(handles.edit1,'string',num2str(clickcounts));
axis off 


maindir = origindataset_filepath;
subdirpath = fullfile( maindir, '*.jpg' );
images = dir(subdirpath); 
N=length(images); 
set(handles.TotalFrame,'string',num2str(N));
if startFrame > 0
    image_name=strcat(maindir,'\',num2str(clickcounts-1,'%06d'));
else
    image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'));
end
image_name=strcat(image_name,'.jpg');


image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'),'.jpg');
img2=imread(image_name);

axes(handles.axes2);
imshow(img2)
% draw_bounding = 1;
% if draw_bounding == 1
%     drawbounding();
% end


S2 = regexp(filepath, '\', 'split');
ant_num = str2num(char(S2(end))); 

S2 = regexp(maindir, '\', 'split'); 
str = char(S2(end));
expression = '[Tt]\d+[Ii]';
[match,noMatch] = regexp(str,expression,'match','split');

str = match{1,1};
expression = '\d+';
[match,noMatch] = regexp(str,expression,'match','split');
firstFrameAntNum = str2num(char(match));


if startFrame > 0
    S2 = regexp(filepath, '\', 'split');
    location_filepath = "";
    for s = 1:length(S2)-1
        location_filepath = strcat(location_filepath,char(S2{s}),"\");
    end
    antID = char(S2(end));
    antID_location = strcat(antID, '.txt');
    location_file_path= strcat(location_filepath,antID_location);
    txt_exist = exist(location_file_path, 'file');
    if txt_exist == 2  
    
        [data1,~,data3,data4,data5,data6,~,~]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
        i = 1;
        while i <= length(data1) && data1(i) < startFrame 
            i = i + 1;
        end
        f = i - 1; 
        hold on
    
        rectangle('Position',[data3(f) data4(f) data5(f) data6(f)],'LineWidth',0.5,'EdgeColor','g','LineStyle','--'); % ÂÌÉ«ÐéÏß¿ò
        antIMAGE = num2str(str2num(antID));
        text(data3(f),data4(f),antIMAGE,'color','b','FontSize',16)
    end
end


axes(handles.axes2);
[x(1),x(2),~] = ginput(1);    
hold on
plot(x(1),x(2),'.','Color','r', 'MarkerSize',12)

split_res = regexp(maindir, 'Image', 'split');
pixel_size = str2num(char(split_res(end)));

[high,width,~] = size(img2); 

if x(1) < pixel_size/2 
    if x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, high- pixel_size, pixel_size, pixel_size]); 
    else 
        [img2, rect] = imcrop(img2, [0, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
elseif width - x(1) < pixel_size/2 
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [width - pixel_size, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
else
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
end

hold on
rectangle('Position',rect,'LineWidth',0.5,'EdgeColor','r'); 

S = regexp(filepath, '\', 'split');
antID = char(S(end));
antID_Image = strcat(antID, 'F',num2str(clickcounts,'%06d'));
image_name=strcat(filepath,'\',antID_Image,'.jpg');
imwrite(img2,image_name,'jpg');
location = [rect x(1) x(2)];

S2 = regexp(filepath, '\', 'split');
location_filepath = "";
for s = 1:length(S2)-1
    location_filepath = strcat(location_filepath,char(S2{s}),"\");
end
antID = S2(end);
antID_location = strcat(antID, '.txt');
location_file_path=char(strcat(location_filepath,antID_location));

matrix=location;
antID_num = str2num(char(antID));
[~,n]=size(matrix);
txt_exist = exist(location_file_path,'file') ;  

if startFrame >= 1 && txt_exist == 2 
    [frame,id,xmin,ymin,w,h,cx,cy]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
    i = 1;
    while i <= length(frame) && frame(i) < startFrame
        i = i + 1;
    end
    frame_sub = startFrame - frame(length(frame));
    if frame_sub >= 2 
        mode=struct('WindowStyle','modal','Interpreter','tex');
        errordlg('The starting frame is out of range!','warning',mode);
        close
    elseif frame_sub == 1 
        fid=fopen(location_file_path,'a+');
        fprintf(fid,'%d,%d,', startFrame, antID_num);
        for j=1:n
            if j==n
                fprintf(fid,'%g\r\n',matrix(1,j));
            else
                fprintf(fid,'%g,',matrix(1,j));
            end
        end
        fclose(fid);
    else
        frame(i) = startFrame;
        xmin(i) =  matrix(1,1);
        ymin(i) =  matrix(1,2);
        w(i) =  matrix(1,3);
        h(i) =  matrix(1,4);
        cx(i) =  matrix(1,5);
        cy(i) =  matrix(1,6);
        fid=fopen(location_file_path,'w');
        for num = 1:length(frame)
            fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',frame(num), id(num),xmin(num), ymin(num), w(num), h(num),cx(num),cy(num));
        end
        fclose(fid);
    end

S2 = regexp(filepath, '\', 'split');
ant_num = str2num(char(S2(end)));
elseif ant_num > firstFrameAntNum && txt_exist == 0 && startFrame ~= 0
    fid=fopen(location_file_path,'a+');
    fprintf(fid,'%d,%d,', startFrame, antID_num);
    for j=1:n
        if j==n
            fprintf(fid,'%g\r\n',matrix(1,j));
        else
            fprintf(fid,'%g,',matrix(1,j));
        end
    end
    fclose(fid);
else
    fid=fopen(location_file_path,'a+');
    fprintf(fid,'1,%d,', antID_num);
    for j=1:n
        if j==n
            fprintf(fid,'%g\r\n',matrix(1,j));
        else
            fprintf(fid,'%g,',matrix(1,j));
        end
    end
    fclose(fid);
end

end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

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
end

% --- Executes on button press in nextImagebutton.
function nextImagebutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextImagebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global N
global clickcounts
global rect
global location
global filepath
global maindir
global antID
global startFrame
global markframe
global x
global gin_poc

clear img2 
cla(handles.axes2)
gin_poc = zeros(1,2);
gin_poc(1,1) = x(1);
gin_poc(1,2) = x(2);
if gin_poc(1,1) == -1 && gin_poc(1,2) == -1
    clickcounts = clickcounts - 2;
    mode=struct('WindowStyle','modal','Interpreter','tex');
    errordlg('Press "Next" continuously, no mark on the previous frame!','warning',mode);
    x(1)=0;
    x(2)=0;
    return;
end
x(1) = -1;
x(2) = -1;

markframe = 0;
clickcounts = clickcounts + 1;
set(handles.edit1,'string',num2str(clickcounts));
axis off 

Framenum=str2double(get(handles.edit1,'String'));    
if Framenum > N
    mode=struct('WindowStyle','modal','Interpreter','tex');
    errordlg('All images have been processed, please click  "Exit" to exit','warning',mode);
end

image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'));
image_name=strcat(image_name,'.jpg');
img2=imread(image_name);
axes(handles.axes2);
imshow(img2)
hold on
% draw_bounding = 1;
% if draw_bounding == 1
%     drawbounding();
% end

rectangle('Position',rect,'LineWidth',0.5,'EdgeColor','g','LineStyle','--'); 

axes(handles.axes2);
[x(1),x(2),~] = ginput(1);
hold on
plot(x(1),x(2),'.','Color','r', 'MarkerSize',12)
markframe = 1;

split_res = regexp(maindir, 'Image', 'split');
pixel_size = str2num(char(split_res(end)));

[high,width,~] = size(img2);

if x(1) < pixel_size/2 
    if x(2) < pixel_size/2
        [img2, rect] = imcrop(img2, [0, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, high- pixel_size, pixel_size, pixel_size]); 
    else 
        [img2, rect] = imcrop(img2, [0, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
elseif width - x(1) < pixel_size/2 
    if x(2) < pixel_size/2
		[img2, rect] = imcrop(img2, [width - pixel_size, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [width - pixel_size, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
else 
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
end

hold on
rectangle('Position',rect,'LineWidth',0.5,'EdgeColor','r'); 


S = regexp(filepath, '\', 'split');
antID = S(end);
antID_Image = strcat(antID, 'F',num2str(clickcounts,'%06d'));
image_name=strcat(filepath,'\',antID_Image);
image_name=strcat(image_name,'.jpg');
image_name = char( image_name );
imwrite(img2,image_name,'jpg');
location = [rect x(1) x(2)];

S2 = regexp(filepath, '\', 'split');

location_filepath = "";
for s = 1:length(S2)-1
    location_filepath = strcat(location_filepath,char(S2{s}),"\");
end

antID = S2(end);
antID_location = strcat(antID, '.txt');
location_file_path=char(strcat(location_filepath,antID_location));
matrix=location; 
antID_num = str2num(char(antID));
[~,n]=size(matrix);

if markframe == 1 && x(2)>1 && x(1)>1 
    [frame,id,xmin,ymin,w,h,cx,cy]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
    if startFrame >= 1 && clickcounts <= frame(length(frame)) 
        i = 1;
        while frame(i) < clickcounts
            i = i + 1;
        end
        if frame(i) > clickcounts 
            addframe = zeros(length(frame)+1,1);
            addid = zeros(length(frame)+1,1);
            addxmin= zeros(length(frame)+1,1);
            addymin= zeros(length(frame)+1,1);
            addw= zeros(length(frame)+1,1);
            addh= zeros(length(frame)+1,1);
            addcx= zeros(length(frame)+1,1);
            addcy= zeros(length(frame)+1,1);

            %1~startFrame-1
            addframe(1:(i-1)) = frame(1:(i-1));
            addid(1:(i-1)) = id(1:(i-1));
            addxmin(1:(i-1))= xmin(1:(i-1));
            addymin(1:(i-1))= ymin(1:(i-1));
            addw(1:(i-1))= w(1:(i-1));
            addh(1:(i-1))= h(1:(i-1));
            addcx(1:(i-1))= cx(1:(i-1));
            addcy(1:(i-1))= cy(1:(i-1));

            %startFrame
            addframe(i) = clickcounts;
            addid(i) = id(1);
            addxmin(i)= matrix(1,1);
            addymin(i)= matrix(1,2);
            addw(i)= matrix(1,3);
            addh(i)= matrix(1,4);
            addcx(i)= matrix(1,5);
            addcy(i)= matrix(1,6);

            %startFrame+1~end
            addframe(i+1:end) = frame(i:end);
            addid(i+1:end) = id(i:end);
            addxmin(i+1:end)= xmin(i:end);
            addymin(i+1:end)= ymin(i:end);
            addw(i+1:end)= w(i:end);
            addh(i+1:end)= h(i:end);
            addcx(i+1:end)= cx(i:end);
            addcy(i+1:end)= cy(i:end);
            
            fid=fopen(location_file_path,'w');
            for num = 1:length(frame)+1
                fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',addframe(num), addid(num),addxmin(num), addymin(num), addw(num), addh(num),addcx(num),addcy(num));
            end
            fclose(fid);
        elseif frame(i) == clickcounts 
            frame(i) = clickcounts;
            xmin(i) =  matrix(1,1);
            ymin(i) =  matrix(1,2);
            w(i) =  matrix(1,3);
            h(i) =  matrix(1,4);
            cx(i) =  matrix(1,5);
            cy(i) =  matrix(1,6);
            fid=fopen(location_file_path,'w');
            for num = 1:length(frame)
                fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',frame(num), id(num),xmin(num), ymin(num), w(num), h(num),cx(num),cy(num));
            end
            fclose(fid);
        end
    else
        if clickcounts <= frame(length(frame)) 
            i = 1;
            while frame(i) < clickcounts
                i = i + 1;
            end
            frame(i) = clickcounts;
            xmin(i) =  matrix(1,1);
            ymin(i) =  matrix(1,2);
            w(i) =  matrix(1,3);
            h(i) =  matrix(1,4);
            cx(i) =  matrix(1,5);
            cy(i) =  matrix(1,6);
            fid=fopen(location_file_path,'w');
            for num = 1:length(frame)
                fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',frame(num), id(num),xmin(num), ymin(num), w(num), h(num),cx(num),cy(num));
            end
            fclose(fid);
        else 
            fid=fopen(location_file_path,'a+');
            fprintf(fid,'%d,%d,', clickcounts, antID_num);
            for j=1:1:n
                if j==n
                    fprintf(fid,'%g\r\n',matrix(1,j));
                else
                    fprintf(fid,'%g,',matrix(1,j));
                end
            end
            fclose(fid);
        end
    end
end


% clear im
% clear img2
% cla(handles.axes2)
% cla(handles.axes1)
end

function TotalFrame_Callback(hObject, eventdata, handles)
% hObject    handle to TotalFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotalFrame as text
%        str2double(get(hObject,'String')) returns contents of TotalFrame as a double
end

% --- Executes during object creation, after setting all properties.
function TotalFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on key press with focus on password and none of its controls.

% uicontrol(handles.nextImagebutton)


% --- Executes on button press in Exitbutton.
function Exitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Exitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.edit1,'string') == '0'
    close
end

close
end


function keepstart_Callback(hObject, eventdata, handles)
% hObject    handle to keepstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of keepstart as text
%        str2double(get(hObject,'String')) returns contents of keepstart as a double

input =str2num(get(hObject,'String'));
if (isempty(input))
    set(hObject,'String','0')
end
guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function keepstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keepstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over nextImagebutton.
function nextImagebutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to nextImagebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in choiceAntfile.
function choiceAntfile_Callback(hObject, eventdata, handles)
% hObject    handle to choiceAntfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filepath
filepath = uigetdir('*.*','Output Directory');
set(handles.keepstart,'string',num2str(0));
set(handles.edit1,'string',num2str(0));

end


% --- Executes on button press in choiceOriginData.
function choiceOriginData_Callback(hObject, eventdata, handles)
% hObject    handle to choiceOriginData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global origindataset_filepath
origindataset_filepath = uigetdir('*.*','Choice Image Sequence');
set(handles.keepstart,'string',num2str(0)); 
set(handles.edit1,'string',num2str(0));
end


% --- Executes on button press in PreviousImagebutton.
function PreviousImagebutton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousImagebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global clickcounts
global rect
global location
global filepath
global maindir
global antID
global markframe
global x

clickcounts = clickcounts - 1;
set(handles.edit1,'string',num2str(clickcounts));
if clickcounts < 1
    mode=struct('WindowStyle','modal','Interpreter','tex');
    errordlg('Already the first frame','warning',mode);
    return;
end

if markframe == 0
    clickcounts = clickcounts + 1;
    mode=struct('WindowStyle','modal','Interpreter','tex');
    errordlg('Press "Previous" continuously, please click the "Next" button to continue','warning',mode);
    x(1)=0;
    x(2)=0;
    return;
end
clear img2 
cla(handles.axes2)
axis off

image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'));

image_name=strcat(image_name,'.jpg');
img2=imread(image_name);
axes(handles.axes2);
imshow(img2)
hold on


S2 = regexp(filepath, '\', 'split');

location_filepath = "";
for s = 1:length(S2)-1
    location_filepath = strcat(location_filepath,char(S2{s}),"\");
end

antID = S2(end);
antID_location = strcat(antID, '.txt');
location_file_path=char(strcat(location_filepath,antID_location));
[frame,id,xmin,ymin,w,h,cx,cy]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
i = 1;
while frame(i) < clickcounts
    i = i + 1;
end

if frame(i) > clickcounts
    rectangle('Position',[xmin(i-1),ymin(i-1),w(i-1),h(i-1)],'LineWidth',0.5,'EdgeColor','g','LineStyle','--'); 
else
    rectangle('Position',[xmin(i),ymin(i),w(i),h(i)],'LineWidth',0.5,'EdgeColor','r','LineStyle','--'); 
end

if (frame(length(frame)) == clickcounts+1)
    S2 = regexp(filepath, '\', 'split');
    location_filepath = "";
    for s = 1:length(S2)-1
        location_filepath = strcat(location_filepath,char(S2{s}),"\");
    end

    antID = S2(end);
    antID_location = strcat(antID, '.txt');
    location_file_path=char(strcat(location_filepath,antID_location));
    fid=fopen(location_file_path,'w');

    S = regexp(filepath, '\', 'split');
    antID = S(end);
    for i=1:length(frame)-1
        fprintf(fid,'%g,%g,%g,%g,%g,%g,%g,%g\r\n', frame(i),id(i),xmin(i),ymin(i),w(i),h(i),cx(i),cy(i)); 
    end
    
    antID_Image = strcat(antID, 'F',num2str(clickcounts,'%06d'));
    image_name=strcat(filepath,'\',antID_Image);
    image_name=strcat(image_name,'.jpg');
    image_name = char( image_name );
    delete(image_name)
    antID_Image = strcat(antID, 'F',num2str(clickcounts+1,'%06d'));
    image_name=strcat(filepath,'\',antID_Image);
    image_name=strcat(image_name,'.jpg');
    image_name = char( image_name );
    if exist('image_name','file')
        delete(image_name) 
    end
    fclose(fid);
end
markframe = 0;


axes(handles.axes2);
x = ginput(1);   
hold on
plot(x(1),x(2),'.','Color','r', 'MarkerSize',12)
if x(1) >= 0 && x(2) >= 0
    markframe = 1;
end

split_res = regexp(maindir, 'Image', 'split');
pixel_size = str2num(char(split_res(end)));

[high,width,~] = size(img2);

if x(1) < pixel_size/2 
    if x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, high- pixel_size, pixel_size, pixel_size]); 
    else 
        [img2, rect] = imcrop(img2, [0, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
elseif width - x(1) < pixel_size/2
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, high- pixel_size, pixel_size, pixel_size]); 
    else
		[img2, rect] = imcrop(img2, [width - pixel_size, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
else
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
end

hold on
rectangle('Position',rect,'LineWidth',0.5,'EdgeColor','r');

S = regexp(filepath, '\', 'split');
antID = S(end);
antID_Image = strcat(antID, 'F',num2str(clickcounts,'%06d'));
image_name=strcat(filepath,'\',antID_Image);
image_name=strcat(image_name,'.jpg');
image_name = char( image_name );
imwrite(img2,image_name,'jpg');
location = [rect x(1) x(2)];

S2 = regexp(filepath, '\', 'split');
location_filepath = "";
for s = 1:length(S2)-1
    location_filepath = strcat(location_filepath,char(S2{s}),"\");
end

antID = S2(end);
antID_location = strcat(antID, '.txt');
location_file_path=char(strcat(location_filepath,antID_location));
matrix=location; 
antID_num = str2num(char(antID));
[~,n]=size(matrix);
if frame(length(frame)) > clickcounts && markframe == 1
    [frame,id,xmin,ymin,w,h,cx,cy]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
    i = 1;
    while frame(i) < clickcounts 
        i = i + 1;
    end
    if frame(i) > clickcounts 
        addframe = zeros(length(frame)+1,1);
        addid = zeros(length(frame)+1,1);
        addxmin= zeros(length(frame)+1,1);
        addymin= zeros(length(frame)+1,1);
        addw= zeros(length(frame)+1,1);
        addh= zeros(length(frame)+1,1);
        addcx= zeros(length(frame)+1,1);
        addcy= zeros(length(frame)+1,1);

        %1~clickcounts-1
        addframe(1:(i-1)) = frame(1:(i-1));
        addid(1:(i-1)) = id(1:(i-1));
        addxmin(1:(i-1))= xmin(1:(i-1));
        addymin(1:(i-1))= ymin(1:(i-1));
        addw(1:(i-1))= w(1:(i-1));
        addh(1:(i-1))= h(1:(i-1));
        addcx(1:(i-1))= cx(1:(i-1));
        addcy(1:(i-1))= cy(1:(i-1));

        %clickcounts
        addframe(i) = clickcounts;
        addid(i) = id(1);
        addxmin(i)= matrix(1,1);
        addymin(i)= matrix(1,2);
        addw(i)= matrix(1,3);
        addh(i)= matrix(1,4);
        addcx(i)= matrix(1,5);
        addcy(i)= matrix(1,6);

        %clickcounts+1~end
        addframe(i+1:end) = frame(i:end);
        addid(i+1:end) = id(i:end);
        addxmin(i+1:end)= xmin(i:end);
        addymin(i+1:end)= ymin(i:end);
        addw(i+1:end)= w(i:end);
        addh(i+1:end)= h(i:end);
        addcx(i+1:end)= cx(i:end);
        addcy(i+1:end)= cy(i:end);
        
        fid=fopen(location_file_path,'w');
        for num = 1:length(frame)+1
            fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',addframe(num), addid(num),addxmin(num), addymin(num), addw(num), addh(num),addcx(num),addcy(num));
        end
        fclose(fid);
    elseif frame(i) == clickcounts
        frame(i) = clickcounts;
        xmin(i) =  matrix(1,1);
        ymin(i) =  matrix(1,2);
        w(i) =  matrix(1,3);
        h(i) =  matrix(1,4);
        cx(i) =  matrix(1,5);
        cy(i) =  matrix(1,6);
        fid=fopen(location_file_path,'w');
        for num = 1:length(frame)
            fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',frame(num), id(num),xmin(num), ymin(num), w(num), h(num),cx(num),cy(num));
        end
        fclose(fid);
    end
elseif ((frame(length(frame)) == clickcounts-1) && markframe == 1)
    fid=fopen(location_file_path,'at+');
    fprintf(fid,'%d,%d,', clickcounts, antID_num); 
    for j=1:1:n
        if j==n
            fprintf(fid,'%g\r\n',matrix(1,j));
        else
            fprintf(fid,'%g,',matrix(1,j));
        end
    end
    fclose(fid);
end

end


% --- Executes on button press in addframebutton.
function addframebutton_Callback(hObject, eventdata, handles)
% hObject    handle to addframebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global clickcounts
global N
global rect 
global location 
global filepath 
global origindataset_filepath
global maindir
global startFrame
global antID
global x
global ant_num

location = [];
clickcounts = 1;
x(1)=0;
x(2)=0;

startFrame = str2num(get(handles.keepstart,'String'));
guidata(hObject,handles);

if startFrame > 0 
    clickcounts = startFrame;
end

set(handles.edit1,'string',num2str(clickcounts));
axis off

maindir = origindataset_filepath;

subdirpath = fullfile( maindir, '*.jpg' );
images = dir(subdirpath); 
N=length(images); 
set(handles.TotalFrame,'string',num2str(N));
if startFrame > 0
    image_name=strcat(maindir,'\',num2str(clickcounts-1,'%06d'));
else
    image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'));
end
image_name=strcat(image_name,'.jpg');

image_name=strcat(maindir,'\',num2str(clickcounts,'%06d'),'.jpg');
img2=imread(image_name);

axes(handles.axes2);

imshow(img2)
hold on

% draw_bounding = 1;
% if draw_bounding == 1
%     drawbounding();
% end


S2 = regexp(filepath, '\', 'split');
ant_num = str2num(char(S2(end)));
if startFrame > 0
    location_filepath = "";
    for s = 1:length(S2)-1
        location_filepath = strcat(location_filepath,char(S2{s}),"\");
    end
    antID = char(S2(end));   
    antID_location = strcat(antID, '.txt');
    location_file_path= strcat(location_filepath,antID_location);
    txt_exist = exist(location_file_path, 'file');
    if txt_exist == 2  
        [data1,~,data3,data4,data5,data6,~,~]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
        i = 1;
        while i <= length(data1) && data1(i) < startFrame 
            i = i + 1;
        end
        f = i - 1;
        hold on
        rectangle('Position',[data3(f) data4(f) data5(f) data6(f)],'LineWidth',0.5,'EdgeColor','g','LineStyle','--');
        antIMAGE = num2str(str2num(antID));
        text(data3(f),data4(f),antIMAGE,'color','b','FontSize',16)
    end
end


axes(handles.axes2);
[x(1),x(2),~] = ginput(1);
hold on
plot(x(1),x(2),'.','Color','r', 'MarkerSize',12)
split_res = regexp(maindir, 'Image', 'split');
pixel_size = str2num(char(split_res(end)));

[high,width,~] = size(img2);

if x(1) < pixel_size/2 
    if x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
        [img2, rect] = imcrop(img2, [0, high- pixel_size, pixel_size, pixel_size]); 
    else 
        [img2, rect] = imcrop(img2, [0, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
elseif width - x(1) < pixel_size/2 
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [width - pixel_size, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [width - pixel_size, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
else 
    if x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, 0, pixel_size, pixel_size]); 
    elseif high - x(2) < pixel_size/2 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, high- pixel_size, pixel_size, pixel_size]); 
    else 
		[img2, rect] = imcrop(img2, [x(1)- pixel_size/2, x(2)- pixel_size/2, pixel_size, pixel_size]); 
    end
end

hold on
rectangle('Position',rect,'LineWidth',0.5,'EdgeColor','r');

S = regexp(filepath, '\', 'split');
antID = char(S(end));
antID_Image = strcat(antID, 'F',num2str(clickcounts,'%06d'));
image_name=strcat(filepath,'\',antID_Image,'.jpg');
imwrite(img2,image_name,'jpg');

location = [rect x(1) x(2)];

S2 = regexp(filepath, '\', 'split');
location_filepath = "";
for s = 1:length(S2)-1
    location_filepath = strcat(location_filepath,char(S2{s}),"\");
end
antID = S2(end);
antID_location = strcat(antID, '.txt');
location_file_path=char(strcat(location_filepath,antID_location));

matrix=location;
antID_num = str2num(char(antID));
[~,n]=size(matrix);
txt_exist = exist(location_file_path,'file');


[frame,id,xmin,ymin,w,h,cx,cy]=textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
i = 1;
while i <= length(frame) && frame(i) < startFrame
    i = i + 1; 
end
frame_sub = startFrame - frame(length(frame));
if frame_sub >= 2 
    mode=struct('WindowStyle','modal','Interpreter','tex');
    errordlg('The starting frame is out of range!','warning',mode);
    close
elseif frame_sub == 1
    fid=fopen(location_file_path,'a+');
    fprintf(fid,'%d,%d,', startFrame, antID_num);
    for j=1:n
        if j==n
            fprintf(fid,'%g\r\n',matrix(1,j));
        else
            fprintf(fid,'%g,',matrix(1,j));
        end
    end
    fclose(fid);
else 
    addframe = zeros(length(frame)+1,1);
    addid = zeros(length(frame)+1,1);
    addxmin= zeros(length(frame)+1,1);
    addymin= zeros(length(frame)+1,1);
    addw= zeros(length(frame)+1,1);
    addh= zeros(length(frame)+1,1);
    addcx= zeros(length(frame)+1,1);
    addcy= zeros(length(frame)+1,1);
    
    %1~startFrame-1
    addframe(1:(i-1)) = frame(1:(i-1));
    addid(1:(i-1)) = id(1:(i-1));
    addxmin(1:(i-1))= xmin(1:(i-1));
    addymin(1:(i-1))= ymin(1:(i-1));
    addw(1:(i-1))= w(1:(i-1));
    addh(1:(i-1))= h(1:(i-1));
    addcx(1:(i-1))= cx(1:(i-1));
    addcy(1:(i-1))= cy(1:(i-1));
    
    %startFrame
    addframe(i) = startFrame;
    addid(i) = id(1);
    addxmin(i)= matrix(1,1);
    addymin(i)= matrix(1,2);
    addw(i)= matrix(1,3);
    addh(i)= matrix(1,4);
    addcx(i)= matrix(1,5);
    addcy(i)= matrix(1,6);
    
    %startFrame+1~end
    addframe(i+1:end) = frame(i:end);
    addid(i+1:end) = id(i:end);
    addxmin(i+1:end)= xmin(i:end);
    addymin(i+1:end)= ymin(i:end);
    addw(i+1:end)= w(i:end);
    addh(i+1:end)= h(i:end);
    addcx(i+1:end)= cx(i:end);
    addcy(i+1:end)= cy(i:end);

    fid=fopen(location_file_path,'w');
    for num = 1:length(frame)+1
        fprintf(fid, '%g,%g,%g,%g,%g,%g,%g,%g\r\n',addframe(num), addid(num),addxmin(num), addymin(num), addw(num), addh(num),addcx(num),addcy(num));
    end
    fclose(fid);
end
end


% --- Executes on button press in merge_annotations.
function merge_annotations_Callback(hObject, eventdata, handles)
% hObject    handle to merge_annotations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filepath
global origindataset_filepath
global merge_output_dir

sub_img_path = fullfile( origindataset_filepath, '*.jpg' );
total_frames = length(dir(sub_img_path)); 
ant_files_path = fullfile(filepath,'*.txt'); 
ant_nums= length(dir(ant_files_path));
fprintf("ant_nums: %d", ant_nums);
%% det
det_file_dir = strcat(merge_output_dir,'\det\');
mkdir(det_file_dir)
det_file_path = strcat(det_file_dir,'det.txt');

fid_det=fopen(det_file_path,'a+');

%% gt
gt_file_dir = strcat(merge_output_dir,'\gt\');
mkdir(gt_file_dir)
gt_file_path = strcat(gt_file_dir, 'gt.txt');
fid_gt=fopen(gt_file_path,'a+');

%% img
img_file_path = strcat(merge_output_dir,'\img\');
mkdir(img_file_path)
image_List = dir(origindataset_filepath);
total_files = length(dir(fullfile(origindataset_filepath)));

f_bar = waitbar(0,'1','Name','Generating Img folder...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f_bar,'canceling',0);

for img = 1:1:total_files 

    % Check for clicked Cancel button
    if getappdata(f_bar,'canceling')
        break
    end
    
    % Update waitbar and message
    waitbar(img/(total_files-2),f_bar, sprintf('%d/%d',img, total_files-2))

    ori_name = image_List(img).name;
    if ~strcmp(ori_name,'.') && ~ strcmp(ori_name,"..")
        ori_img_path = strcat(origindataset_filepath, '\', image_List(img).name);        
        status = copyfile(ori_img_path,img_file_path);
    end 
end
delete(f_bar)

f_bar = waitbar(0,'1','Name','Generating det & gt folder...',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(f_bar,'canceling',0);

tic
for f=1:1:total_frames
    % Check for clicked Cancel button
    if getappdata(f_bar,'canceling')
        break
    end
    
    % Update waitbar and message
    waitbar(f/total_frames,f_bar, sprintf('%d/%d',f, total_frames))
    
    for ants = 1:1:ant_nums
        location_file_path = strcat(filepath,'\',num2str(ants, '%04d'),'.txt');
        [frame,id,xmin,ymin,w,h,cx,cy] = textread(location_file_path,'%n%n%n%n%n%n%n%n','delimiter', ',');
        index = find(frame==f);
        
        if index
            fprintf(fid_det, '%06g,-1,%g,%g,%g,%g,1\r\n',frame(index), xmin(index), ymin(index), w(index), h(index));
            fprintf(fid_gt, '%06g,%g,%g,%g,%g,%g,1\r\n',frame(index),id(index), xmin(index), ymin(index), w(index), h(index));
        end
    end
end

delete(f_bar);

fclose(fid_det);
fclose(fid_gt);

rmdir(filepath,'s')
% deleteTemp(filepath); % remove tmp annotations
toc

end


% --- Executes on button press in Merge_Output_Path.
function Merge_Output_Path_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_Output_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global merge_output_dir
merge_output_dir = uigetdir('*.*','Merge Output dir');

end
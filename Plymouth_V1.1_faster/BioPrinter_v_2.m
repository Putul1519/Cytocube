function varargout = BioPrinter_v_2(varargin)
% BioPrinter_v_2 MATLAB code for BioPrinter_v_2.fig
%      BioPrinter_v_2, by itself, creates a new BioPrinter_v_2 or raises the existing
%      singleton*.
%v_0 re0turnszs the handleSetA_23111``1q`       `1312Callback to a new BioPrinter_v_0 or the handle tao
%      the existing singleton*.]
%      H = BioPrfvt  gtrfvrinter_
%
%      BioPrinter_v_0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BioPrinter_v_0.M with the given input arguments.
%
%      BioPrinter_v_0('Property','Value',...) creates a new BioPrinter_v_0 or raises the
%      existing singleton*.  Starting from the docccfwnwards, property value pairs are
%      applied to the GUI before BioPrinter_1`v_0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BioPrinter_v_0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLE




% Edit the above text to modify the response to help BioPrinter_v_0

% Last Modified by GUIDE v2.5 21-Jan-2021 12:32:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BioPrinter_v_2_OpeningFcn, ...
                   'gui_OutputFcn',  @BioPrinter_v_2_OutputFcn, ...
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

% --- Outputs from this function are returned to the command line.
function varargout = BioPrinter_v_2_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes just before BioPrinter_v_2 is made visible.
function BioPrinter_v_2_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BioPrinter_v_2 (see VARARGIN

% Choose default command line output for BioPrinter_v_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Choose default command line output for Cytocube_v1_4
%handles.output = hObject;
disp('Booting.............');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Start serial port
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s=serial('COM13');
set(s,'BaudRate',57600);   set(s,'Terminator','#');    
set(s,'Timeout',30);  %  s.RecordName = 'CytoSerialTxnLog.txt';    
fopen(s);   record(s);
handles.s = s;
disp('Arduino initialized')

msg=strcat('logs/',datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s'); 
fid = fopen(strcat(msg,'.txt'),'w');
disp('msg string created');

handles.fid = fid;
if (fid == -1)
    disp('could not open logging file. You probably need to change working directory to the one where the MATLAB file is located.');
    %return;
end

%disp('fid updated');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Start cam
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%fprintf(fid, '\r\nStarting camera...');
% choose which webcam (winvideo-1) and which  mode (YUY2_176x144)
%vid = videoinput('winvideo', 1, 'RGB32_744x480');
vid = videoinput('winvideo',2,'YUY2_640x480');
vid1= videoinput('winvideo',3,'YUY2_640x480');


% pause(5);
% src.BalanceWhiteAuto = 'continuous';
% closepreview (vid);
% vid = videoinput('gentl', 1, 'Mono8');
%src = getselectedsource(vid);
%src1 = getselectedsource(vid1);
%pause(1);

%% ####################### Added on 05.11.19 by Aravind #############
vid.LoggingMode = 'disk&memory';

%src.AcquisitionTimeout = 5000;
% src.LineSource = 'Off';
% triggerconfig(vid, 'manual');
% vid.TriggerRepeat = Inf;
% ####################### End  #############

% % temp : debug . ROI
% set(vid,'ROIPosition',[0 0 1280 1024]);

% Configure the object for manual trigger mode.
% triggerconfig(vid, 'manual');
% only capture one framecc
%per trigger, we are not recording a video
% vid.FramesPerTrigger = 1;
% output would image in RGB color space
vid.ReturnedColorspace = 'rgb';
vid1.ReturnedColorspace = 'rgb';
% vid.ReturnedColorspace = 'grayscale';
% tell matlab to start the webcam on user request, not automatically
triggerconfig(vid, 'manual');
triggerconfig(vid1, 'manual');
% we need this to know the image height and width
vidRes = get(vid, 'VideoResolution');
vidRes1 = get(vid1, 'VideoResolution');
% image width
imWidth = vidRes(1);
imWidth1 = vidRes1(1);
% image height
imHeight = vidRes(2);
imHeight1 = vidRes1(2);
% number of bands of our image (should be 3 because it's RGB)
nBands = get(vid, 'NumberOfBands');
nBands1 = get(vid1, 'NumberOfBands');
% create an empty image container and show it on axPreview
hImage = image(zeros(imHeight, imWidth, nBands), 'parent', handles.axPreview);
hImage1 = image(zeros(imHeight1, imWidth1, nBands1), 'parent', handles.axPreview1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do auto white balance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
src = getselectedsource(vid);
src1 = getselectedsource(vid1);

% src.BalanceWhiteAuto = 'continuous';
% get(vid)
% get(src)
% begin the webcam preview
preview(vid, hImage);
disp("Camera preview initialized")
preview(vid1, hImage1);
% expose the objects so we can handle them in other functions
handles.vid = vid;
handles.vid1 = vid1;
handles.src = src;
handles.src1 = src1;
guidata(hObject,handles);
%start(vid);
%start(vid1);
drawnow;     

% set and display the setexposure
%src.ExposureTime  = 400;
%set(handles.expDisp,'string', src.ExposureTime );
Time_to_init_cam = toc;

%src.BalanceWhiteAuto = 'once';

% clear the message
%set(handles.camwait,'string',' ');

% setup the timer for pos update
% tmr = timer('ExecutionMode', 'fixedSpacing','Period',1,'TimerFcn', {@timerCallback,handles});
% start(tmr); handles.tmr = tmr;

% this is the slide name 
setslidename = 'S';
handles.setslidename = setslidename;

%start(vid);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The timer function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function timerCallback( ~,~,handles  )%varargin)  ~,struct2,~
% try
%     query_X(handles);  query_Y(handles);  query_Z(handles);
% catch
%     disp('timer error');
 


% --- Executes on button press in Upwards.

    
    function Up_Callback(hObject, eventdata, handles)

 MOVE_Up(handles);
 
% --- Executes on button press in Downwards.
function DOWN_Callback(hObject, eventdata, handles)

 MOVE_DOWN(handles);

% --- Executes on button press in Right.
function RIGHT_Callback(hObject, eventdata, handles)
    
 MOVE_RIGHT(handles);

 % --- Executes on button press in Left.
function LEFT_Callback(hObject, eventdata, handles)

 MOVE_LEFT(handles);
 
 % executes Z upwards movement 
 function ZPLUS_Callback(hObject, eventdata, handles)
     
 MOVE_ZPLUS(handles);
 
 %executes Z downwards movement
 function ZMINUS_Callback(hObject, eventdata, handles)

 MOVE_ZMINUS(handles);
 
 
function FineUp_Callback(hObject, eventdata, handles)

 MOVE_FineUp(handles);
 
function FineDown_Callback(hObject, eventdata, handles)

 MOVE_FineDown(handles);
 
function FineRight_Callback(hObject, eventdata, handles)

 MOVE_FineRight(handles);
 
function FineLeft_Callback(hObject, eventdata, handles)

 MOVE_FineLeft(handles);
 
     
function Compress_Callback(hObject,evendata,handles)
    
    MOVE_Compress(handles);
    
function Pull_Callback(hObject,evendata,handles)
    
    MOVE_Pull(handles);


function extract_Callback(hObject,evendata,handles)
    MOVE_extract(handles);
    
   
    


function dispense_Callback(hObject,evendata,handles)
    
    MOVE_Compress(handles);
    
function loadtip_Callback(hObject,evendata,handles)
    
    MOVE_loadtip(handles);
% 
%  function Load_Sample_Callback(hObject, eventdata, handles)
% 
%  MOVE_Load_Sample(handles);
%  
%  function Unload_Sample_Callback(hObject, eventdata, handles)
% 
%  MOVE_Unload_Sample(handles);
% 
%  
% function X_left_Callback(hObject,evendata,handles)
%     
%     MOVE_Xleft(handles);
%     
% function X_right_Callback(hObject,evendata,handles)
%     
%     MOVE_Xright(handles);
    
    
    
function Z_up_Callback(hObject,evendata,handles)
    
    MOVE_Zup(handles);

function Zdown_Callback(hObject,evendata,handles)
    
    MOVE_Zdown(handles);
    
function home_Callback(hObject,eventdata,handles) 
    MOVE_home(handles);


    %set(handles.pushbutton86,'string','Running','ForegroundColor','red','enable','off');
    
function sensor_Callback(hObject,eventdata,handles)   
   
    MOVE_sensor(handles);
    
function press_Callback(hObject,eventdata,handles)   
   
MOVE_press(handles);

function release_Callback(hObject,eventdata,handles)   
   
MOVE_release(handles);
    
   
% function start_Callback(hObject,evendata, handles)
% %starts automated dispensing mechanism 
% %s = handles.s;  %vid = handles.vid ; fid=handles.fid;  resetbutton=handles.Reset;
% 
% for A = 1:2 
%     for i = 1: 40
%         MOVE_ZPLUS(handles);%%Y axis moves back
%         MOVE_ZMINUS(handles);%% z axis moved down
%     end 
%   
% 
%     for k = 1: 4
%         MOVE_Compress(handles); %% Z' moves
%     end
% 
%     for l = 1: 60
%         MOVE_ZPLUS(handles); %% Z axis moves up
%         MOVE_DOWN(handles);%% Y axis moves front
%     end 
% 
%     for n = 1: 60
%         MOVE_RIGHT(handles);%% X axis moves to the left
%         MOVE_ZMINUS(handles);%% Z axis comes down again
%     end 
% 
%     for p = 1: 4 
%         MOVE_Pull(handles); %% Z' dispenses
%     end 
%     
%     for q = 1: 60 
%         MOVE_ZPLUS(handles); %% Z axis moves back up again
%     end 
% %%process repeated 30 times
% end
%  
 
%%---movement methods for all motors--%%
function MOVE_RIGHT(handles)
s = handles.s;    
fprintf(s,'k');
disp(s);

function MOVE_LEFT(handles)
s = handles.s;     
fprintf(s,'l');
disp(s);

function MOVE_Up(handles) %%back
s = handles.s;     
fprintf(s,'jjj');
disp(s);

function MOVE_DOWN(handles) %% front
s = handles.s;     
fprintf(s,'iii');
disp(s);

function MOVE_FineRight(handles)
s = handles.s;    
fprintf(s,'a');
disp(s);

function MOVE_FineLeft(handles)
s = handles.s;    
fprintf(s,'b');
disp(s);

function MOVE_FineUp(handles)
s = handles.s;    
fprintf(s,'d');
disp(s);

function MOVE_FineDown(handles)
s = handles.s;    
fprintf(s,'c');
disp(s);

function MOVE_press(handles)
s = handles.s;    
fprintf(s,'g');
disp(s);

function MOVE_release(handles)
s = handles.s;    
fprintf(s,'h');
disp(s);


function MOVE_ZPLUS(handles) %% moves upward
s = handles.s;     
fprintf(s,'e');
disp(s);


function MOVE_ZMINUS(handles) %% moves downward
s = handles.s;     
fprintf(s,'f');
disp(s);

function MOVE_Pull(handles) %% release
s = handles.s;     
fprintf(s,'hhhhhhhhhhhhhhhhhhhhhhhhhh'); 
disp(s);
        
function MOVE_Compress(handles) %% compress
set(handles.pushbutton54,'string','Running','ForegroundColor','red','enable','off');
s = handles.s;     
fprintf(s,'q');  
pause(5.0)
set(handles.pushbutton54,'string','DISPENSE','ForegroundColor','blue','enable','on');

function MOVE_extract(handles) %% compress
%set(handles.pushbutton71,'string','Running','ForegroundColor','red','enable','off');
s = handles.s;     
fprintf(s,'p');  
%pause(14.0);
%set(handles.pushbutton71,'string','EXTRACT','ForegroundColor','black','enable','on');

% function MOVE_Xleft(handles)
% s = handles.s;     
% fprintf(s,'lllllllllllllllllllllllllllllllllllllllllllllllllll'); 
% 
% function MOVE_Xright(handles)
% s = handles.s;     
% fprintf(s,'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
% 
% function MOVE_Unload_Sample(handles)
% s = handles.s;     
% fprintf(s,'iiiiiiiiiiiiiii'); 
% 
% function MOVE_Load_Sample(handles)
% s = handles.s;     
% fprintf(s,'jjjjjjjjjjjjj');


function MOVE_Zup(handles)
s = handles.s;     
fprintf(s,'rrrrrrrrrr'); 

function MOVE_Zdown(handles)
s = handles.s;     
fprintf(s,'Q');

    
function MOVE_home(handles)
    %set(handles.pushbutton86,'string','Running','ForegroundColor','red','enable','off');
    s = handles.s;
    fprintf(s,'z');
    %pause(5.0);
    %set(handles.pushbutton86,'string','HOME','ForegroundColor','black','enable','on');
    
   
   
function MOVE_sensor(handles)
    set(handles.pushbutton79,'string','Running','ForegroundColor','red','enable','off');
    s = handles.s;
    fprintf(s,'y');
    pause(10.0);
    set(handles.pushbutton79,'string','GO TO DEVICE','ForegroundColor','black','enable','on');
    
    
function MOVE_loadtip(handles)
    s = handles.s;
    fprintf(s,'Z');

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);


function [] = query_X(handles)
s = handles.s; fwrite(s,'I');  data = fgetl(s);

if(data == 'X')
    set(handles.currxpos,'string',fgetl(s));
else
    data = fgetl(s); disp(sprintf('not X data - %s',data)); 
end

function [] = query_Y(handles)
s = handles.s;  fwrite(s,'O');  data = fgetl(s);

if(data == 'Y')
    set(handles.currypos,'string',fgetl(s));
else
    data = fgetl(s);  disp(sprintf('not Y data - %s',data)); 
end

function [] = query_Z(handles)
s = handles.s;  fwrite(s,'P'); data = fgetl(s);

if(data == 'Z')
    set(handles.currzpos,'string',fgetl(s));
else
    data = fgetl(s);     disp(sprintf('not Y data - %s',data)); 
end



% AUTOCONTRAST  Automatically adjusts contrast of images to optimum level.
%    e.g. autocontrast('Sunset.jpg','Output.jpg')
       
    
%%----set XYZ home callbacks----%%
% --- Executes on button press in SetasY.
function SetasY_Callback(~, ~, handles)
    
s = handles.s;  fprintf(s, 'K');


% --- Executes on button press in SetasX.
function SetasX_Callback(~, ~, handles)

s = handles.s;  fprintf(s, 'J');

% --- Executes on button press in SetasZ.
function SetasZ_Callback(~, ~, handles)

s = handles.s;  fprintf(s, 'L');


% --- Executes on button press in SetAllHome.
function SetAllHome_Callback(~, ~, handles)

s = handles.s;  fprintf(s, 'J');  fprintf(s, 'K'); fprintf(s, 'L');

    

function varargout = Sicklescope_v_2_1(varargin)
% Sicklescope_v_2_1 MATLAB code for Sicklescope_v_2_1.fig
%      Sicklescope_v_2_1, by itself, creates a new Sicklescope_v_2_1 or raises the existing
%      singleton*.
%
%      H = Sicklescope_v_2_1 returns the handleSetA_Callback to a new Sicklescope_v_2_1 or the handle tao
%      the existing singleton*.
%
%      Sicklescope_v_2_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Sicklescope_v_2_1.M with the given input arguments.
%
%      Sicklescope_v_2_1('Property','Value',...) creates a new Sicklescope_v_2_1 or raises the
%      existing singleton*.  Starting from the downwards, property value pairs are
%      applied to the GUI before Sicklescope_v_2_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sicklescope_v_2_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sicklescope_v_2_1

% Last Modified by GUIDE v2.5 25-Nov-2019 10:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sicklescope_v_2_1_OpeningFcn, ...
                   'gui_OutputFcn',  @Sicklescope_v_2_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
%if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
%end

function Sicklescope_v_2_1_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sicklescope_v_2_1 (see VARARGIN)

% Choose default command line output for Sicklescope_v_2_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Choose default command line output for Cytocube_v1_4
handles.output = hObject;
disp('Booting.............');

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
 gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT

% --- Outputs from this function are returned to the command line.
function varargout = Sicklescope_v_2_1_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes just before Sicklescope_v_2_1 is made visible.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Start serial port
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = serialport('COM9',57600,"Timeout",30);
configureTerminator(s,1);
%set(s,'BaudRate',57600);   
%set(s,'Terminator','#');    
%set(s,'Timeout',30);  %  
s.RecordName = 'CytoSerialTxnLog.txt';    
fopen(s);  % record(s);
handles.s = s;

msg=strcat('logs/',datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s'); 
fid = fopen(strcat(msg,'.txt'),'w');
handles.fid = fid;
if (fid == -1)
    disp('could not open logging file. You probably need to change working directory to the one where the MATLAB file is located.');
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Start cam
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf(fid, '\r\nStarting camera...');
% choose which webcam (winvideo-1) and which  mode (YUY2_176x144)
%vid = videoinput('winvideo', 1, 'RGB32_744x480');
%% 

vid = videoinput('gentl', 1, 'BGRA8Packed');

% pause(5);
% src.BalanceWhiteAuto = 'continuous';
% closepreview (vid);
% vid = videoinput('gentl', 1, 'Mono8');
src = getselectedsource(vid);
pause(1);

%% ####################### Added on 05.11.19 by Aravind #############
vid.LoggingMode = 'disk&memory';

src.AcquisitionTimeout = 5000;
% src.LineSource = 'Off';
% triggerconfig(vid, 'manual');
% vid.TriggerRepeat = Inf;
% ####################### End  #############
%%



% % temp : debug . ROI
% set(vid,'ROIPosition',[0 0 1280 1024]);

% Configure the object for manual trigger mode.
% triggerconfig(vid, 'manual');
% only capture one frame per trigger, we are not recording a video
% vid.FramesPerTrigger = 1;
% output would image in RGB color space
vid.ReturnedColorspace = 'rgb';
% vid.ReturnedColorspace = 'grayscale';
% tell matlab to start the webcam on user request, not automatically
triggerconfig(vid, 'manual');
% we need this to know the image height and width
vidRes = get(vid, 'VideoResolution');
% image width
imWidth = vidRes(1);
% image height
imHeight = vidRes(2);
% number of bands of our image (should be 3 because it's RGB)
nBands = get(vid, 'NumberOfBands');
% create an empty image container and show it on axPreview
hImage = image(zeros(imHeight, imWidth, nBands), 'parent', handles.axPreview);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do auto white balance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
src = getselectedsource(vid);

% src.BalanceWhiteAuto = 'continuous';
% get(vid)
% get(src)
% begin the webcam preview
preview(vid, hImage);
% expose the objects so we can handle them in other functions
handles.vid = vid;
handles.src = src;
guidata(hObject,handles);
%start(vid);
drawnow;     

% set and display the setexposure
src.ExposureTime  = 400;
set(handles.expDisp,'string', src.ExposureTime );
Time_to_init_cam = toc;

src.BalanceWhiteAuto = 'once';


% clear the message
set(handles.camwait,'string',' ');

% setup the timer for pos update
tmr = timer('ExecutionMode', 'fixedSpacing','Period',1,'TimerFcn', {@timerCallback,handles});
start(tmr); handles.tmr = tmr;

% this is the slide name 
setslidename = 'S';
handles.setslidename = setslidename;

%start(vid);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  The timer function 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function timerCallback( ~,~,handles  )%varargin)  ~,struct2,~
try
    query_X(handles);  query_Y(handles);  query_Z(handles);
catch
    %disp('timer error');
end


% --- Executes on button press in SetExposure.
function SetExposure_Callback(~, ~, handles)
% hObject    handle to SetExposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid=handles.fid;    src = handles.src;  
set(handles.camwait,'string','Updating exposure value...');
fprintf(fid, '\r\nUpdating exposure value...');
newExp = get(handles.camExpEdit,'string');
numVal = str2double(newExp);   src.ExposureTime = numVal;
set(handles.expDisp,'string',newExp);
fprintf(fid, '\r\nExposure value updated to %d microsecond',numVal);
set(handles.camwait,'string','Camera exposure changed.');


function camExpEdit_Callback(~, ~, ~)
% hObject    handle to camExpEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of camExpEdit as text
%        str2double(get(hObject,'String')) returns contents of camExpEdit as a double


% --- Executes during object creation, after setting all properties.
function camExpEdit_CreateFcn(hObject, ~, ~)
% hObject    handle to camExpEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GotoXhome.
function GotoXhome_Callback(~, ~, handles)
% hObject    handle to GotoXhome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'B');  fprintf(s, '0000000');


% --- Executes during object creation, after setting all properties.
function GotoX_value_CreateFcn(hObject, ~, ~)
% hObject    handle to GotoX_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function GotoX_value_Callback(~, ~, ~)
% hObject    handle to GotoX_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoX_value as text
%        str2double(get(hObject,'String')) returns contents of GotoX_value as a double


% --- Executes on button press in GotoX.
function GotoX_Callback(~, ~, handles)
% hObject    handle to GotoX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;
% format the number properly --------------------------------------------
str = get(handles.GotoX_value,'string') ;
check = str2double(str);
% ensure that too big values dont go in
if (check < -250000)
    check = -250000;
elseif (check > 250000)
    check = 250000;
end

str = sprintf('%06d',abs(check));     % abs needed so that no +&- in neg numbers

if(check < 0)
    newstr = strcat('-',str);
else
    newstr = strcat('+',str);
end
% end formatting ---------- --------------------------------------------
fprintf(s,'B');
fprintf(s, newstr );
           


% --- Executes on button press in GotoYhome.
function GotoYhome_Callback(~, ~, handles)
% hObject    handle to GotoYhome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'N');  fprintf(s, '0000000');


function GotoY_value_Callback(~, ~, ~)
% hObject    handle to GotoY_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoY_value as text
%        str2double(get(hObject,'String')) returns contents of GotoY_value as a double


% --- Executes during object creation, after setting all properties.
function GotoY_value_CreateFcn(hObject, ~, ~)
% hObject    handle to GotoY_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GotoY.
function GotoY_Callback(~, ~, handles)
% hObject    handle to GotoY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;
% format the number properly --------------------------------------------
str = get(handles.GotoY_value,'string');        check = str2double(str);
% ensure that too big values dont go in
if (check < -250000)
    check = -250000;
elseif (check > 250000)
    check = 250000;
end;

str = sprintf('%06d',abs(check));     % abs needed so that no +&- in neg numbers

if(check < 0)
    newstr = strcat('-',str);
else
    newstr = strcat('+',str);
end;
% end formatting ---------- --------------------------------------------
fprintf(s,'N');                 fprintf(s, newstr );


% --- Executes on button press in GotoZhome.
function GotoZhome_Callback(~, ~, handles)
% hObject    handle to GotoZhome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'M');  fprintf(s, '0000000');

% --- Executes on button press in All_Home.
function All_Home_Callback(~, ~, handles)
% hObject    handle to All_Home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% s = handles.s;  fprintf(s, 'B');  fprintf(s, '0000000');  fprintf(s, 'N');  fprintf(s, '0000000'); fprintf(s, 'M');  fprintf(s, '0000000');
s = handles.s;  tmr=handles.tmr;

toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

fprintf(s, ',');  fprintf(s, '0000000');    fprintf(s, '0000000');   fprintf(s, '0000000');
start(tmr);
% pause(10);


function GotoZ_value_Callback(~, ~, ~)
% hObject    handle to GotoZ_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoZ_value as text
%        str2double(get(hObject,'String')) returns contents of GotoZ_value as a double


% --- Executes during object creation, after setting all properties.
function GotoZ_value_CreateFcn(hObject, ~, ~)
% hObject    handle to GotoZ_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GotoZ.
function GotoZ_Callback(~, ~, handles)
% hObject    handle to GotoZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;
% format the number properly --------------------------------------------
    str = get(handles.GotoZ_value,'string');        check = str2double(str);
    % ensure that too big values dont go in
    if (check < -200000)        
        check = -200000;
    elseif (check > 150000)    
        check = 150000;
    end 
    
    str = sprintf('%06d',abs(check));     % abs needed so that no +&- in neg numbers
    
    if(check < 0)                 
                   newstr = strcat('-',str);
              else
                   newstr = strcat('+',str);
    end
% end formatting ---------- --------------------------------------------
              fprintf(s,'M');                 fprintf(s, newstr ); 


% --- Executes during object creation, after setting all properties.
function AreaScan_CreateFcn(hObject, ~, ~)
% hObject    handle to AreaScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject,'enable','off');


% --- Executes on button press in AreaScan.
function AreaScan_Callback(~, ~, handles)
% hObject    handle to AreaScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  vid = handles.vid ; fid=handles.fid;  resetbutton=handles.Reset;

AS_travel = 1000; AS_step = 10;

% this is the user selected tile size for area scan
TileSizeX = str2double (handles.TileSizeX)
TileSizeY = str2double (handles.TileSizeY)
%   TileSizeY = 2;

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

tic;

set(handles.camwait,'string','Custom area scan started.');

setslidename = handles.setslidename;
fprintf(fid, '\r\nStarting area scan...');
XFoVSize = 2000;        YFoVSize = 1600;
%XFoVSize = 914;        YFoVSize = 1141;
%                             XPulseRate = 38400;     YPulseRate = 38400 ;

msg=strcat('Area_scan','.csv');
A_scan = fopen(msg,'w');

%                             clc

% get the co-ods
xA = str2double(handles.xA);    xB = str2double(handles.xB);    xC = str2double(handles.xC);
yA = str2double(handles.yA);    yB = str2double(handles.yB);    yC = str2double(handles.yC);
zA = str2double(handles.zA);    zB = str2double(handles.zB);    zC = str2double(handles.zC);

% find num of FoV
numofX = round (abs(xB - xA) / XFoVSize) + 1      %Zeroth position has one FoV
numofY = round (abs(yC - yB) / YFoVSize) + 1

%Finding number of reference points to be
%scanned
%                             TileSizeX = 5;
%                             TileSizeY = 6;

numoftilesinX = ceil (numofX / TileSizeX)        % Taking just integer value
numoftilesinY = ceil (numofY / TileSizeY)

Xdir = (abs(xB-xA))/(xB-xA);
Ydir = (abs(yC-yB))/(yC-yB);
Zdir = 1;

%                             gotoX(xA, handles); gotoY(yA, handles); gotoZ(zA, handles);
%                             pause(1);
Xnow = xA;
Ynow = yA;
Zref(1)= zA;
%                             Zref(2)= zA;
Zref(3)= 0;
Zarray(TileSizeX*TileSizeY) = 0;

Slno = 1;          % Sl number for images captured

for Xtile = 1: numoftilesinX
    for Ytile = 1: numoftilesinY                       % to be used
        
        disp('-----------------------------------------------------------')
        xcount_value = Xtile
        ycount_value = Ytile
        
        Xref(1) = Xnow;
        Yref(1) = Ynow;
        
        if Xtile ~= 1 && Ytile == 1                 %Case for each X shift except the first X value
            Zref(1) = Zref(3)
        else
%             gotoXYZ(Xnow, Ynow, Zref(1), handles);
            gotoX(Xnow, handles);
            gotoY(Ynow, handles);
            gotoZ(Zarray(TileSizeX*TileSizeY), handles);     % For going to the known nearest FoV Z position
            pause(0.15);
            %                                         pause(0.1);
            Zref(1) = AutoFocus(handles,AS_travel,AS_step)
        end
        
        if Ytile == 1              %calculate Zref(2) only on the first tile on all Xtile values
            Xref(2) = Xnow + (Xdir * (TileSizeX - 1) * XFoVSize);
            Xnow = Xref(2);
%             gotoXYZ(Xnow, Ynow, Zref(1), handles);
            gotoX(Xnow, handles);
            gotoY(Ynow, handles);   % check if this line cud be avoided
            gotoZ(Zref(1), handles);   % For going to the known nearest FoV Z position
            pause(0.15);
            Zref(2) = AutoFocus(handles,AS_travel,AS_step)
        else
            Zref(2) = Zref(3)
            Xnow = Xref(2);
            gotoX(Xnow, handles);
        end
        
        Yref(3) = Ynow + (Ydir * (TileSizeY - 1) * YFoVSize);
        Ynow = Yref(3);
%         gotoXYZ(Xnow, Ynow, Zref(2), handles);
        gotoY(Ynow, handles);
        gotoZ(Zref(2), handles);    % For going to the known nearest FoV Z position
        pause(0.15);
        Zref(3) = AutoFocus(handles,AS_travel,AS_step)
        
        %Calculating Zshifts in X & Y
        ZshiftinY = Zref(3) - Zref(2)
        
        if (Ytile == 1) && (Xtile == 1)         % See excel sheet, special case for first yellow boxes
            ZshiftinYperFoV = round (ZshiftinY / (TileSizeY - 1))
            ZshiftinX = Zref(2) - Zref(1)
            ZshiftinXperFoV = round (ZshiftinX / (TileSizeX - 1))
        elseif (Ytile == 1) && (Xtile ~= 1)                     % Special case for other yellow boxes
            ZshiftinYperFoV = round (ZshiftinY / (TileSizeY - 1))
            ZshiftinX = Zref(2) - Zref(1)
            ZshiftinXperFoV = round (ZshiftinX / TileSizeX)
            Zref(1) = Zref(1) + ZshiftinXperFoV
        else
            ZshiftinYperFoV = round (ZshiftinY / TileSizeY) %General case- green boxes
            Zref(2) = Zref(2) + ZshiftinYperFoV
            ZshiftinX = Zref(2) - Zref(1)
            ZshiftinXperFoV = round (ZshiftinX / (TileSizeX - 1))
        end
        
        % Storing array of Z
        Arr_count = 1;
        Znow = Zref(1);
        for Ysteps=1: TileSizeY             %As the last value need to be saved into the array
            for Xsteps=1: TileSizeX
                
                Zarray(Arr_count) = Znow;
                Znew = Znow + ( Zdir * ZshiftinXperFoV );
                if (Xsteps <= (TileSizeX - 1))
                    Znow = Znew;
                end
                Arr_count = Arr_count+1;
            end
            
            Znew = Znow + ZshiftinYperFoV;
            if (Ysteps <= (TileSizeY - 1))
                Znow = Znew;
            end
            Zdir = Zdir * -1;
        end
        
        Zarray(Arr_count) = 0;      % To compensate for an error in the loop for focus
%         Zarray
        
        %% *Beginning image capture*
%         gotoXYZ(Xref(1), Yref(1), Zref(1), handles);
%         pause(TileSizeX/2);
        gotoX(Xref(1), handles); gotoY(Yref(1), handles); gotoZ(Zref(1), handles);
        pause(0.25);
        
        Xnow = Xref(1);
        Ynow = Yref(1); 
        Znow = Zref(1);
        Zdir = 1;
        
        Arr_count = 1;
        for Ysteps=1: TileSizeY
            for Xsteps=1: TileSizeX
                if mod(Ysteps,2) == 0              % To name the images in proper sequence
                    Xsteps2 = TileSizeX - Xsteps + 1;
                else
                    Xsteps2 = Xsteps;
                end
                
                if mod(Xtile,2) == 0               % To name the images in proper sequence
                    ycount2 = numoftilesinY - Ytile + 1;
                    Ysteps2 = TileSizeY - Ysteps + 1;
                else
                    ycount2 = Ytile;
                    Ysteps2 = Ysteps;
                end
%% For Stacking, enable the next two lines and disable four lines after them.
%                 filename = strcat(num2str(Xnow),'_',num2str(Ynow),'-',setslidename,num2str(Slno),'_X',num2str(Xtile),'-Y',num2str(ycount2),'_x',num2str(Xsteps2),'-y',num2str(Ysteps2));
%                 [Znow,imgvar] = QuickStack(handles,filename);  % To do a smaller focal stack at every FoV #added by aravind on 21.11.19
%%
                filename = strcat(num2str(Xnow),'_',num2str(Ynow),'-',setslidename,num2str(Slno),'_X',num2str(Xtile),'-Y',num2str(ycount2),'_x',num2str(Xsteps2),'-y',num2str(Ysteps2),'.jpg');
                snapshot=getsnapshot(vid);
                imwrite(snapshot,filename);
                imgvar = var(double(snapshot(:)));
                
                fprintf(A_scan,num2str(filename));
                fprintf(A_scan,',');
                fprintf(A_scan,num2str(Xnow));
                fprintf(A_scan,',');
                fprintf(A_scan,num2str(Ynow));
                fprintf(A_scan,',');
                fprintf(A_scan,num2str( Zarray(Arr_count)));
                fprintf(A_scan,',');
                fprintf(A_scan,num2str(Znow));
                fprintf(A_scan,',');
                fprintf(A_scan,num2str(imgvar));
                fprintf(A_scan,'\n');
                
                Slno = Slno + 1;          % Sl number for images captured
                
                Xnew = Xnow + ( Xdir * XFoVSize );
%                 Znew = Zarray(Arr_count);
                if (Xsteps <= (TileSizeX - 1))
                    Arr_count = Arr_count+1;
                    Znew = Zarray(Arr_count);
                    Xnow = Xnew; Znow = Znew;
                    gotoX(Xnow, handles);
                    gotoZ(Znow,handles);
                    pause(0.15);
                end
            end
            
            Ynew = Ynow + (Ydir * YFoVSize);
%             Znew = Zarray(Arr_count);
            if (Ysteps <= (TileSizeY - 1))
                Arr_count = Arr_count+1;
                Znew = Zarray(Arr_count);
                Znow = Znew;     Ynow = Ynew;
                %                                             gotoXYZ(Xnow, Ynow, Znow, handles);
                gotoY(Ynow, handles);
                gotoZ(Znow,handles);
                pause (0.15);
            end
            Xdir = Xdir * -1;
            Zdir = Zdir * -1;
        end
        
        Ynew = Ynow + (Ydir * YFoVSize);
        Ynow = Ynew;
    end
    Ydir = Ydir * -1;
    Ynew = Ynow + (Ydir * YFoVSize);
    Xnew = Xnow + ( Xdir * TileSizeX * XFoVSize);
    Ynow = Ynew;
    Xnow = Xnew;
end


% display time elapsed
time_to_scan_area = toc
% %numofY*numofX
msg = sprintf('\r\nImages captured : %d x %d', numofY,numofX);
fprintf(fid, msg);
% %                             pause(5);
if toTurnOnOrNot ==1
    start(tmr);
end

set(handles.camwait,'string','Custom area scan completed.');


    
% --- Executes on button press in WSI_Scan.
function WSI_Scan_Callback(~, ~, handles)
% hObject    handle to WSI_Scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  vid = handles.vid ; fid=handles.fid;  resetbutton=handles.Reset;

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

tic;

set(handles.camwait,'string','Custom area scan started.');

setslidename = handles.setslidename;
fprintf(fid, '\r\nStarting area scan...');
XFoVSize = 2000;        YFoVSize = 1600;
%XFoVSize = 914;        YFoVSize = 1141;
XPulseRate = 38400;     YPulseRate = 38400 ;


% get the co-ods
xA = str2double(handles.xA);    xB = str2double(handles.xB);    xC = str2double(handles.xC);
yA = str2double(handles.yA);    yB = str2double(handles.yB);    yC = str2double(handles.yC);
zA = str2double(handles.zA);    zB = str2double(handles.zB);    zC = str2double(handles.zC);

% find num of FoV

numofX = (abs(xB - xA) / XFoVSize)      %Zeroth position has one FoV, but let's ignore that to agree with delta Z calculations in X & Y
numofY = (abs(yC - yB) / YFoVSize)

Xdir = (abs(xB-xA))/(xB-xA);
Ydir = (abs(yC-yB))/(yC-yB);
Zdir = 1;

msg=strcat('Area_scan_old','.csv');
A2_scan = fopen(msg,'w');


ZshiftinX = zB-zA;   ZshiftinY = zC-zB;
ZshiftinXperFoV = round (ZshiftinX / numofX);
ZshiftinYperFoV = round (ZshiftinY / numofY);



gotoX(xA, handles); gotoY(yA, handles); gotoZ(zA, handles);
pause (1);
Xnow = xA;
Ynow = yA;
Znow = zA;

Slno = 1;          % Sl number for images captured

% Storing array of Z
Arr_count = 1;
for Ysteps=1: (numofY+1)
    for Xsteps=1: (numofX+1)
        
        Zarray(Arr_count) = Znow;
        Znew = Znow + ( Zdir * ZshiftinXperFoV );
        if (Xsteps <= numofX)
            Znow = Znew;
        end
        Arr_count = Arr_count+1;
    end
    
    Znew = Znow + ZshiftinYperFoV;
    if (Ysteps <= numofY)
        Znow = Znew;
    end
    Zdir = Zdir * -1;
end

Zarray(Arr_count) = 0;      % To compensate for an error in the loop for focus
Zarray;

Xnow = xA;
Ynow = yA;
Znow = zA;
Zdir = 1;
Arr_count = 2;

for Ysteps=1: (numofY + 1)
    for Xsteps=1: (numofX + 1)
        snapshot=getsnapshot(vid);
        filename = strcat(num2str(Xnow),'-',num2str(Ynow),'_',setslidename,num2str(Slno),'_',num2str(Ysteps),'-',num2str(Xsteps), '.jpg');
        imwrite(snapshot,filename);
        imgvar = var(double(snapshot(:)));
        
        fprintf(A2_scan,num2str(filename));
        fprintf(A2_scan,',');
        fprintf(A2_scan,num2str(Xnow));
        fprintf(A2_scan,',');
        fprintf(A2_scan,num2str(Ynow));
        fprintf(A2_scan,',');
        fprintf(A2_scan,num2str(Znow));
        fprintf(A2_scan,',');
        fprintf(A2_scan,num2str(imgvar));
        fprintf(A2_scan,'\n');
        
        Slno = Slno + 1;
        
        Xnew = Xnow + ( Xdir * XFoVSize );
        Znew = Zarray(Arr_count);
        if (Xsteps <= numofX)
            Xnow = Xnew; Znow = Znew;
            Arr_count = Arr_count+1;
            
            gotoX(Xnow, handles);
            gotoZ(Znow,handles);
            pause(0.15);
        end
    end
    
    Ynew = Ynow + ( Ydir * YFoVSize );
    Znew = Zarray(Arr_count);
    if (Ysteps <= numofY)
        Znow = Znew;     Ynow = Ynew;
        Arr_count = Arr_count+1;
        
        gotoY(Ynow, handles);
        gotoZ(Znow,handles);
        pause (0.15);
        
        Xdir = Xdir * -1; Zdir = Zdir * -1;
    end
end

gotoX(xA, handles); gotoY(yA, handles); gotoZ(zA, handles);



% display time elapsed
time_to_scan_area_with_focal_stack = toc



%numofY*numofX
msg = sprintf('\r\nImages captured : %d x %d', numofY,numofX);
fprintf(fid, msg);
%                             pause(5);
start(tmr);
set(handles.camwait,'string','Focal stack area scan completed.');




% --- Executes on button press in SetA.
function SetA_Callback(hObject, eventdata, handles)
% hObject    handle to SetA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;
xA = get(handles.currxpos,'string');    handles.xA = xA;
yA = get(handles.currypos,'string');    handles.yA = yA;
zA = get(handles.currzpos,'string');    handles.zA = zA;
disp(xA);
disp(yA);
disp(zA);
data = strcat(xA,' , ',yA,' , ',zA);    set(handles.xyzA,'string',data);
fprintf(s,'E');
guidata(hObject, handles);


% --- Executes on button press in SetB.
function SetB_Callback(hObject, eventdata, handles)
% hObject    handle to SetB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;

xB = get(handles.currxpos,'string');    handles.xB = xB;
yB = get(handles.currypos,'string');    handles.yB = yB;
zB = get(handles.currzpos,'string');    handles.zB = zB;
disp(xB);
disp(yB);
disp(zB);
data = strcat(xB,',',yB,',',zB);    set(handles.xyzB,'string',data);

% send command that sets pt B in Arduino
fprintf(s,'R'); guidata(hObject, handles);


% --- Executes on button press in SetC.
function SetC_Callback(hObject, ~, handles)
% hObject    handle to SetC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;

xC = get(handles.currxpos,'string');    handles.xC = xC;
yC = get(handles.currypos,'string');    handles.yC = yC;
zC = get(handles.currzpos,'string');    handles.zC = zC;
disp(xC);
disp(yC);
disp(zC);
data = strcat(xC,',',yC,',',zC);    set(handles.xyzC,'string',data);

% send command that sets pt C in Arduino
fprintf(s,'Y'); guidata(hObject, handles);


function Slidename_Callback(~, ~, ~)
% hObject    handle to Slidename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Slidename as text
%        str2double(get(hObject,'String')) returns contents of Slidename as a double


% --- Executes during object creation, after setting all properties.
function Slidename_CreateFcn(hObject, ~, ~)
% hObject    handle to Slidename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Slide_name_set.
function Slide_name_set_Callback(hObject, ~, handles)
% hObject    handle to Slide_name_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newName = get(handles.Slidename,'string');
handles.setslidename = newName;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Variance.
function Variance_Callback(~, ~, handles)
% hObject    handle to Variance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;
% calc var
newimg = double(getsnapshot(vid)); newvar=var(newimg(:));
%disp on the window
set(handles.var_disp,'string',newvar);

% --- Executes on button press in F_minus.
function F_minus_Callback(~, ~, handles)
% hObject    handle to F_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;  s = handles.s;
% Move Z downwards
fprintf(s,'T');
% calc var
newimg = double(getsnapshot(vid)); newvar=var(newimg(:));
%disp on the window
set(handles.var_disp,'string',newvar);

% --- Executes on button press in F_plus.
function F_plus_Callback(~, ~, handles)
% hObject    handle to F_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;  s = handles.s;
% Move Z upwards
fprintf(s,'G');
% calc var
newimg = double(getsnapshot(vid)); newvar=var(newimg(:));
%disp on the window
set(handles.var_disp,'string',newvar);


function Image_Name_Callback(~, ~, ~)
% hObject    handle to Image_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Name as text
%        str2double(get(hObject,'String')) returns contents of Image_Name as a double

% --- Executes on button press in Snapshot.
function Snapshot_Callback(~, ~, handles)
% hObject    handle to Snapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid=handles.vid;
snapshot=getsnapshot(vid);
ImageName = get(handles.Image_Name,'string');
imwrite(snapshot,(strcat(ImageName,'.jpg')));
%enh_snapshot=autocontrast(snapshot);
%imwrite(snapshot,strcat('DataSet_IISC_Cytocube/Slide1/Image_',handles.setSlidename,'.jpg'));
%filename = strcat('DataSet_IISC_Cytocube/Slide1/Enhanced_Image_',handles.setSlidename,'.jpg');
%imwrite(enh_snapshot,'snap_enh.jpg');
disp('image saved')

% --- Executes on button press in Focal_stack.
function Focal_stack_Callback(~, ~, handles)
% this is the debug code
% hObject    handle to Focal_stack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s; src = handles.src; vid=handles.vid; tmr = handles.tmr; fid=handles.fid;
stop(tmr);

%% Code for testing unit for X,Y & Z shifts

% fprintf(s,'J');fprintf(s,'K');fprintf(s,'L'); start(tmr);return;
%**************************************************************************
% this code calculates x,y,z shifts. It'll begin at a point (wherever it is
% currently), AF at that point (lets calll it origin, O) and takes an image.
% Then, it  traverses a set distance in X and Y dir, and returns to O.
% It AFs again and takes a second image at O. These two images are
% XRRed to get x,y shifts. Also the Z position difference between the
% original AF position and new AF position gives the Z-displacement.
set(handles.camwait,'string','The carnival is open!');

itr=120; % this defines the number of merry-go-rounds

set(vid,'ROIPosition',[300 300 500 500]);

dzfid = fopen('dxydzcood.csv','w'); % stores the deltaZ cood
dxfid = fopen('dxydx.csv','w'); % stores the deltaX XRR value
dyfid = fopen('dxydy.csv','w'); % stores the deltay XRR value

% Let the games begin !
fprintf(s,'J');fprintf(s,'K');fprintf(s,'L'); % set all co-od to 0
counter=0;


AutoFocus(handles); % assuming the Af was done once, we use a shorter length
    
%save this ref image. Also find current Z
newimg = (getsnapshot(vid));    imwrite(newimg,strcat(num2str(counter),'.jpg'));
    
            fwrite(s,'P'); data = fgetl(s);
            if(data == 'Z')
                refZ = str2num(fgetl(s))
            else
                data = fgetl(s);      
            end
            
            
while(counter < itr)  
    
    % Life's a book. Those who don't travel, only read a page.
            fprintf(s,'B');  fprintf(s,'+050000');      % go 10 mm in x dir
            pause(4); % wait for the arduino to execute mvememnt
            fprintf(s,'N');  fprintf(s,'+050000');      % go 10 mm in y dir
            pause(4); % wait for the arduino to execute mvememnt
            fprintf(s,'B');  fprintf(s,'+000000');      % go back 10mm in x
            pause(4); % wait for the arduino to execute mvememnt
            fprintf(s,'N');  fprintf(s,'+000000');      % go back 10mm in y. Now you're home
            pause(5); % wait for the arduino to execute mvememnt
            
     % Need to AF again. Save the new img and get new Z co-od
     AutoFocus(handles); % assuming the Af was done once, we use a shorter length
     newimg = (getsnapshot(vid));    imwrite(newimg,strcat(num2str(counter+1),'.jpg'));
     
            fwrite(s,'P'); data = fgetl(s);
            if(data == 'Z')
                newZ = str2num(fgetl(s));
            else
                data = fgetl(s);      
            end            
            
     % lets save the diff in z-cood first.
     fprintf(dzfid,strcat(num2str(newZ-refZ),'\n'));
     % save newZ as refZ for next loop
     refZ=newZ;
     
     tic
     % now let Radhika's brainchildren run amok
     set(handles.camwait,'string','Correlation being calculated'); 
            I = imread(strcat(num2str(counter),'.jpg'));
            img = double(rgb2gray(I));                 

            J = imread(strcat(num2str(counter+1),'.jpg'));
            img2 = double(rgb2gray(J));   

            nimg = img-mean(mean(img));
            mimg = img2-mean(mean(img2));


            crr = xcorr2(nimg,mimg);
            [ssr,snd] = max(crr(:));
            [ij,ji] = ind2sub(size(crr),snd);

            [Y,X] = size (img);
            Xshift = ij-X
            Yshift = ji-Y
      set(handles.camwait,'string','XCRR done.');       
      % now store the x and y shifts
     fprintf(dxfid,strcat(num2str(Xshift),'\n'));
     fprintf(dyfid,strcat(num2str(Yshift),'\n'));
     toc
     % increment counter, so the merry-go-round keeps going 'round
     counter = counter + 1;
     
end

fclose(dzfid);fclose(dxfid);fclose(dyfid);
set(handles.camwait,'string','deltaXYZ testing over');
set(vid,'ROIPosition',[0 0 1280 1024]);
if toTurnOnOrNot ==1
    start(tmr);
end
return;



% %%
% % scan across Z and build a variance graph 
% 
% %msg=strcat('logs/',datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s'); 
% %fid = fopen(strcat(msg,'.txt'),'w');
% 
% msg=strcat('arvind','.csv'); 
% arvfid = fopen(msg,'w');
% 
% set(handles.camwait,'string','hello stranger');
% 
% stackcount=200; vararray= zeros(1,stackcount);
% currzpos = str2double(get(handles.currzpos,'string'))
% startingZ = currzpos + (stackcount/2)
% newZ = strcat('-',sprintf('%06d',abs(startingZ )))
% fprintf(s,'M'); fprintf(s, newZ ); pause(4);
% 
% newimg = (getsnapshot(vid));
% imwrite(newimg,strcat('begin-100','.bmp')); 
% 
% 
% imgcount=0; 
% while(imgcount <= stackcount)
%     newimg = double(getsnapshot(vid)); vari = var(newimg(:))
%     %vararray(:) = vari;
%     
%     fprintf(arvfid,num2str(vari));
%     
%     fprintf(arvfid,',');
%     
%     
%     imgcount = imgcount + 1; 
%     fprintf(s,'G'); pause(0.1);
% end
% 
% start(tmr); disp('graphing done');
% set(handles.camwait,'string','done');
% return;




%% code to acquire a 30 frame focal stack throughout a slide. best image saved as 'BF' in each FoV
% 
% xit=70; yit= 29; % x and y iterations
% 
% % FoV counters
% xcount=0; ycount=0; totalcount=0;
% tic
% while(xcount<xit)
%     while(ycount<yit)
%                 % call the focal stack acquisition function with totalcount, x and y
%                 pointName=strcat('pt',num2str(totalcount));
%                 getFS(handles,6000,pointName);
%                 % update y counter and total counter                
%                 ycount = ycount +1;
%                 totalcount = totalcount + 1;
% %------------- move to diff FoV                
%                 fprintf(s,'W'); % this shifts up
%     end % end of inner loop
%     % reset y counter
%     ycount=0;
% % -----------------------  go back to x=0 since the y has moved
% fprintf(s, 'N');  fprintf(s, '0000000'); pause(7);
% % ---------- move X towards    downwards
% fprintf(s,'A'); pause(0.5);
% % update X count
% xcount = xcount +1;
% end % end of outer loop
% 
% % display info
% set(handles.camwait,'string','whole area Focal stack acquisition completed');
% toc
% start(tmr);
% return;



%% Code to record timestamped images so as to show the dancing video feed
% tic; pause(0.01);
% arrcount=400;
% imgcount=0;
% while(imgcount <= arrcount)
%     newimg = (getsnapshot(vid));
%     imwrite(newimg,strcat(num2str(toc),'.bmp')); 
%     imgcount = imgcount + 1;     
% end
% return;

%% Code to measure lateral shifting (and Z changes beacuse of lateral movement)
% set(handles.camwait,'string','LS measurement ongoing...');
% imgcount=0; arrcount=50;
% 
% tic; pause(0.01); % need to pause to ensure time isn't in nanosec
% newimg = (getsnapshot(vid));
% imwrite(newimg,strcat('000.bmp'));
% fprintf(s,'A');
% pause(0.2);
% fprintf(s,'D');
% while(imgcount <= arrcount)
%     newimg = (getsnapshot(vid));
%     imwrite(newimg,strcat(num2str(imgcount),'_',num2str(toc),'.bmp')); 
%     imgcount = imgcount + 1;     
% end
% set(handles.camwait,'string','MT done');
% return;
%%

% %% Code to measure vertical shift: travel downwards, then back upwards and see if you have same focus and in how much time \
% % does the focus setle upwards
% set(handles.camwait,'string','VS measurement ongoing...');
% imgcount=0; arrcount=50;
% 
% tic; pause(0.01); % need to pause to ensure time isn't in nanosec
% newimg = (getsnapshot(vid));
% imwrite(newimg,strcat('000.bmp'));
% fprintf(s,'M');      fprintf(s,'+008600');      % go 10 um above = 1000 steps
% pause(0.3);
% fprintf(s,'M');  fprintf(s,'+004000');
% %pause(0.3);
% while(imgcount <= arrcount)
%     newimg = (getsnapshot(vid));
%     imwrite(newimg,strcat(num2str(imgcount),'_',num2str(toc),'.bmp')); 
%     imgcount = imgcount + 1;     
% end
% set(handles.camwait,'string','VS done');
% return;
% 
% %%
% % scan across Z and build a variance graph 
% % needed for Rajesh's GYTI
% stackcount=50; vararray= zeros(1,stackcount);
% currzpos = str2double(get(handles.currzpos,'string'));
% startingZ = currzpos + (10 * stackcount);
% newZ = strcat('+',sprintf('%06d',abs(startingZ )))
% fprintf(s,'M'); fprintf(s, newZ ); pause(2);
%   
% imgcount=0; 
% while(imgcount <= stackcount)
%     newimg = double(getsnapshot(vid)); vari = var(newimg(:))
%     vararray(:) = vari;
%     imgcount = imgcount + 1; 
%     fprintf(s,'T'); pause(0.1);
% end
% save('variancee.mat', 'vararray');
% start(tmr); disp('graphing done');
% return;
% 
% setslidename = 'dataset5_focalstack_3_';
% set(handles.camwait,'string','Focal stack acquisition ongoing...');
% % take a focal stack
% currzpos = str2double(get(handles.currzpos,'string'));
% originalZ = currzpos
% stackcount=100; filecount=0;
% 
% % go upwards to the starting point
% startingZ = currzpos - (10 * (stackcount/2)) 
% startingZcopy = startingZ;
% if(startingZ < 0)                 
%                    startingZ = strcat('-',sprintf('%06d',abs(startingZ )));    
%               else
%                    startingZ = strcat('+',sprintf('%06d',abs(startingZ )));
%         end;
% fprintf(s,'M'); fprintf(s, startingZ ); pause(1);
% 
% 
% % now sweep downwards, taking pix. Reach to the max height .
% while(filecount <= stackcount)
%     snapshot=getsnapshot(vid);
%     filename = strcat(setslidename,'_up_',num2str(filecount), '.jpg');
%     imwrite(snapshot,filename); 
%     filecount = filecount + 1; 
%     
%             newZ = startingZcopy + (10*filecount) ;
%             if(newZ < 0)                 
%                                newZ = strcat('-',sprintf('%06d',abs(newZ )));    
%                           else
%                                newZ = strcat('+',sprintf('%06d',abs(newZ )));
%                     end;
%             fprintf(s,'M'); fprintf(s, newZ ); pause(0.1);
% end
% 
% % % go back to original Z location
% newZ = originalZ;
% if(newZ < 0)                 
%                    newZ = strcat('-',sprintf('%06d',abs(newZ )));    
%               else
%                    newZ = strcat('+',sprintf('%06d',abs(newZ )));
%         end;
% fprintf(s,'M'); fprintf(s, newZ ); %pause(1);
% 
% % display info
% set(handles.camwait,'string','Focal stack acquisition completed');
% start(tmr);
% return;



% --- Executes on button press in Downwards.
function Upwards_Callback(hObject, eventdata, handles)
% hObject    handle to Downwards (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 s = handles.s;     fprintf(s,'W');

% --- Executes on button press in Downwards.
function Downwards_Callback(hObject, eventdata, handles)
% hObject    handle to Downwards (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 s = handles.s;     fprintf(s,'S');

% --- Executes on button press in Left.
function Right1_Callback(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 s = handles.s;     fprintf(s,'D');

% --- Executes on button press in Left.
function Left_Callback(hObject, eventdata, handles)
% hObject    handle to Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 s = handles.s;     fprintf(s,'A');

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

function output_img = autocontrast(input_img)

low_limit=0.004;
up_limit=0.995;
img=input_img;
[m1 n1 r1]=size(img);
img=double(img);
%--------------------calculation of vmin and vmax----------------------
for k=1:r1
    arr=sort(reshape(img(:,:,k),m1*n1,1));
    v_min(k)=arr(ceil(low_limit*m1*n1));
    v_max(k)=arr(ceil(up_limit*m1*n1));
end
%----------------------------------------------------------------------
if r1==3
    v_min=rgb2ntsc(v_min);
    v_max=rgb2ntsc(v_max);
end
%----------------------------------------------------------------------
img=(img-v_min(1))/(v_max(1)-v_min(1));
output_img = uint8(img.*255);


%%
function gotoXYZ(check1,check2,check3,handles)
s=handles.s;
    
tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end
    
%%%%%%% check if Arduino is responsive and if not, wait %%%%%%
fprintf(s,'7');     while fscanf(s) ~= '7'
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str = sprintf('%06d',abs(check1));     % abs needed so that no +&- in neg numbers

if(check1 < 0)
    newstr1 = strcat('-',str);
else
    newstr1 = strcat('+',str);
end


fprintf(s,'7');     while fscanf(s) ~= '7'
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str = sprintf('%06d',abs(check2));     % abs needed so that no +&- in neg numbers

if(check2 < 0)
    newstr2 = strcat('-',str);
else
    newstr2 = strcat('+',str);
end

fprintf(s,'7');     while fscanf(s) ~= '7'
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str = sprintf('%06d',abs(check3));     % abs needed so that no +&- in neg numbers


if(check1 < 0)
    newstr3 = strcat('-',str);
else
    newstr3 = strcat('+',str);
end
% end formatting ---------- --------------------------------------------
fprintf(s, ','); fprintf(s, newstr1 );  fprintf(s, newstr2 );  fprintf(s, newstr3 );

if toTurnOnOrNot ==1
    start(tmr);
end

%%

function gotoX(check,handles)
s=handles.s; 

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

%%%%%%% check if Arduino is responsive and if not, wait %%%%%%
fprintf(s,'7');     while fscanf(s) ~= '7'
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str = sprintf('%06d',abs(check));     % abs needed so that no +&- in neg numbers
% ensure that too big values dont go in
if (check < -150000)        
    check = -150000;
elseif (check > 150000)    
    check = 150000;
end

if(check < 0)
    newstr = strcat('-',str);
else
    newstr = strcat('+',str);
end
% end formatting ---------- --------------------------------------------
fprintf(s,'B');                 fprintf(s, newstr );
if toTurnOnOrNot ==1
    start(tmr);
end
              
function gotoY(check,handles)
s=handles.s;
        %%%%%%% check if Arduino is responsive and if not, wait %%%%%%
        fprintf(s,'7');     while fscanf(s) ~= '7'  
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

str = sprintf('%06d',abs(check));     % abs needed so that no +&- in neg numbers
        % ensure that too big values dont go in
        if (check < -150000)        check = -150000;
        elseif (check > 150000)    check = 150000;
        end
        
        if(check < 0)                 
                   newstr = strcat('-',str);    
              else
                   newstr = strcat('+',str);
        end
    % end formatting ---------- --------------------------------------------
       fprintf(s,'N');        fprintf(s, newstr );
              
function gotoZ(check,handles)
s=handles.s;

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

%%%%%%% check if Arduino is responsive and if not, wait %%%%%%
fprintf(s,'7');     while fscanf(s) ~= '7'
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % ensure that too big values dont go in
%         if (check < -70000),        check = -70000;
%         elseif (check > 30000) ,   check = 30000;
%         end;

str = sprintf('%06d',abs(check));    % abs needed so that no +&- in neg numbers

if(check < 0)
    newstr = strcat('-',str);
else
    newstr = strcat('+',str);
end
% end formatting ---------- --------------------------------------------
fprintf(s,'M');        fprintf(s, newstr );  
% pause(0.00125);

if toTurnOnOrNot ==1
    start(tmr);
end
% --- Executes on button press in Find_FP.
function Find_FP_Callback(~, ~, handles)
% hObject    handle to Find_FP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid=handles.vid; 
FindFP(handles,5000,50);
src = getselectedsource(vid);
src.BalanceWhiteAuto = 'Once';

 
 
function FindFP(handles,travel,step_count)
s = handles.s;          vid=handles.vid;  
tmr=handles.tmr;
    toTurnOnOrNot=1;
    if strcmp(get(tmr,'Running'),'off')
        toTurnOnOrNot=0;
    else
        stop(tmr);
    end

% fwrite(s,'I'); data = fgetl(s);
%             if(data == 'X')
%                 currX = str2num(fgetl(s));
%             else
%                 data = fgetl(s);      
%             end
%             
% fwrite(s,'O'); data = fgetl(s);
%             if(data == 'Y')
%                 currY = str2num(fgetl(s));
%             else
%                 data = fgetl(s);      
%             end
% if ((currX~=0) && (currY~=0))
%     fprintf(s,'Q');
%     disp('set x,y to zero');
%     while fscanf(s) ~= 'S'
%     end
%     start(tmr);
%     pause(1);
%     stop(tmr);
% %     gotoX(-100000,handles);
% %     gotoY(60000,handles);
% end
%      
% 
% gotoZ(-150000,handles);    % To hit the bump switch and set currZ as Zero
% 
% % fwrite(s,'P'); data = fgetl(s);
% %             if(data == 'Z')
% %                 currZ = str2num(fgetl(s))
% %             else
% %                 data = fgetl(s);      
% %             end
%             
% gotoZ(65000,handles); pause(15); 2
    
    fwrite(s,'P'); data = fgetl(s);
            if(data == 'Z')
                currZ = str2double(fgetl(s));
            else
                data = fgetl(s);      
            end

set(handles.camwait,'string','Find FP in progress...');


Z_travel_for_crude = travel;  

crude_pulse_count = Z_travel_for_crude / step_count;
crude_curr_var=0;       crude_max_var=0;    crude_loc_max_var=0;

%        go to starting Z loc 
crude_start_loc = currZ + (Z_travel_for_crude/2);
gotoZ(crude_start_loc,handles); pause(0.1);

% now keep going downwards and taking var
crude_curr_loc = crude_start_loc;
AF1_loc_array = zeros(1,travel/step_count);   
AF1_var_array = zeros(1,travel/step_count);

for i=1: crude_pulse_count     
    
    %save image - debug
    pause(0.005);
    newimg=getsnapshot(vid); 
%     imwrite(newimg,(strcat(num2str(crude_curr_loc),'.jpg')));
    
    % variance
    crude_img = double(newimg);     crude_curr_var=var(crude_img(:));
    
    AF1_loc_array(i) = crude_curr_loc;
    AF1_var_array(i) = crude_curr_var;
    
    if (crude_curr_var > crude_max_var) 
        crude_max_var = crude_curr_var;
        crude_loc_max_var = crude_curr_loc;
    end

    % update loc
    crude_curr_loc = crude_curr_loc - step_count      ;
    gotoZ(crude_curr_loc,handles);
    
end


gotoZ(crude_loc_max_var - 0,handles);    %% +x0 to do a zero correction
pause(0.2);

set(handles.camwait,'string','White Balancing Done!');

if toTurnOnOrNot ==1
    start(tmr);
end
s = handles.s;  fprintf(s, 'L');
pause(0.2);
return ;


% --- Executes on button press in Reset.
function Reset_Callback(~, ~, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s; tmr=handles.tmr; resetbutton=handles.Reset;
set(resetbutton,'enable','off');
set(handles.camwait,'string','System resetting...');
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

fclose(s);   fopen(s);  
pause(1);
fprintf(s,'Q');
pause(30);
% while fscanf(s) ~= 'S'
% end
% disp('RECEIVED A handshake');
if toTurnOnOrNot ==1
    start(tmr);
end
set(handles.camwait,'string','System at Home Location');
set(resetbutton,'enable','on');
fprintf(s, 'J');  fprintf(s, 'K'); fprintf(s, 'L');

return;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(~, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

try
    stop(tmr);
    fid=handles.fid;    fclose(fid); 
    vid = handles.vid;  stoppreview(vid);   delete(vid);
catch
%     clear all;
    clc;
end

%s=handles.s;   fclose(s);  delete(s);
disp('Killed all before exiting');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function [] = bestpoints(hObject,~,Xvar)
handles = guidata(hObject);
s=handles.s;
Avar = handles.Avar;    Bvar = handles.Bvar;    Cvar = handles.Cvar;
   if ((Cvar < Bvar) && (Cvar < Avar))
       if ( Xvar > Cvar)
           fprintf(s,'Y');
           handles.Cvar = Xvar;
           disp('changed C');
       end
   end
   if ((Avar < Bvar) && (Avar < Cvar))
       if ( Xvar > Avar)
           fprintf(s,'E');
           handles.Avar = Xvar;
           disp('changed A');
       end
   end
   if ((Bvar < Avar) && (Bvar < Cvar))
       if ( Xvar > Bvar)
           fprintf(s,'R');
           handles.Bvar = Xvar;
           handles.Bvar
           disp('changed B');
       end
   end

    %update handles
   guidata(hObject, handles);  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [currmaxvar] = getFS(handles,travel,ptName)
vid=handles.vid;  fid=handles.fid;  
set(handles.camwait,'string','Starting FS...');     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %       CRUDE Find_FP. 
        Z_travel_for_crude = travel;  crude_step_count = 200;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_curr_var=0;       crude_max_var=0;    crude_loc_max_var=0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %        go to starting Z loc 
        crude_start_loc = str2double(get(handles.currzpos,'string')) - (Z_travel_for_crude/2);
        gotoZ(crude_start_loc,handles); pause(1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % now keep going downwards and taking var
        crude_curr_loc = crude_start_loc;

        for i=1: crude_pulse_count     
            % variance
            crude_img = double(getsnapshot(vid));     crude_curr_var=var(crude_img(:));

            if (crude_curr_var > crude_max_var) 
                crude_max_var = crude_curr_var;
                crude_loc_max_var = crude_curr_loc;
            end 
            % update loc 
            crude_curr_loc = crude_curr_loc + crude_step_count      ;
            gotoZ(crude_curr_loc,handles); 
        end
        gotoZ(crude_loc_max_var,handles);
        pause(1);
     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % The fine Find_FP begins here
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ztotaltravel = 400;     final_go_backpulses = 0 ;
        currZ = crude_loc_max_var;

        % first go above
        start_above_loc = currZ - (Ztotaltravel/2);
        gotoZ(start_above_loc,handles); 
        pause(1); 
        % now build the var array
        localAF_loc_array = zeros(1,Ztotaltravel);   localAF_var_array = zeros(1,Ztotaltravel);
        localAF_curr_loc = start_above_loc;
        for q=1:(Ztotaltravel/5)
            % location
            localAF_loc_array(q) = localAF_curr_loc;
            % variance
            localAF_img = getsnapshot(vid); 
            
            filename = strcat(ptName,'_',num2str(q),'.jpg') ;
            imwrite(localAF_img,filename); 
            
            localAF_img = double(localAF_img); 
            localAF_var_array(q)=var(localAF_img(:));            
            % move and update loc    
            localAF_curr_loc = localAF_curr_loc + 5;    gotoZ(localAF_curr_loc,handles);    
            pause(0.1); 
        end  

        % Finally go to the max var location
        index_of_max_var =  find(localAF_var_array == max(localAF_var_array));
        loc_of_max_var = localAF_loc_array(index_of_max_var) - final_go_backpulses ;     

        gotoZ(loc_of_max_var,handles); pause(0.5); 
        fprintf(fid,'\r\nCrude/Fine AF (var): %d / %d  (%d)',crude_loc_max_var,loc_of_max_var,max(localAF_var_array));
        % Find_FP and FS done complete
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display info
set(handles.camwait,'string','This Focal stack done!');
return;



% --- Executes on button press in SetasY.
function SetasY_Callback(~, ~, handles)
% hObject    handle to SetasY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'K');


% --- Executes on button press in SetasX.
function SetasX_Callback(~, ~, handles)
% hObject    handle to SetasX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'J');


% --- Executes on button press in SetasZ.
function SetasZ_Callback(~, ~, handles)
% hObject    handle to SetasZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'L');


% --- Executes on button press in SetAllHome.
function SetAllHome_Callback(~, ~, handles)
% hObject    handle to SetAllHome (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = handles.s;  fprintf(s, 'J');  fprintf(s, 'K'); fprintf(s, 'L');


% --- Executes on button press in Auto_Focus.
function Auto_Focus_Callback(~, ~, handles)
% hObject    handle to Auto_Focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFbutton=handles.Auto_Focus;
set(AFbutton,'enable','off');
AutoFocus(handles,2000,10);

function [locmaxvar] = AutoFocus(handles,travel,step_count)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vid=handles.vid;    fid=handles.fid;    s= handles.s; 

AFbutton=handles.Auto_Focus;

tmr=handles.tmr;
%%  
    toTurnOnOrNot=1;
    if strcmp(get(tmr,'Running'),'off')
        toTurnOnOrNot=0;
    else
        stop(tmr); 
    end
    
    set(vid,'ROIPosition',[300 300 500 500]); pause(0.2);
%this function give current z location    
    fwrite(s,'P'); data = fgetl(s);
            if(data == 'Z')
                currZ = str2double(fgetl(s));
            else
                data = fgetl(s);      
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the step sizes here
%     travel = 2000;  step_count = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Fine Find_FP - I
set(handles.camwait,'string','Fine AF-I in progress...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z_travel_for_crude = travel;  

crude_pulse_count = Z_travel_for_crude / step_count;
crude_curr_var=0;       crude_max_var=0;    crude_loc_max_var=0;

%        go to starting Z loc 
crude_start_loc = currZ + (Z_travel_for_crude/2);
gotoZ(crude_start_loc,handles); pause(0.1);

% now keep going downwards and taking var
crude_curr_loc = crude_start_loc;
AF1_loc_array = zeros(1,travel/step_count);   
AF1_var_array = zeros(1,travel/step_count);

for i=1: crude_pulse_count     
    
    %save image - debug
    pause(0.005);
    newimg=getsnapshot(vid); 
%     imwrite(newimg,(strcat(num2str(crude_curr_loc),'.jpg')));
    
    % variance
    crude_img = double(newimg);     crude_curr_var=var(crude_img(:));
    
    AF1_loc_array(i) = crude_curr_loc;
    AF1_var_array(i) = crude_curr_var;
    
    if (crude_curr_var > crude_max_var) 
        crude_max_var = crude_curr_var;
        crude_loc_max_var = crude_curr_loc;
    end

    % update loc
    crude_curr_loc = crude_curr_loc - step_count      ;
    gotoZ(crude_curr_loc,handles);
    
end
maxxxx = crude_loc_max_var;
max_var = crude_max_var;
figure(2)
plot(AF1_loc_array,AF1_var_array)
hold on; 
prom = min(0.1*max_var, 70); %% if one of the peak is too high, see ref image. 
[pks,locs] = findpeaks(smooth(-AF1_var_array,1), 'MinPeakProminence' ,prom, 'MaxPeakWidth',20);
% [pks,locs,w,p] = findpeaks(-AF1_var_array, 'MinPeakProminence' ,prom)%, 'MaxPeakWidth',20);

if ~isempty(pks) 
    
    [~,indx] = min(abs(AF1_var_array(locs)));
    crude_loc_max_var= AF1_loc_array(locs(indx));
    crude_loc_max_var = crude_loc_max_var - 20;             %% +x0 to do a zero correction
    scatter(AF1_loc_array(locs(indx)),AF1_var_array(locs(indx)),'r*')
else
    crude_loc_max_var = crude_loc_max_var - 70;             %% +x0 to do a zero correction
end 

% locs(2)
% assignin('base','locs',locs);
% assignin('base','pks',pks);
% assignin('base','w',w);
% assignin('base','p',p);
% assignin('base','AF1_loc_array',AF1_loc_array);
% assignin('base','AF1_var_array',AF1_var_array);

% crude_loc_max_var
% disp(AF1_loc_array(crude_loc_max_var))

plot(AF1_loc_array,smooth(AF1_var_array,3))
scatter(AF1_loc_array(locs),AF1_var_array(locs))

scatter(maxxxx,crude_max_var)
title('AutoFocus Check')
xlabel('Step Count')
ylabel('Variance')
hold off;


gotoZ(crude_loc_max_var - 0,handles);    %% +x0 to do a zero correction
pause(0.2);
if toTurnOnOrNot ==1
    start(tmr);
end
set(handles.camwait,'string','AF done!');
locmaxvar = crude_loc_max_var;
% currmaxvar = crude_max_var;
set(vid,'ROIPosition',[0 0 1280 1024]);
set(AFbutton,'enable','on');
pause(0.2);
return ;



% --- Executes on button press in F_10plus.
function F_10plus_Callback(~, ~, handles)
% hObject    handle to F_10plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;  s = handles.s;
% Move Z downwards
fprintf(s,'GGGGGGGGGG');
% calc var
newimg = double(getsnapshot(vid)); newvar=var(newimg(:));
%disp on the window
set(handles.var_disp,'string',newvar);

% --- Executes on button press in F_10minus.
function F_10minus_Callback(~, ~, handles)
% hObject    handle to F_10minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = handles.vid;  s = handles.s;
% Move Z downwards
fprintf(s,'TTTTTTTTTT');
% calc var
newimg = double(getsnapshot(vid)); newvar=var(newimg(:));
%disp on the window
set(handles.var_disp,'string',newvar);


% --- Executes during object creation, after setting all properties.
function Image_Name_CreateFcn(hObject, ~, ~)
% hObject    handle to image_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TileSizeX.
function TileSizeX_Callback(hObject, ~, handles)
% hObject    handle to TileSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TileSizeX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TileSizeX

% find out index of selected element
idx = get(hObject,'Value');

% get the ful list of values
items = get(hObject,'String');

% get te element at selected location
selectedX = items{idx};
  
% store it in handles for future use
handles.TileSizeX = selectedX;
% handles.TileSizeY = selectedX;

%  now enable the TileSizeY menu
% set(handles.TileSizeY,'enable','on');

%  now enable the area scan button
set(handles.AreaScan,'enable','on');

% update the handles structure
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function TileSizeX_CreateFcn(hObject, ~, ~)
% hObject    handle to TileSizeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in TileSizeY.
function TileSizeY_Callback(hObject, ~, handles)
% hObject    handle to TileSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TileSizeY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TileSizeY

% find out index of selected element
idx = get(hObject,'Value');

% get the ful list of values
items = get(hObject,'String');

% get te element at selected location
selectedY = items{idx};
  
% store it in handles for future use
handles.TileSizeY = selectedY;

% update the handles structure
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function TileSizeY_CreateFcn(hObject, ~, handles)
% hObject    handle to TileSizeY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% set(hObject,'enable','off');

%%


function [bren] = calcbren(Image,handles)
        [M, N] = size(Image);
        DH = zeros(M, N);
        DV = zeros(M, N);
        DV(1:M-2,:) = Image(3:end,:)-Image(1:end-2,:);
        DH(:,1:N-2) = Image(:,3:end)-Image(:,1:end-2);
        FM = max(DH, DV);        
        FM = FM.^2;
        bren = mean2(FM);

% --- Executes on button press in RGB.
function RGB_Callback(hObject, eventdata, handles)
% hObject    handle to RGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = videoinput('gentl', 1, 'Mono8');
closepreview (vid);
vid = videoinput('gentl', 1, 'BGRA8Packed');


% --- Executes on button press in Mono.
function Mono_Callback(hObject, eventdata, handles)
% hObject    handle to Mono (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid = videoinput('gentl', 1, 'BGRA8Packed');
closepreview (vid);
vid = videoinput('gentl', 1, 'Mono8');

% --- Executes on button press in QuickStack.
function QuickStack_Callback(hObject, eventdata, handles)
% hObject    handle to QuickStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prefix = get(handles.Image_Name,'string');
QuickStack(handles,prefix);

%Quick Satck Starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [locmaxvar,currmaxvar] = QuickStack(handles,prefix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vid=handles.vid;    fid=handles.fid;    s= handles.s; 

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end
    
% set(vid,'ROIPosition',[300 200 500 500]);

fwrite(s,'P'); data = fgetl(s);
if(data == 'Z')
    currZ = str2double(fgetl(s));
else
    data = fgetl(s);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the step sizes here
    travel = 100;  crude_step_count = 10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.camwait,'string','Quick Stacking in progress...');

Z_travel_for_crude = travel;  

crude_pulse_count = Z_travel_for_crude / crude_step_count;
crude_curr_var=0;       crude_min_var=500;    crude_loc_max_var=0;

%        go to starting Z loc 
crude_start_loc = currZ + (Z_travel_for_crude/2) ;   
gotoZ(crude_start_loc,handles); pause(0.1);

% now keep going downwards and taking var
crude_curr_loc = crude_start_loc;

AF2_loc_array = zeros(1,travel/crude_step_count);   
AF2_var_array = zeros(1,travel/crude_step_count);

for i=1: crude_pulse_count + 1    
    
    %save image - debug
    pause(0.01);
    newimg=getsnapshot(vid); 
%     pause(0.5);
    imwrite(newimg,(strcat(prefix,'_',num2str(crude_curr_loc),'.jpg')));
    
    % variance
    crude_img = double(newimg);     crude_curr_var=var(crude_img(:));
    
    AF2_loc_array(i) = crude_curr_loc;
    AF2_var_array(i) = crude_curr_var;
    
    if (crude_curr_var < crude_min_var) 
        crude_min_var = crude_curr_var;
        crude_loc_max_var = crude_curr_loc;
    end
    
    % update loc
    crude_curr_loc = crude_curr_loc - crude_step_count      ;
    gotoZ(crude_curr_loc,handles);
    
end

gotoZ(crude_loc_max_var + 0,handles); %Zero correction
pause(0.15);
if toTurnOnOrNot ==1
    start(tmr);
end
set(handles.camwait,'string','Done!');
currmaxvar = crude_min_var;
locmaxvar = crude_loc_max_var;
% set(vid,'ROIPosition',[0 0 1280 1024]); pause(0.2);
return ;


% --- Executes on button press in Sickle_Scan.
function Sickle_Scan_Callback(~, ~, handles)
% hObject    handle to Sickle_Scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = handles.s;  vid = handles.vid ; fid=handles.fid;  resetbutton=handles.Reset;

tmr=handles.tmr;
toTurnOnOrNot=1;
if strcmp(get(tmr,'Running'),'off')
    toTurnOnOrNot=0;
else
    stop(tmr);
end

setslidename = handles.setslidename;  
set(handles.camwait,'string','Acquiring "heatmap"...');
% tic

% %%%%%%%%%% added on 2 0ct for time lapse of a single fov
% set(handles.camwait,'string','Acquiring timelapse...');
% spf=10; timeToImage=45*60
% 
% for count = 1: (timeToImage/spf)
%     filename = strcat(setslidename,'_',num2str(count),'.jpg');
%     snapshot=getsnapshot(vid);
%     imwrite(snapshot,filename);
%     pause(spf);
% end
% set(handles.camwait,'string','Timelapse done!');
% return;


%%%%%%%%%%%%%%%%%%%%%%%%% these two define the jumps %%%%%%%%%%%%%%%%%%%%%%
    Xjump =2500;        Yjump = 2500;  
    S_travel = 3000 ;    S_step = 10;
xA = str2double(handles.xA);    xB = str2double(handles.xB);    xC = str2double(handles.xC);                       
yA = str2double(handles.yA);    yB = str2double(handles.yB);    yC = str2double(handles.yC);    
zA = str2double(handles.zA);    zB = str2double(handles.zB);    zC = str2double(handles.zC);

numofX = (abs(xB - xA) / Xjump) 
numofY = (abs(yC - yB) / Yjump)

% % Opening of CSV
% msg=strcat('Sickle_scan','.csv');
% Sickle_scan = fopen(msg,'w');

% gotoX(xA, handles); gotoY(yA, handles); gotoZ(zA, handles);
gotoXYZ(xA, yA, zA, handles);
xnow = xA;  ynow=yA; 
% serial=1;
num_sets = 1;
delay_time = 200; % time in seconds
tic

for k=1:num_sets
    serial=1;
    tic;
    Xdir = (abs(xB-xA))/(xB-xA);    Ydir = (abs(yC-yB))/(yC-yB);   %%%Matters if num of Y steps is even/odd
    if k ~= num_sets
%         tic
        t = timer;
        t.StartDelay = delay_time;
        t.TimerFcn = @(~,~)disp('Starting new one!');
        start(t)
    end
    
    for Ysteps=1: (numofY+1)
        for Xsteps=1: (numofX+1)
            znow=AutoFocus(handles,S_travel,S_step); 
            filename = strcat(setslidename,'_',num2str(k),'_',num2str(serial),'_',num2str(xnow),'_',num2str(ynow),'_',datestr(now,'_HH-MM-SS'),'.jpg');
            snapshot=getsnapshot(vid);
            imwrite(snapshot,filename);
            
            % For saving values in CSV
%             imgvar = var(double(snapshot(:)));
%             fprintf(Sickle_scan,num2str(filename));
%             fprintf(Sickle_scan,',');
%             fprintf(Sickle_scan,num2str(xnow));
%             fprintf(Sickle_scan,',');
%             fprintf(Sickle_scan,num2str(ynow));
%             fprintf(Sickle_scan,',');
%             fprintf(Sickle_scan,num2str(znow));
%             fprintf(Sickle_scan,',');
%             fprintf(Sickle_scan,num2str(imgvar));
%             fprintf(Sickle_scan,'\n');

            xnew = xnow + ( Xdir * Xjump );
            serial  = serial+1;
            if (Xsteps <= numofX)              %% For skipping the Xnow revision on the last X FoV
                xnow = xnew;
%                 gotoX(xnow, handles);
                gotoXYZ(xnow, ynow, znow, handles);
                pause(0.10);
            end
        end
        %     toc
        ynew = ynow + ( Ydir * Yjump );
        if (Ysteps <= numofY)
            ynow = ynew;
%             gotoY(ynow, handles);
            gotoXYZ(xnow, ynow, znow, handles);
            pause (0.10);
            Xdir = Xdir * -1;
        end
    end
%     gotoX(xA, handles); gotoY(yA, handles); gotoZ(zA, handles);
    gotoXYZ(xA, yA, zA, handles);
    xnow = xA;  ynow=yA;
   if k ~= num_sets
       elapsed_time = toc;
       msg =   sprintf('Loop %d is over, next loop starts in %.1f seconds',k,delay_time-elapsed_time);
       set(handles.camwait,'string',msg);
       wait(t);
       delete(t);
       toc
   end
end
    
if toTurnOnOrNot ==1
    start(tmr);
end
pause(1);
set(handles.camwait,'string','All done!');



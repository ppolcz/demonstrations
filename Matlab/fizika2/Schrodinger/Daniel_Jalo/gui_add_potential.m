function varargout = gui_2(varargin)
% GUI_2 MATLAB code for gui_2.fig
%      GUI_2, by itself, creates a new GUI_2 or raises the existing
%      singleton*.
%
%      H = GUI_2 returns the handle to a new GUI_2 or the handle to
%      the existing singleton*.
%
%      GUI_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_2.M with the given input arguments.
%
%      GUI_2('Property','Value',...) creates a new GUI_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_2

% Last Modified by GUIDE v2.5 16-May-2015 18:44:09

%varargin{1}

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_2_OutputFcn, ...
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


% --- Executes just before gui_2 is made visible.
function gui_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_2 (see VARARGIN)

% Choose default command line output for gui_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles.x = varargin{1};
handles.y = varargin{2};
handles.output = varargin{2};
axes(handles.axes1)
plot(varargin{1},varargin{2},'k','LineWidth',2)
set(handles.bar,'Min',0.9*max(varargin{2}))
set(handles.bar,'Max',1.1*max(varargin{2}))


ymax = max(handles.y)+.3*(max(handles.y)-min(handles.y));
ymin = min(handles.y)-.3*(max(handles.y)-min(handles.y));
ylim([ymin ymax])

set(handles.bar,'value',max(varargin{2}))

xlim([min(varargin{1}), max(varargin{1})])

handles.ymin = ymin;
handles.ymax = ymax;

guidata(hObject, handles);
uiwait
% UIWAIT makes gui_2 wait for user response (see UIRESUME)
% uiwait(handles.gui_add_potential);


% --- Outputs from this function are returned to the command line.
function varargout = gui_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
guidata(hObject, handles);

varargout{1} = handles.output;
gui_exp_success;
close(handles.gui_add_potential)

% --- Executes on slider movement.
function bar_Callback(hObject, eventdata, handles)
% hObject    handle to bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

t = get(hObject,'value')
x = handles.x;
y = handles.y;

max_y = max(y);
delta = max(x);
m = (t-max_y)/delta;


handles.output = y + m*x;
handles.v = 5;

plot(x,handles.output,'k','LineWidth',2)
ylim([handles.ymin handles.ymax])
xlim([-max(x) max(x)])

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function bar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn_export.
function btn_export_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume
%varargout{2} = handles.V_new;




function varargout = gui_add_bending(varargin)
% gui_add_bending MATLAB code for gui_add_bending.fig
%      gui_add_bending, by itself, creates a new gui_add_bending or raises the existing
%      singleton*.
%
%      H = gui_add_bending returns the handle to a new gui_add_bending or the handle to
%      the existing singleton*.
%
%      gui_add_bending('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui_add_bending.M with the given input arguments.
%
%      gui_add_bending('Property','Value',...) creates a new gui_add_bending or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_add_bending_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_add_bending_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_add_bending

% Last Modified by GUIDE v2.5 19-May-2015 12:38:31

%varargin{1}

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_add_bending_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_add_bending_OutputFcn, ...
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


% --- Executes just before gui_add_bending is made visible.
function gui_add_bending_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_add_bending (see VARARGIN)

% Choose default command line output for gui_add_bending
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

handles.x = varargin{1};
handles.y = varargin{2};
handles.output = varargin{2};
axes(handles.axes1)
plot(varargin{1},varargin{2},'k','LineWidth',2)


ymax = max(handles.y)+.3*(max(handles.y)-min(handles.y));
ymin = min(handles.y)-.3*(max(handles.y)-min(handles.y));
ylim([ymin ymax])

xlim([min(varargin{1}), max(varargin{1})])

handles.ymin = ymin;
handles.ymax = ymax;
5
guidata(hObject, handles);
uiwait
% UIWAIT makes gui_add_bending wait for user response (see UIRESUME)
% uiwait(handles.gui_add_bending);


% --- Outputs from this function are returned to the command line.
function varargout = gui_add_bending_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in btn_export.
function btn_export_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume
%varargout{2} = handles.V_new;


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

guidata(hObject, handles);

t = get(hObject,'value')
x = handles.x;
y = handles.y;

H = 0.25*(max(y)-min(y));
%height = max_y-min_y;

h = x(2)-x(1);


dy = y(2:end)-y(1:end-1);
y_down = find(dy>0);     % desce
y_up = find(dy<0);

lim = [x(1) ; sort([x(y_down);x(y_up)]); x(end)];

for(i=1:numel(lim)-1)
    if(i==1)
        width = lim(i+1) - lim(i);
        n = round(0.35*width/h);
        xl = find(x==lim(i+1))-n:find(x==lim(i+1));
        x_bend = (1:numel(xl))';
        y(xl) = y(xl) + t*H*(x_bend/numel(x_bend)).^2;
    elseif(i==numel(lim)-1)
        width = lim(i+1) - lim(i);
        n = round(0.35*width/h);
        xl = find(x==lim(i))+1:find(x==lim(i))+n+1;
        x_bend = (numel(xl):-1:1)';
        y(xl) = y(xl) - t*H*(x_bend/numel(x_bend)).^2;  
    else
        width = lim(i+1) - lim(i);
        n = round(0.35*width/h);
        xl = find(x==lim(i+1))-n:find(x==lim(i+1));
        x_bend = (1:numel(xl))';
        y(xl) = y(xl) + t*H*(x_bend/numel(x_bend)).^2;
        
        xl = find(x==lim(i))+1:find(x==lim(i))+n+1;
        x_bend = (numel(xl):-1:1)';
        y(xl) = y(xl) - t*H*(x_bend/numel(x_bend)).^2;
    end
end
            

handles.output = y;
handles.v = 5;


plot(x,handles.output,'k','LineWidth',2)
ylim([handles.ymin handles.ymax])
xlim([-max(x) max(x)])

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

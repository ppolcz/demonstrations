function varargout = gyak5_Lebesgue_integral_interactive(varargin)
% GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE MATLAB code for gyak5_Lebesgue_integral_interactive.fig
%      GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE, by itself, creates a new GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE or raises the existing
%      singleton*.
%
%      H = GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE returns the handle to a new GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE or the handle to
%      the existing singleton*.
%
%      GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE.M with the given input arguments.
%
%      GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE('Property','Value',...) creates a new GYAK5_LEBESGUE_INTEGRAL_INTERACTIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gyak5_Lebesgue_integral_interactive_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gyak5_Lebesgue_integral_interactive_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gyak5_Lebesgue_integral_interactive

% Last Modified by GUIDE v2.5 16-Mar-2017 13:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gyak5_Lebesgue_integral_interactive_OpeningFcn, ...
                   'gui_OutputFcn',  @gyak5_Lebesgue_integral_interactive_OutputFcn, ...
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


% --- Executes just before gyak5_Lebesgue_integral_interactive is made visible.
function gyak5_Lebesgue_integral_interactive_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gyak5_Lebesgue_integral_interactive (see VARARGIN)

% Choose default command line output for gyak5_Lebesgue_integral_interactive
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gyak5_Lebesgue_integral_interactive wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gyak5_Lebesgue_integral_interactive_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

numSteps = 13;
set(hObject, 'Min', 1);
set(hObject, 'Max', numSteps);
set(hObject, 'Value', 1);
set(hObject, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);

% save the current/last slider value
value = get(hObject,'Value');

% Update handles structure
guidata(value, handles);

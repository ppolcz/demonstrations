function varargout = gui_exp_success(varargin)
% GUI_EXP_SUCCESS MATLAB code for gui_exp_success.fig
%      GUI_EXP_SUCCESS, by itself, creates a new GUI_EXP_SUCCESS or raises the existing
%      singleton*.
%
%      H = GUI_EXP_SUCCESS returns the handle to a new GUI_EXP_SUCCESS or the handle to
%      the existing singleton*.
%
%      GUI_EXP_SUCCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EXP_SUCCESS.M with the given input arguments.
%
%      GUI_EXP_SUCCESS('Property','Value',...) creates a new GUI_EXP_SUCCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_exp_success_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_exp_success_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_exp_success

% Last Modified by GUIDE v2.5 16-May-2015 18:41:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_exp_success_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_exp_success_OutputFcn, ...
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


% --- Executes just before gui_exp_success is made visible.
function gui_exp_success_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_exp_success (see VARARGIN)

% Choose default command line output for gui_exp_success
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uiwait;
% UIWAIT makes gui_exp_success wait for user response (see UIRESUME)
% uiwait(handles.gui_exp_success);


% --- Outputs from this function are returned to the command line.
function varargout = gui_exp_success_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume;
close(handles.gui_exp_success)

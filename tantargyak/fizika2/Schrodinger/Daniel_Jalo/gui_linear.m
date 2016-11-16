function varargout = gui_linear(varargin)
%GUI_LINEAR M-file for gui_linear.fig
%      GUI_LINEAR, by itself, creates a new GUI_LINEAR or raises the existing
%      singleton*.
%
%      H = GUI_LINEAR returns the handle to a new GUI_LINEAR or the handle to
%      the existing singleton*.
%
%      GUI_LINEAR('Property','Value',...) creates a new GUI_LINEAR using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_linear_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_LINEAR('CALLBACK') and GUI_LINEAR('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_LINEAR.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_linear

% Last Modified by GUIDE v2.5 15-May-2015 18:19:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_linear_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_linear_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before gui_linear is made visible.
function gui_linear_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui_linear
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes gui_linear wait for user response (see UIRESUME)
% uiwait(handles.figure1);
if(nargin>=4)
    axes(handles.axes1)
    Psi = varargin{1};
    H = varargin{2};
    n = get(varargin{3},'value');
    
    p = polyfit(Psi(:,n),H*Psi(:,n),1);
    yfit = polyval(p,Psi(:,n));
    yresid = H*Psi(:,n) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(H*Psi(:,n))-1)*var(H*Psi(:,n));
    R_sq = 1 - SSresid/SStotal;
  
   
    set(handles.rsq,'string',['R^{2} = ' num2str(R_sq)])
    plot(Psi(:,n),H*Psi(:,n),'k.','Markersize',5)
    xlabel('\Psi'), ylabel('H\Psi')

end
% --- Outputs from this function are returned to the command line.
function varargout = gui_linear_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

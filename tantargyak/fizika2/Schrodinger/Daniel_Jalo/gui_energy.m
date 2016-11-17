function varargout = gui_energy(varargin)
%GUI_ENERGY M-file for gui_energy.fig
%      GUI_ENERGY, by itself, creates a new GUI_ENERGY or raises the existing
%      singleton*.
%
%      H = GUI_ENERGY returns the handle to a new GUI_ENERGY or the handle to
%      the existing singleton*.
%
%      GUI_ENERGY('Property','Value',...) creates a new GUI_ENERGY using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_energy_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_ENERGY('CALLBACK') and GUI_ENERGY('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_ENERGY.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_energy

% Last Modified by GUIDE v2.5 15-May-2015 18:19:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_energy_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_energy_OutputFcn, ...
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


% --- Executes just before gui_energy is made visible.
function gui_energy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui_energy
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_energy wait for user response (see UIRESUME)
% uiwait(handles.figure1);
if(nargin>=4)
    axes(handles.axes1)
    E = varargin{1};
    if(sum(E)==0)
        text(0.2,0.5,'No energy levels converged.');
    elseif(sum(E)~=0)
        lev = 1:length(E);
        lev = lev(E~=0);
        
        E = E(E~=0);
        
        %E = [1.4587, 2, 3];
        hold on
        for(n=1:numel(E))
            plot([0.4 1],[E(n) E(n)],'g','linewidth',2)
            text(0.1,E(n),['E_' num2str(lev(n)) ' =' num2str(E(n))]);
        end
        hold off
        ylim([0 1.1*max(E)])
        xlim([0 1])
        ylabel('Energy')
    end
else
    1
end
% --- Outputs from this function are returned to the command line.
function varargout = gui_energy_OutputFcn(hObject, eventdata, handles)
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

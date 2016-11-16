function varargout = main_gui(varargin)
% MAIN_GUI MATLAB code for main_gui.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% KNOWN BUGS
%   * when closing the add E(x) or add Bending GUI an error occurs.
%   * convergence problems.


% Edit the above text to modify the response to help main_gui

% Last Modified by GUIDE v2.5 22-May-2015 00:37:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @main_gui_OutputFcn, ...
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


% --- Executes just before main_gui is made visible.
function main_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_gui (see VARARGIN)

% Choose default command line output for main_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes main_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_btn.
function run_btn_Callback(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes1)
% matlabImage = imread('hourglass.jpg');
% image(matlabImage)
pause(0.1)
set(gca,'YDir','normal');

% adicionar metodo de shooting, apos obter os valores de energia atraves
% dos valores proprios

handles.success = 0;
set(handles.energy_btn,'Enable','on') 
set(handles.phiorsq_popup,'Enable','on')
set(handles.eigenfunction_popup,'Enable','on')

num_wells = str2double(get(handles.num_wells,'string'));
spacing = str2double(get(handles.spacing,'string'));
width = str2double(get(handles.width,'string'));
barrier_pot = str2double(get(handles.barrier_potential,'string'));
well_pot = str2double(get(handles.well_potential,'string'));
L = str2double(get(handles.domain,'string'));

m = 1;
ht = 1;

N = 1000;
handles.N = N;
x = linspace(-L,L,N)';
h = x(2)-x(1)

% build the potentil V(x)

lengths = [];
for (n=1:num_wells)
    if(n==num_wells)
        lengths = [lengths width];
    else
        lengths = [lengths width spacing];
    end
end

lengths = [0 lengths];

for(n=1:length(lengths))
    lengths_t(n) = sum(lengths(1:n));
end
lengths_t = lengths_t - lengths_t(end)/2;
lengths_t = [-L lengths_t L];
handles.lengths_t = lengths_t;

V = zeros(size(x));
for(i=1:length(lengths_t)-1)
    if(mod(i,2)~=0)
        pot = barrier_pot;
    else
        pot = well_pot;
    end
    if(i~=1)
        V = V + (x>lengths_t(i) & x<=lengths_t(i+1))*pot;
    else
        V = V + (x>=lengths_t(i) & x<=lengths_t(i+1))*pot;
    end
end
if((get(handles.add_V_toggle,'value')==1) & (get(handles.band_bending_toggle,'value')==1))
    V = handles.V_bent + handles.V_new - V;
elseif(get(handles.add_V_toggle,'value')==1)
    V = handles.V_new;
elseif(get(handles.band_bending_toggle,'value')==1)
    V = handles.V_bent;
end

% handles.V_bent

e = ones(N,1);
H = -ht^2/(2*m)*spdiags([e -2*e e],[-1 0 1],N,N)/h^2 ...
    + spdiags(V,0,N,N);

for(i=1:6)
    [Psi,E,flag] = eigs(H,5,'sa');
    if(flag==1)
        break
    end
end
handles.E = diag(Psi\(H*Psi));
%handles.E = diag(E);
handles.Psi = Psi;
handles.H = H;


axes(handles.axes1);
if(flag==0)
    text(0.1,0.5,'The algorithm did not converge. Adjust your parameters.');
    axis([0 1 0 1])
    set(handles.energy_btn,'Enable','off') 
    set(handles.phiorsq_popup,'Enable','off')
    set(handles.eigenfunction_popup,'Enable','off')
else
    
    epson = Psi(:,get(handles.eigenfunction_popup,'value'));
    %epson = [-epson(end:-1:2); epson];
    %x = [-x(end:-1:2); x];
    if(sum(epson)<0)
       epson = -epson;
    end
    V_sc = (V)*(max(epson)) - max(epson);
    %V_sc = (x>0.5 | x<-0.5)*max(epson) + ~(x>0.5 | x<-0.5)*max(epson)*min(epson);
    hold on
    for(i=1:numel(lengths_t)-1)
        if(rem(i,2)==1)
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[0.8 1 1])
        else
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[1 1 0.75])
        end
    end
    
    if(get(handles.phiorsq_popup,'value')==1)
        plot(x,epson,'k','Linewidth',2)
        ylim([1.1*min(epson) 1.1*max(epson)])
    else
        plot(x,epson.^2,'k','Linewidth',2)
        ylim([1.1*min(epson.^2) 1.1*max(epson.^2)])
    end
    %plot(x,epson,'r',x,V_sc+0.01,'k:')
    
    xlim([min(x) max(x)])

    hold off
  
    handles.success = 1;
    handles.epson = epson;
    handles.x = x;
    handles.V_sc = V_sc; 
    
    
    guidata(hObject, handles);
end

% --- Executes on button press in plotV_btn.
function plotV_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plotV_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





num_wells = str2double(get(handles.num_wells,'string'));
spacing = str2double(get(handles.spacing,'string'));
width = str2double(get(handles.width,'string'));
barrier_pot = str2double(get(handles.barrier_potential,'string'));
well_pot = str2double(get(handles.well_potential,'string'));
L = str2double(get(handles.domain,'string'));

N = handles.N;
x = linspace(-L,L,N)';

% build the potentil V(x)

lengths = [];
for (n=1:num_wells)
    if(n==num_wells)
        lengths = [lengths width];
    else
        lengths = [lengths width spacing];
    end
end

lengths = [0 lengths];

for(n=1:length(lengths))
    lengths_t(n) = sum(lengths(1:n));
end
lengths_t = lengths_t - lengths_t(end)/2;
lengths_t = [-L lengths_t L];

V = zeros(size(x));
for(i=1:length(lengths_t)-1)
    if(mod(i,2)~=0)
        pot = barrier_pot;
    else
        pot = well_pot;
    end
    if(i~=1)
        V = V + (x>lengths_t(i) & x<=lengths_t(i+1))*pot;
    else
        V = V + (x>=lengths_t(i) & x<=lengths_t(i+1))*pot;
    end
end
    
if((get(handles.add_V_toggle,'value')==1) & (get(handles.band_bending_toggle,'value')==1))
    gui_2(x,handles.V_new+handles.V_bent-V)
elseif(get(handles.add_V_toggle,'value')==1)
    gui_2(x,handles.V_new)
elseif(get(handles.band_bending_toggle,'value')==1)
    gui_2(x,handles.V_bent)
else
    gui_2(x,V)
end

%handles.V_new

% --- Executes on button press in checkLinear_btn.
function checkLinear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to checkLinear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_linear(handles.Psi,handles.H, handles.eigenfunction_popup)

% --- Executes on button press in energy_btn.
function energy_btn_Callback(hObject, eventdata, handles)
% hObject    handle to energy_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_energy(handles.E)
% --- Executes on button press in close_btn.
function close_btn_Callback(hObject, eventdata, handles)
% hObject    handle to close_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(main_gui)

function num_wells_Callback(hObject, eventdata, handles)
% hObject    handle to num_wells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_wells as text
%        str2double(get(hObject,'String')) returns contents of num_wells as a double

set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.band_bending_toggle,'Value',0)
set(handles.add_V_toggle,'Value',0)
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function num_wells_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_wells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spacing_Callback(hObject, eventdata, handles)
% hObject    handle to spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spacing as text
%        str2double(get(hObject,'String')) returns contents of spacing as a double
set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.band_bending_toggle,'Value',0)
set(handles.add_V_toggle,'Value',0)
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double
set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.add_V_toggle,'Value',0) 
set(handles.band_bending_toggle,'Value',0) 
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function barrier_potential_Callback(hObject, eventdata, handles)
% hObject    handle to barrier_potential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of barrier_potential as text
%        str2double(get(hObject,'String')) returns contents of barrier_potential as a double
set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.band_bending_toggle,'Value',0)
set(handles.add_V_toggle,'Value',0)
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function barrier_potential_CreateFcn(hObject, eventdata, handles)
% hObject    handle to barrier_potential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function well_potential_Callback(hObject, eventdata, handles)
% hObject    handle to well_potential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of well_potential as text
%        str2double(get(hObject,'String')) returns contents of well_potential as a double
set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.band_bending_toggle,'Value',0)
set(handles.add_V_toggle,'Value',0)
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function well_potential_CreateFcn(hObject, eventdata, handles)
% hObject    handle to well_potential (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in phiorsq_popup.
function phiorsq_popup_Callback(hObject, eventdata, handles)
% hObject    handle to phiorsq_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns phiorsq_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from phiorsq_popup

if(handles.success==1)
    x = handles.x;
    V_sc = handles.V_sc;
    epson = handles.Psi(:,get(handles.eigenfunction_popup,'value'));
    
    hold on
    lengths_t = handles.lengths_t;
    for(i=1:numel(lengths_t)-1)
        if(rem(i,2)==1)
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[0.8 1 1])
        else
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[1 1 0.75])
        end
    end
    
    if(get(handles.phiorsq_popup,'value')==1)
        plot(x,epson,'k','Linewidth',2)
        ylim([1.1*min(epson) 1.1*max(epson)])
    else
        plot(x,epson.^2,'k','Linewidth',2)
        ylim([1.1*min(epson.^2) 1.1*max(epson.^2)])
    end
    %plot(x,epson,'r',x,V_sc+0.01,'k:')
    
    xlim([min(x) max(x)])
    hold off
    
    
end
    
% --- Executes during object creation, after setting all properties.
function phiorsq_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phiorsq_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in info_btn.
function info_btn_Callback(hObject, eventdata, handles)
% hObject    handle to info_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gui_info



function domain_Callback(hObject, eventdata, handles)
% hObject    handle to domain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of domain as text
%        str2double(get(hObject,'String')) returns contents of domain as a double
set(handles.band_bending_toggle,'Enable','off')
set(handles.add_V_toggle,'Enable','off') 
set(handles.band_bending_toggle,'Value',0)
set(handles.add_V_toggle,'Value',0)
set(handles.energy_btn,'Enable','off') 

% --- Executes during object creation, after setting all properties.
function domain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to domain (see GCBO)
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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, ~, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eigenfunction_popup.
function eigenfunction_popup_Callback(hObject, eventdata, handles)
% hObject    handle to eigenfunction_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eigenfunction_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eigenfunction_popup

if(handles.success==1)
    
    switch get(handles.eigenfunction_popup,'value')
        case 1
            epson = handles.Psi(:,1);
        case 2
            epson = handles.Psi(:,2);
        case 3
            epson = handles.Psi(:,3);
        case 4
            epson = handles.Psi(:,4);
        case 5
            epson = handles.Psi(:,5);
    end
    
    if(sum(epson)<0)
        epson = -epson;
    end
  
    hold on
    lengths_t = handles.lengths_t;
    for(i=1:numel(lengths_t)-1)
        if(rem(i,2)==1)
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[0.8 1 1])
        else
            rectangle('Position',[lengths_t(i) 1.1*min(epson), lengths_t(i+1)-lengths_t(i),1.1*max(epson)+abs(1.1*min(epson))],...
                'FaceColor',[1 1 0.75])
        end
    end
    
    if(get(handles.phiorsq_popup,'value')==1)
        plot(handles.x,epson,'k','Linewidth',2)
        ylim([1.1*min(epson) 1.1*max(epson)])
    else
        plot(handles.x,epson.^2,'k','Linewidth',2)
        ylim([1.1*min(epson.^2) 1.1*max(epson.^2)])
    end
    %plot(x,epson,'r',x,V_sc+0.01,'k:')
    
    xlim([min(handles.x) max(handles.x)])
    hold off

    
end
% --- Executes during object creation, after setting all properties.
function eigenfunction_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eigenfunction_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_potential_btn.
function add_potential_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_potential_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num_wells = str2double(get(handles.num_wells,'string'));
spacing = str2double(get(handles.spacing,'string'));
width = str2double(get(handles.width,'string'));
barrier_pot = str2double(get(handles.barrier_potential,'string'));
well_pot = str2double(get(handles.well_potential,'string'));
L = str2double(get(handles.domain,'string'));

N = 1000;
x = linspace(-L,L,N)';

% build the potentil V(x)

lengths = [];
for (n=1:num_wells)
    if(n==num_wells)
        lengths = [lengths width];
    else
        lengths = [lengths width spacing];
    end
end

lengths = [0 lengths];

for(n=1:length(lengths))
    lengths_t(n) = sum(lengths(1:n));
end
lengths_t = lengths_t - lengths_t(end)/2;
lengths_t = [-L lengths_t L];

V = zeros(size(x));
for(i=1:length(lengths_t)-1)
    if(mod(i,2)~=0)
        pot = barrier_pot;
    else
        pot = well_pot;
    end
    if(i~=1)
        V = V + (x>lengths_t(i) & x<=lengths_t(i+1))*pot;
    else
        V = V + (x>=lengths_t(i) & x<=lengths_t(i+1))*pot;
    end
end

handles.V_new = gui_add_potential(x,V);

set(handles.add_V_toggle,'Enable','on') 
set(handles.add_V_toggle,'Value',1) 

guidata(hObject, handles);


% --- Executes on button press in add_V_toggle.
function add_V_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to add_V_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of add_V_toggle

set(handles.add_potential_btn,'Enable','on') 


% --- Executes on button press in band_bending_toggle.
function band_bending_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to band_bending_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of band_bending_toggle


% --- Executes on button press in add_bending_btn.
function add_bending_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_bending_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

num_wells = str2double(get(handles.num_wells,'string'));
spacing = str2double(get(handles.spacing,'string'));
width = str2double(get(handles.width,'string'));
barrier_pot = str2double(get(handles.barrier_potential,'string'));
well_pot = str2double(get(handles.well_potential,'string'));
L = str2double(get(handles.domain,'string'));

N = 1000;
x = linspace(-L,L,N)';

% build the potentil V(x)

lengths = [];
for (n=1:num_wells)
    if(n==num_wells)
        lengths = [lengths width];
    else
        lengths = [lengths width spacing];
    end
end

lengths = [0 lengths];

for(n=1:length(lengths))
    lengths_t(n) = sum(lengths(1:n));
end
lengths_t = lengths_t - lengths_t(end)/2;
lengths_t = [-L lengths_t L];

V = zeros(size(x));
for(i=1:length(lengths_t)-1)
    if(mod(i,2)~=0)
        pot = barrier_pot;
    else
        pot = well_pot;
    end
    if(i~=1)
        V = V + (x>lengths_t(i) & x<=lengths_t(i+1))*pot;
    else
        V = V + (x>=lengths_t(i) & x<=lengths_t(i+1))*pot;
    end
end

handles.V_bent = gui_add_bending(x,V);

set(handles.band_bending_toggle,'Enable','on') 
set(handles.band_bending_toggle,'Value',1) 

guidata(hObject, handles);

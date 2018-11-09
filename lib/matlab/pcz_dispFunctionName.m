function start_time = pcz_dispFunctionName(subtitle, msg, depth_method)
%%
%
%  file:   pcz_dispFunctionName.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on Tue Jan 05 10:26:32 CET 2016
%  Modified on 2018. March 30.
%

%% 

global SCOPE_DEPTH VERBOSE

% Kiegészítve: 2018.03.30. (március 30, péntek), 01:56
if SCOPE_DEPTH > 0
    pcz_dispFunction('')
else
    disp(' ')
end

if ~VERBOSE
    start_time = tic;
    return
end

[ST,I] = dbstack;

try
    name = ST(2).name;
    line = ST(2).line;
catch
    name = '';
    line = 0;
end

try
    caller.name = ST(3).name;
    caller.line = ST(3).line;
catch
    caller = '';
end

active = matlab.desktop.editor.getActive;
if pversion >= 2016 && contains(name,'LiveEditor') && ~isempty(active)
    fparts = pcz_resolvePath(active.Filename);
    name = fparts.bname;
end

if nargin > 0 && ~isempty(subtitle)
    name = pcz_dispHRefOpenToLine(name,line);
else
    if ~isempty(caller) && ~isempty(caller.name)
        name = [ pcz_dispHRefEditFile(name) ' called from ' pcz_dispHRefOpenToLine(caller.name, caller.line) ];
    else
        name =  pcz_dispHRefEditFile(name);
    end
end    

if ~(nargin < 1 || isempty(subtitle))
    title = [' - [\b<strong>' subtitle '</strong>]\b'];
else
    title = '';
end

if nargin < 2
    msg = '';
end

if nargin < 3
    depth_method = 1;
end

if depth_method == 1
    
    SCOPE_DEPTH = SCOPE_DEPTH + 1;
    depth = SCOPE_DEPTH;
    
    for i = 2:depth
        fprintf('│   ')
    end
    
    msg_text = '';
    if ~isempty(msg)
        msg_text = [' [msg:' msg ']'];
    end
    
    if numel(ST) > I
        fprintf('%s', ['┌ ' name ])
        fprintf([ title '%s\n' ], msg_text)
    end
    
    start_time = tic;
    
else
    
    for i = I+2:numel(ST)
        fprintf('│   ')
    end
    
    msg_text = '';
    if ~isempty(msg)
        msg_text = [' [msg:' msg ']'];
    end
    
    if numel(ST) > I
        fprintf('%s', ['┌ ' name ])
        fprintf([ title '%s\n' ], msg_text)
    end
    
    start_time = tic;
    
end

end

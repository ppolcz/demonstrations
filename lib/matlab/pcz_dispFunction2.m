function [ret] = pcz_dispFunction2(varargin)
%% pcz_dispFunction2
%  
%  File: pcz_dispFunction2.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. April 06.
%

%% make it back-compatible

if nargin > 0 && iscell(varargin{1})
    varargin = varargin{1};
end

%% handle symbolical variables

try
    if nargin == 1 && ~isempty(symvar(varargin{1}))
        if ~isempty(inputname(1))
            varargin{1} = evalc([ inputname(1) ' = varargin{1}' ]);
        else
            varargin{1} = evalc('display(varargin{1})');
        end
    end
catch e
end

%%

global SCOPE_DEPTH VERBOSE

if isempty(VERBOSE) || VERBOSE == 0
    return
end

% [ST,I] = dbstack;
% 
% for i = 2:SCOPE_DEPTH
%     fprintf('│   ')
% end

msg = sprintf(varargin{:});

% if numel(ST) > I    
%     if ~isempty(msg)
%         disp(['│   - ' msg])
%     else
%         disp '│   '
%     end
% else
%     disp(['- ' msg ])
% end


depth = SCOPE_DEPTH;

prefix = '';
if depth >= 1
    tab = '│   ';
    prefix = repmat(tab,[1 depth]);
end

if ~isempty(msg)
    msg = strrep(msg,newline,[ newline prefix ]);
    disp([ prefix '' msg])
else
    disp([ prefix ' '])
end


end
function [ret] = pcz_dispFunctionSubtitle(varargin)
%% pcz_dispFunctionSubtitle
%  
%  File: pcz_dispFunctionSubtitle.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. April 06.
%

%% make it back-compatible

if nargin > 0 && iscell(varargin{1})
    varargin = varargin{1};
end

%%

global SCOPE_DEPTH
global VERBOSE

if ~VERBOSE
    return
end

pcz_dispFunction ''

[ST,I] = dbstack;

for i = 2:SCOPE_DEPTH
    fprintf('│   ')
end

msg = sprintf(varargin{:});

if numel(ST) > I    
    if ~isempty(msg)
        disp(['│   ' msg])
    else
        disp '│   '
    end
else
    disp(msg)
end

end
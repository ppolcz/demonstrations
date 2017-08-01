function [ret] = pcz_OK_FAILED(bool, varargin)
%% Script pcz_OK_FAILED
%  
%  file:   pcz_OK_FAILED.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 14:06:46
%
%%

k = [0 0 0];
g = [0 0.7 0];
r = [1 0 0];
b = [0 0 1];

if islogical(bool)

    if bool
        % fprintf('[  %s  ] ', colorizedstring('green','OK'))
        cprintf(k, '[  ')
        cprintf(g, 'OK')
        cprintf(k, '  ] ')
    else
        % fprintf('[%s] ', colorizedstring('red','FAILED'))
        cprintf(k,'[')
        cprintf(r, 'FAILED')
        cprintf(k, '] ')
    end

    if ~isempty(varargin)
        cprintf(k, varargin{:})
    end

elseif ischar(bool)
    cprintf(k, '[ ')
    cprintf(b, 'INFO')
    cprintf(k,' ] ')
    cprintf(k, bool, varargin{:});
end

end
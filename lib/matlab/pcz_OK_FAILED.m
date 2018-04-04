function [ret] = pcz_OK_FAILED(bool, varargin)
%% Script pcz_OK_FAILED
%  
%  file:   pcz_OK_FAILED.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 14:06:46
%  Modified on 2018.04.04. (április  4, szerda), 20:09
%
%%

if ~islogical(bool) && ~ischar(bool)
    bool = bool == 1;
end

if islogical(bool)

    if bool
        % fprintf('[  %s  ] ', colorizedstring('green','OK'))
        fprintf('[   ');
        cprintf('*green', 'OK ');
        fprintf('  ] ');
    else
        % fprintf('[%s] ', colorizedstring('red','FAILED'))
        fprintf('[ ');
        cprintf('*err', 'FAILED ');
        fprintf('] ');
    end

    if ~isempty(varargin)
        fprintf(varargin{:})
    end

elseif ischar(bool)
    fprintf('[  ');
    cprintf('*blue', 'INFO ');
    fprintf(' ] ');
    fprintf(bool, varargin{:});
end

end
function [ret] = pcz_info(bool, varargin)
%%
%
%  file:   pcz_info.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2017.01.06. Friday, 13:56:14
%

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

    cprintf('black', varargin{:})

elseif ischar(bool)
    cprintf(k, '[ ')
    cprintf(b, 'INFO')
    cprintf(k,' ] ')
    cprintf(k, bool, varargin{:});
end

fprintf('\n')

% cprintf('_green', 'underlined green');

% web('text://<html><h1>Hello World</h1></html>')

end
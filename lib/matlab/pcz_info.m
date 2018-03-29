function [ret] = pcz_info(bool, varargin)
%%
%
%  file:   pcz_info.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2017.01.06. Friday, 13:56:14
%

global SCOPE_DEPTH VERBOSE

if nargin == 1 && iscell(bool)
    varargin = bool(2:end);
    bool = bool{1};
end

[ST,I] = dbstack;
    
depth = SCOPE_DEPTH;

if VERBOSE
    
    if depth >= 0
        for i = 2:depth
            fprintf('│   ')
        end

        if numel(ST) > I
            fprintf('│   ')
        end
    end
    
    pcz_OK_FAILED(bool, varargin{:});

    fprintf('\n')
end

if nargout > 0
    if islogical(bool)
        ret = ~bool;
    else
        ret = [];
    end
end
    
% cprintf('_green', 'underlined green');

% web('text://<html><h1>Hello World</h1></html>')

end
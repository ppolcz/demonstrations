function [ret] = pcz_warning(bool, varargin)
%% 
%  
%  file:   pcz_warning.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.06. Friday, 13:02:42
%


global SCOPE_DEPTH VERBOSE

if nargin == 1 && iscell(bool)
    varargin = bool(2:end);
    bool = bool{1};
end

if isnumeric(bool) && isscalar(bool)
    bool = bool ~= 0;
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
    
end

if islogical(bool)
       
    if bool && VERBOSE
        fprintf('[  ')
        cprintf('green', 'OK')
        cprintf('text', '  ] ')
        if ~isempty(varargin), fprintf(varargin{:}); end
    elseif ~bool
        fprintf('[  ')
        cprintf('*[1,0.5,0]', 'WARN ')
        fprintf(' ] ')
        if ~isempty(varargin), fprintf(varargin{:}); end
    end

else

    varargin = [bool varargin];
    
    fprintf('[  ')
    cprintf('*[1,0.5,0]', 'WARN ')
    fprintf(' ] ')
    if ~isempty(varargin), fprintf(varargin{:}); end
    
end

fprintf('\n')


end
function [ret] = pcz_info(bool, varargin)
%%
%
%  file:   pcz_info.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2017.01.06. Friday, 13:56:14
%

global SCOPE_DEPTH VERBOSE

% Find link to the caller code
% s = dbstack;
% link = '';
% stack_depth = 2;
% if numel(s) >= stack_depth
%     line = num2str(s(stack_depth).line);
%     file = s(stack_depth).file;
%     
%     filepath = which(file);
%     
%     cmd_line = [ 'opentoline(''' filepath ''',' line ')' ];
%     link = [ pcz_dispHRefMatlab([ file ':' line ], cmd_line) ' '];
% end

% Append GOTO link to the first parameter after the bool
% if numel(varargin) > 1 && ischar(varargin{1})
%     varargin{1} = [link varargin{1}];
% else
%     varargin{1} = link;
% end

if nargin == 1 && iscell(bool)
    varargin = bool(2:end);
    bool = bool{1};
end

depth = SCOPE_DEPTH;

if VERBOSE

    prefix = '';
    if depth >= 1
        tab = '│   ';
        prefix = repmat(tab,[1 depth]);
    end
    
    disp(prefix)

    fprintf(prefix)
    pcz_OK_FAILED(bool, varargin{:});
    fprintf('\n')

    pcz_dispFunctionStackTrace('', 'first', 3)
    
    % disp([prefix '- ' link])
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
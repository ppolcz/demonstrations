function [ret] = pcz_dispFunction_num2str(A, varargin)
%% pcz_dispFunction_num2str
%  
%  File: pcz_dispFunction_num2str.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. April 30.
%

%%

global SCOPE_DEPTH VERBOSE

if ~VERBOSE
    return
end

o.format = '%8.3f';
o.del1 = ' , ';
o.del2 = ' ; ';
o.del2end = '';
o.pref = '';
o.beginning = '[ ';
o.ending = ' ]';
o.round = 4;
o.inputname = '{inputname}';
o.label = '';
o.name = '';
o = parsepropval(o,varargin{:});


% [ST,I] = dbstack;
% 
% for i = 2:SCOPE_DEPTH
%     fprintf('│   ')
% end

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

if isempty(o.label) && isempty(o.name)
    name = inputname(1);
else
    name = [o.label o.name ];
end
label = [ name ' = ' ];

pref2 = repmat(' ',[1 numel(label)+1]);

str = [ prefix ...
    pcz_num2str(A, 'name', name, 'del1', ' ', 'del2', [ '\n' prefix pref2 ], ...
    'pref', '    ', 'beg', '[', ... '{inputname} = ', ...
    'end', ' ]', varargin{:}, 'label', label) ];

if nargout > 0
    ret = str;
else
    disp([prefix ' '])
    disp(str);
    pcz_dispFunctionStackTrace('', 'first', 1, 'last', 0);
    % disp([prefix ' '])
end

end
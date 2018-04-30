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

label = [inputname(1) ' = '];

pref2 = repmat(' ',[1 numel(label)+1]);

str = [ prefix ...
    pcz_num2str(A, 'name', inputname(1), 'del1', ' ', 'del2', [ '\n' prefix pref2 ], ...
    'pref', '    ', 'beg', '[', ...
    'label', label, ... '{inputname} = ', ...
    'end', ' ]', varargin{:}) ];

if nargout > 0
    ret = str;
else
    disp([prefix ' '])
    disp(str);
    pcz_dispFunctionStackTrace('', 'first', 1, 'last', 0);
    disp([prefix ' '])
end

end
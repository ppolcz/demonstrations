function pcz_handleException(ex, varargin)
%% 
%  
%  file:   pcz_handleException.m
%  author: Polcz Péter <ppolcz@gmail.com> 
% 
%  Created on Tue Sep 23 22:25:29 CEST 2014
%

%%

% if (nargin > 0)
% 	tmp = varargin{1};
% end

fprintf([ '\n\n============================================================\n'...
    'Error message:\n------------------------------------------------------------\n'... 
    'Message: \n%s\nIdentifier:\n%s\n'],...
    ex.getReport('extended'),...
    ex.identifier);
fprintf('============================================================\n')

end

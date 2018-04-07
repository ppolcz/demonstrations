function varargout = pcz_generateBeginEndTimer
%% 
%  
%  file:   pcz_generateBeginEndTimer.m
%  author: Polcz P�ter <ppolcz@gmail.com> 
% 
%  Created on 2016.01.17. Sunday, 13:30:51
%

%
%%

var = ['TMP_' pcz_generateString(20, 0) ];
beginning = sprintf('%s = pcz_dispFunctionName;\n\n%%%%\n\n', var);
ending = sprintf('\n%%%%\n%% End of the script.\npcz_dispFunctionEnd(%s);\nclear TMP_*\n\n', var);

%%
if nargout == 1
    varargout{1} = [beginning ending];
elseif nargout == 2
    varargout{1} = beginning;
    varargout{2} = ending;
else
    beginning = sprintf('pcz_dispFunction('''')\n%s = pcz_dispFunctionName;\n', var);
    ending = sprintf('pcz_dispFunctionEnd(%s);', var);
    clipboard('copy', [beginning ending])
end
    
end

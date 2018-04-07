function fname = pcz_getFunctionName
%% 
%  
%  file:   pcz_getFunctionName.m
%  author: Polcz Péter <ppolcz@gmail.com> 
% 
%  Created on Tue Jan 05 10:23:59 CET 2016
%

%%

[ST,I] = dbstack;

fname = '';
if numel(ST) > I
    fname = ST(I+1).name;
end

fname = [fname ' [pcz_getFunctionName:deprecated, use mfilename]'];

end

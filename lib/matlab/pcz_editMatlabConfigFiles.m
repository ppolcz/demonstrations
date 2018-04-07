%% 
%  
%  file:   pcz_editMatlabConfigFiles.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.01.27. Wednesday, 14:36:23
%
%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

%%

MATLB_ROOT = matlabroot;

edit([MATLB_ROOT '/toolbox/local/TC.xml'])
edit([MATLB_ROOT '/toolbox/local/pathdef.m'])
edit([MATLB_ROOT '/toolbox/local/Contents.m'])

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
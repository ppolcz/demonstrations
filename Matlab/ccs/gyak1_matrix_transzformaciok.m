%% 
%  
%  file:   gyak1_matrix_transzformaciok.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.16. Thursday, 10:24:33
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% SAS-TAS

prand = @(n) round(3*randn(n),1);

T = prand(2)
S = prand(2)

v = prand([2 1])


%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
%% 
%  
%  file:   gyak1.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.22. Wednesday, 14:05:22
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% [HF1]

a = @(x,y) [abs(2*x - y),abs(x)];
n = @(x,y) max(abs(2*x - y),abs(x));

[x,y] = meshgrid(linspace(-4,4,500));
z = n(x,y);

contour(x,y,z, [1,1]),
grid on

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
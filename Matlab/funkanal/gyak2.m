%% 
%  
%  file:   gyak2.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.22. Wednesday, 15:36:09
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_aOXKpNJuFwEKfWZJPbjT = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% 6. feladat (a)
syms x real

f = x;
g = sqrt(x);

Norm_inf = subs(abs(f-g),x,solve(diff(f - g,x),x))
Norm_2 = int((x - sqrt(x))^2, 0, 1)

%% 9. feladat

syms x real

Norm_fmg = subs(abs(f-g),x,solve(diff(f - g,x),x))
Norm_fpg = subs(f+g,x,1)

%% end of the scope
pcz_dispFunctionEnd(TMP_aOXKpNJuFwEKfWZJPbjT);
clear TMP_aOXKpNJuFwEKfWZJPbjT
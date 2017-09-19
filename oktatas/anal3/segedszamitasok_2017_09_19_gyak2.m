%% Script segedszamitasok_2017_09_19_gyak2
%  
%  file:   segedszamitasok_2017_09_19_gyak2.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 19.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Vektoriális szorzat

syms a b c x y z real
v = [a;b;c];
r = [x;y;z];

cross(v,r)

%% $\rm{div}(\rm{grad}~ \|r\|^5 )$

f = sqrt(x^2+y^2+z^2)^5;
gradf = gradient(f,r)
div_gradf = simplify(divergence(gradf,r))

%% Paraméteres feladat

syms a b real

F = [
    y*z^2
    x*z^2 + a*y*z
    b*x*y*z + y^2
    ];

rotF = curl(F)

collect_rotF = collect(rotF,r)

%% Deriválási szabályok
% <anal3_vekanal_1_17_08_16_Time205149_runID9151.php#derivszabalyok
% Deriválási szabályok Matlab Symbolic Math Toolbox segítségével
% történő ellenőrzése>

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
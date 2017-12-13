%% Script Erikovics_cikloid
%  
%  File:   Erikovics_cikloid.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. December 13.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH VERBOSE 
SCOPE_DEPTH = 0;
VERBOSE = 1;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

syms t phi

a = 4;
R = 3;

s = [
    a * (t - sin(t))
    R * cos(phi)
    a * (1 - cos(t)) + R * sin(phi)
    ]

vars = [t, phi];

s1 = matlabFunction(s(1),'vars', vars);
s2 = matlabFunction(s(2),'vars', vars);
s3 = matlabFunction(s(3),'vars', vars);

[t,phi] = meshgrid(linspace(0,4*pi,100),linspace(0,2*pi,50));

s1_num = s1(t,phi);
s2_num = s2(t,phi);
s3_num = s3(t,phi);

surf(s1_num, s2_num, s3_num)
axis equal

xlabel x
ylabel y
zlabel z



%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
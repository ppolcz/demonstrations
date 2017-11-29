%% Script d2017_11_29_lqservo
%  
%  File:   d2017_11_29_lqservo.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. November 29.
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

%%

s = tf('s');

H = (s - 1) / (s^2 - 4*s + 2.4) / (s^2 - 2*s + 5);

pzmap(H)


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
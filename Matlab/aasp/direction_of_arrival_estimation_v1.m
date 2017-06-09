%% Script direction_of_arrival_estimation_v1
%  
%  file:   direction_of_arrival_estimation_v1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.09. Friday, 10:01:27
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

fc = 30*1e9;
c = 299792458;

T = 2*pi / fc * c;




%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
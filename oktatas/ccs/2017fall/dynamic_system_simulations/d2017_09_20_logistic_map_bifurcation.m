%% Script d2017_09_20_logistic_map_bifurcation
%  
%  file:   d2017_09_20_logistic_map_bifurcation.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 20.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_NnAKUXChhnRnQmWsknGy = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

r = 3.827;
N = 200;
x0 = 0.2;
x = [x0 zeros(1,N-1)];

for i = 1:N-1
    x(i+1) = r*x(i)*(1 - x(i)); 
end

plot(x)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_NnAKUXChhnRnQmWsknGy);
clear TMP_NnAKUXChhnRnQmWsknGy
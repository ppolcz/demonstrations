%% Script gyak6_2016_ZH1_gyak_megoldasai
%  
%  file:   gyak6_2016_ZH1_gyak_megoldasai.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.20. Monday, 14:39:22
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

%% 1. feladat
% Compute the causal convolution of functions $e^{-t}$ and $e^t$.
% 
syms t tau real
int(exp(t-tau)*exp(-tau),tau,[0,t])

%% 2. feladat
% Compute the impulse response of system 
% 
% $$H(s) = \frac{-2 s + 1}{s^2 - s -12}$$

syms s
ilaplace((-2*s+1)/(s^2 - s -12));
pretty(ans)


%%

T = round(rand(3)*2);
while det(T) ~= 1
    T = round(rand(3)*2);
    det(T)
end

T
inv(T)

%%


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
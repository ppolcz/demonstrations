%% Laplace transformation
%  
%  file:   laplace_transformation.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 17.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_SWJNMuIiKbocfQKqXbwt = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Laplace transform of trigonometric functions

syms t a b c d e f g real
syms s

laplace(sin(a*t))

ilaplace( (a*s+b) / ((s-c)^2 + d^2))
pretty(ans)


ilaplace((3*s+5)/(s^2-2*s+5))
pretty(ans)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_SWJNMuIiKbocfQKqXbwt);
clear TMP_SWJNMuIiKbocfQKqXbwt
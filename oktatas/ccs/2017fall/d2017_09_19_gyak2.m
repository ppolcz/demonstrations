%% Script d2017_09_19_gyak2
%  
%  file:   d2017_09_19_gyak2.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 19.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_bSWJNMuIiKbocfQKqXbw = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Állapottranszformációk, diagonális realizáció

n = 5;
A = randn(n); A = A + A';
B = randn(n,1);
C = randn(1,n);
D = randn(1,1);

[S,A_] = eig(A);

% A_ = S\A*S;
B_ = S\B;
C_ = C*S;

Original = tf(ss(A,B,C,D))
Transformed = tf(ss(A_,B_,C_,D))


%%
% End of the script.
pcz_dispFunctionEnd(TMP_bSWJNMuIiKbocfQKqXbw);
clear TMP_bSWJNMuIiKbocfQKqXbw
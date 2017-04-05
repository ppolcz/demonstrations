%% Script gyak8_Hermite_stationary_Schrodinger
%  
%  file:   gyak8_Hermite_stationary_Schrodinger.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.05. Wednesday, 21:06:23
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_JaFuVaywxOqOybjLyhrF = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Hermite functions are solutions of the Schrodinger equation

syms x real
H_sym = @(n) expand((-1)^n * exp(x^2) * diff(exp(-x^2),x,n));
H = @(n,x) feval(matlabFunction(H_sym(n)), x);

Psi = @(n,x) 1/sqrt(2^n * factorial(n)) * pi^(-1/4) * (exp(-x.^2/2) .* H(n,x));

n = 5;

xlims = 3*sqrt(n);
res = round(3*sqrt(n)*100);
x = linspace(-xlims,xlims,res);

plot(x,Psi(n,x))
xlim([-xlims,xlims])

%%
% End of the script.
pcz_dispFunctionEnd(TMP_JaFuVaywxOqOybjLyhrF);
clear TMP_JaFuVaywxOqOybjLyhrF
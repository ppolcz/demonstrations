%% Script nonlin_controllability_v1
%
%  file:   nonlin_controllability_v1.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.06.03. Saturday, 17:56:53
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%%

syms x1 x2 x3 real
x = [x1;x2;x3];

mu0 = 1;
k1 = 0.5;
k2 = 2;
Y = 4;
Sf = 1;
mu(x) = mu0 * x2 / (k1 + x2 + k2*x2^2);

f(x) = [
    mu * x1
    -1/Y * mu * x1
    0
    ];

g(x) = [
    -x1/x3
    (Sf - x2) / x3
    1
    ]

%%
% End of the script.
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb
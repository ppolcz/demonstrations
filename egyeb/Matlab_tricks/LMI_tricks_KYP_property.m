%% LMI_tricks_KYP_property
%  
%  File: LMI_tricks_KYP_property.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. February 12.
%

%%
% Automatically generated stuff

global SCOPE_DEPTH VERBOSE LATEX_EQNR 
SCOPE_DEPTH = 0;
VERBOSE = 1;
LATEX_EQNR = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = Persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

a = 3;
b = 10;

A = randn(a);
A = -A'*A;
R = sdpvar(a,b);

M = [ 
    A R
    R' zeros(b)
    ];

sdpopts = sdpsettings('solver','mosek');

CONS = [ M <= 0, R(1) >= 0.0001 ];

optimize(CONS, [], sdpopts)

A = value(A);
M = value(M);

eig(A), eig(M)

check(CONS)


%%

pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_*


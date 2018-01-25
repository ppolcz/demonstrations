%% LMI tricks
%  
%  File:   LMI_tricks.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. November 21.
%
%%

global SCOPE_DEPTH VERBOSE LATEX_EQNR 
SCOPE_DEPTH = 0;
VERBOSE = 1;
LATEX_EQNR = 0;

%% Preserve a full matrix to have very large values

C = sdpvar(2,3);

sdpopts = sdpsettings('verbose', 0);

mu = 10000;

optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , sum(C(:)) , sdpopts);
val_C = value(C)

%%
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , -sum(C(:)) , sdpopts);
val_C = value(C)

%%
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , C(1) , sdpopts);
val_C = value(C)

%% 
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , C(1)+C(3) , sdpopts);
val_C = value(C)

%%

a = 5;
b = 3;

A = sdpvar(5);
R = sdpvar(5,3);

M = [ 
    A R
    R' zeros(b)
    ];

sdpopts = sdpsettings('solver','mosek');

optimize([ A <= -1e-10 , M >= 0 ] , [], sdpopts)

A = value(A);
M = value(M);

eig(A), eig(M)


%% Fontos kérdések
%% 1. kérdés
% 
% $$ P \succeq 0 \overset{?}{\Leftrightarrow} \pmqty{P & R \\ R^T & 0} \succeq 0 $$
% 
% Válasz: *nem*, mivel. Attól, hogy $P \succeq 0$ még létezhet $R$ ú.h.
% $\pmqty{P & R \\ R^T & 0}$ indefinit lesz.


a = 5;
b = 3;

P = randn(a);
P = P*P';
R = randn(a,b);

%%

pcz_num2str_latex_output(eig([P R ; R' zeros(b)])','label','\text{Sajátértékek}: ', 'esc', 0)

%% 
% Fordítva igaz-e? Sejtés: *igen*.

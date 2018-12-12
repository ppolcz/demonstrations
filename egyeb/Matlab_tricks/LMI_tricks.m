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

%% 2. kérdés

n = 4;
m = 5;

P = sdpvar(n);
L = sdpvar(n,m);

i = round(n*m*rand() - 0.1) + 1;

M = [ P L ; L' zeros(m,m) ];

CONS = [ M <= 0 , L(i) > 1e-5 ]

sdpopts = sdpsettings('solver','sedumi')

optimize(CONS,[],sdpopts)
check(CONS)

M = value(M);
L = value(L);


Eig_M = eig(M)
Norm_L = norm(L)

%% 3. kérdés
% Ha $P > 0$, akkor $L^T P L > 0$ minden $L$ esetén?

n = 5;
m = 3;

% Probalok ellenpeldat keresni.
P = randn(n); P = P'*P;

for i = 1:1000
    L = randn(n,m);
    
    pcz_posdef_report(L'*P*L, 10, 1, 'Eigenvalues: %s, ', pcz_num2str(eig(L'*P*L), 'format', '%7.1f'));
end

%% 4. kérdés
% ( X I ; I Y ) > 0, mit garantál
% V

n = 2;

X = sdpvar(n);
Y = sdpvar(n);

I = eye(n);

LMI = [
    X I 
    I Y
    ];

CONS = LMI >= 0;

sol = optimize(CONS)

X = double(X)
Y = double(Y)

%% 5. kérdés
% M = [ A B ; B' e*C ]
% A, C kicsi, B nagy értékűek.
% Létezik-e mindig olyan e nagy szám, hogy mégis pozitív definit legyen.

n = 66;
m = 66;

P = randn(n); P = P*P';
P = eye(n);
R = 2000*randn(n,m/3)*randn(m/3,m);
Q = sdpvar(m);

M = [ Pe R ; R' Q ];

CONS = M + 0.00001 * eye(n+m) >= 0;

optimize(CONS)

Q = value(Q);
M = value(M);

eig(M)';


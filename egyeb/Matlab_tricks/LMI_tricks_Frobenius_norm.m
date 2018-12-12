%% LMI_tricks_Frobenius_norm
%  
%  File: LMI_tricks_Frobenius_norm.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. December 12.
%

%% 5. Optimize Frobenius norm
% https://math.stackexchange.com/questions/2184430/minimization-of-frobenius-norm-and-schur-complement?answertab=votes
% https://math.stackexchange.com/questions/252819/why-is-frobenius-norm-of-a-matrix-greater-than-or-equal-to-the-2-norm

m = 5;
n = 3;

Sigma_F = randn(m);
A = randn(m,n);
Sigma_P = sdpvar(n);

M = Sigma_F + A*Sigma_P*A';


CONS = [ Sigma_P >= 0 ];

obj = trace(M*M');

optimize(CONS,obj)

P_val1 = double(Sigma_P)
obj_val1 = double(obj)


%%% MASKEPP

Sigma_P = sdpvar(n);
X = sdpvar(m);

M = Sigma_F + A*Sigma_P*A';

Lambda = [
    eye(m)  M
    M'      X
    ];

CONS = [ Lambda >= 0 , Sigma_P >= 0 ];
obj = trace(X);

optimize(CONS, obj)


Sigma_P_val2 = double(Sigma_P)
obj_val2 = double(obj)


%% Numerikusan instabil

m = 3;
n = 2;
k = 1;

Sigma_P = sdpvar(n);
X = sdpvar(m);

Sigma_F = 1e7*randn(m,k);
Sigma_F = Sigma_F*Sigma_F';

A = randn(m,n);

M = Sigma_F + A*Sigma_P*A';

Lambda = [
    eye(m)  M
    M'      X
    ];

CONS = [ Lambda >= 0 , Sigma_P - eye(n) >= 0 ];
obj = trace(X);

optimize(CONS, obj)


Sigma_P_val2 = double(Sigma_P)
obj_val2 = double(obj)


%% Numerikusan instabil (konstans matrix normajat keressunk)

m = 3;
n = 2;
k = 1;

Sigma_P = randn(n);
Sigma_P = Sigma_P * Sigma_P';

% Ez okozza az instabilitast
Sigma_F = 1e7*randn(m,k);
Sigma_F = Sigma_F*Sigma_F';

A = randn(m,n);

M = Sigma_F + A*Sigma_P*A';

X = sdpvar(m);

Lambda = [
    eye(m)  M
    M'      X
    ];

CONS = [ Lambda >= 0 ];
obj = trace(X);

optimize(CONS, obj)


Sigma_P_val2 = double(Sigma_P)
obj_val2 = double(obj)


%% Numerikusan instabil (megoldas - konstans matrix normajat keressunk)

m = 106;
n = 18;
k = 7;

Sigma_P = randn(n);
Sigma_P = Sigma_P * Sigma_P';

Sigma_F = 1e4*randn(m,k);
Sigma_F = Sigma_F*Sigma_F';

A = randn(m,n);

M = Sigma_F + A*Sigma_P*A';

X = sdpvar(m);
L = sdpvar(1);

Lambda = [
    L*eye(m)  M
    M'        X
    ];

CONS = [ Lambda >= 0 ];
obj = trace(X) + L;

optimize(CONS, obj)


Sigma_P_val2 = double(Sigma_P)
obj_val2 = double(obj)
L_val = double(L)

Norm_1 = trace(double(X)) * L_val
Norm_2 = trace(M*M')

%% Numerikusan instabil (megoldas)

m = 106;
n = 18;
k = 7;

Sigma_P = sdpvar(n);
X = sdpvar(m);
L = sdpvar(1); % Ez hozza a helyre a numerikus problemakat

% Ez okozza a numerikus problemakat
Sigma_F = 1e4*randn(m,k);
Sigma_F = Sigma_F*Sigma_F';


A = randn(m,n);

M = Sigma_F + A*Sigma_P*A';

Lambda = [
    L*eye(m)  M
    M'        X
    ];

CONS = [ Lambda >= 0 , Sigma_P - eye(n) >= 0 ];
obj = trace(X) + L;

optimize(CONS, obj)


Sigma_P_val2 = double(Sigma_P);
obj_val2 = double(obj);
L_val = double(L);
M_val = double(M);
X_val = double(X);

Norm_1 = trace(X_val) * L_val
Norm_2 = trace(M_val*M_val')

%% LTI controllability observability
% <html><p class="lead">Check controllability and observability of an LTI
% system using LMI conditions</p></html>
%  
%  File: LTI_ctrb_obsv.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 06.
%

%% Generate an unstable non-minimum phase MIMO LTI system

a = 4;        % Nr. of contr. and obs.
b = 2;        % Nr. of contr. and unobs.
c = 1;        % Nr. of uncontr. and obs.
d = 2;        % Nr. of uncontr. and unobs.
n = a+b+c+d;  % Nr. of states
m = 2;        % Nr. of inputs
p = 3;        % Nr. of outputs
is_stabilisable = 1;

[A,B,C,D] = generate_LTI_MIMO(a,b,c,d,m,p,is_stabilisable);

pcz_display(A,B,C,D)

%% Compute the uncontrollable eigenvalues
%
% Check wether the system is stabilisable.

Cn = ctrb(A,B);

[U,Sigma,V] = svd(Cn);

T = U';

A_Ctrb_Staircase = round(T*A*T',10)
B_Ctrb_Staircase = round(T*B,10)

k = c+d-1;
A_Unctrb = A_Ctrb_Staircase(end-k:end,end-k:end)

Uncontrollable_Eigenvalues = eig(A_Unctrb)

%%%
% Check wether the system is detectable.


On = obsv(A,C);

[U,Sigma,V] = svd(On);

T = V';

A_Obsv_Staircase = round(T*A*T',10)
C_Obsv_Staircase = round(C*T',10)

k = b+d-1;
A_Unobsv = A_Obsv_Staircase(end-k:end,end-k:end)

Unobservable_Eigenvalues = eig(A_Unobsv)

%% Compute a stabilising static state feedback gain with LMI

Q = sdpvar(n,n,'symmetric');
N = sdpvar(m,n,'full');

CONS = [
    Q - 0.0001*eye(n) >= 0
    Q*A' + A*Q - B*N - N'*B' + 0.0001*eye(n) <= 0
    ];

sdpopts = sdpsettings('solver', 'sedumi');
sol = optimize(CONS,[],sdpopts)

Q = double(Q);
N = double(N);
P = inv(Q);
K = N/Q;

%%%
% Check solution

Eigenvalues_of_the_closed_loop = eig(A - B*K)

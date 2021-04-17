%%
%  File: YALMIP_tricks_optimizer.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. April 17. (2020b)
%

%% NEM SIKER

n = 3;
A = sdpvar(3,3,'full');
P = sdpvar(3);

CONS = [
    P >= eye(n)
    A'*P + P*A <= eye(n)
    ];

sdps = sdpsettings('solver','mosek');
OPTI = optimizer(CONS,[],sdps,A,P);

L = randn(3);
A = L*L';
P = OPTI(A)
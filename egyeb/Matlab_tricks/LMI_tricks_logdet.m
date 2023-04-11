%%
%  File: LMI_tricks_logdet.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2023. April 05. (2022b)
%

n = 3;
P = sdpvar(n)


Obj = det(P)^(1/n);
Obj = log(geomean(P));
% Obj = -logdet(P);

% Obj = log(det(P));


A = magic(n);
B = A(:,1);
K = lqr(A,B,eye(n),1);
A = A - B*K;

CONS = [ A*P - P*A' <= 0  ];

opts = sdpsettings('Solver','sdpt3','debug','on');
sol = optimize(CONS,[],opts)

P_ = double(P)

logdet(P_)
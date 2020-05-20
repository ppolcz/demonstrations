%% LMI_tricks_fullrank_constraint
%  
%  File: LMI_tricks_fullrank_constraint.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2020. May 18. (2019b)
%
% 
% Mondjuk ez eleg egyertelmu, de azert leirom.
% 
% 1. Ha M teljes rangu, akkor barmilyen Theta > 0 -ra, M' * Theta * M > 0.
% 
% 2. Ha M ranghianyos, akkor legfeljebb M' * Theta * M >= 0

%% 1. 

Theta = sdpvar(4); 
G = randn(4); 
CONS = G'*Theta*G - eye(4) >= 0; 
sol = optimize(CONS), 
check(CONS), 
eig(value(Theta))

%% 2.

Theta = sdpvar(4); 
G = randn(4,3)*randn(3,4); 
CONS = G'*Theta*G - eye(4) >= 0; 
sol = optimize(CONS)
check(CONS)
eig(value(Theta))


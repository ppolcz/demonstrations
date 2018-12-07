%% Kvadratikus_SDP
%  
%  File: Kvadratikus_SDP.m
%  Directory: 2_demonstrations/workspace/konzultacio/Boethy_Molnar_Peter
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. December 07.
%

n = 4;
Sigma_P = sdpvar(n)
Sigma_F = rand(n)
A = rand(n)
tmp = Sigma_F + A * Sigma_P * A'
obj = trace(tmp*tmp')
optimize([],obj)
Sigma_P = double(Sigma_P)
obj = double(obj)

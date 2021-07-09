%%
%  File: Matrix_tricks_1.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. July 09. (2021a)
%

n = 4;

S = randn(4);
S = S*S';

Lambda = diag(10*rand(4,1)+1);
Lambda = randn(4);
Lambda = Lambda*Lambda';

iLambda = inv(Lambda);

iS = inv(S);


Egyik = iLambda/(iLambda + iS)*iLambda

Masik = (S + Lambda)\S/Lambda

Egyik - Masik

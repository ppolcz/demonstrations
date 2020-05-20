%% LMI_tricks_KYP_lemma
%  
%  File: LMI_tricks_KYP_lemma.m
%  Directory: 2_demonstrations/egyeb
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2020. May 18. (2019b)
%

He = he;

%%
% Ha (A,B,C,D)-nek vannak instabil zerói akkor ez nem megolható. (SEJTÉS)

A = -[1 2 ; -1 2];
B = [1;-2.1];
% B = [1;-1.9];
C = [ 1 2 ];
D = 1;

P = sdpvar(2);
Theta = sdpvar(1);

LMI_1 = [ 
    He{ P*A } , P*B 
    B'*P      , 0 
    ] + [C D]'*Theta*[C D] <= 0;

CONS = [ LMI_1 , P - eye(2) >= 0 ];
sol1 = optimize(CONS)

tzero(ss(A,B,C,D))

%%

A = -[1 2 ; -1 2];
B = [1;2];
% C = sdpvar(1,2);
C = [ 1 2 ];
D = 1;

P = sdpvar(2);
iTheta = sdpvar(1);

LMI_1 = [ 
    He{ P*A } ,  P*B , C'   
    B'*P      ,  0   , D'      
    C         ,  D   , -iTheta
    ] <= 0;

CONS = [ LMI_1 , P - eye(2) >= 0 ];
sol2 = optimize(CONS)


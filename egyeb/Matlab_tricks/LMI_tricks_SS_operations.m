%% LMI_tricks_SS_operations
%
%  File: LMI_tricks_SS_operations.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com)
%
%  Created on 2019. January 18.
%

%%

n1 = 5;
m1 = 4;
p1 = 2;

n2 = 7;
m2 = 3;
p2 = m1;

A1 = hurwitz(n1);
B1 = randn(n1,m1);
C1 = randn(p1,n1);
D1 = randn(p1,m1);

A2 = hurwitz(n2);
B2 = randn(n2,m2);
C2 = randn(p2,n2);
D2 = randn(p2,m2);

G1 = minreal(tf(ss(A1,B1,C1,D1)));
G2 = minreal(tf(ss(A2,B2,C2,D2)));

A = [
    A2    zeros(n2,n1);
    B1*C2 A1
    ];

B = [
    B2
    B1*D2
    ];

C = [ D1*C2 C1 ];

D = D1*D2;

Ge = minreal(tf(ss(A,B,C,D)));
Ge_ = minreal(G1*G2);

sys_err = ss(minreal(Ge - Ge_))

figure, impulse(sys_err);
figure, step(sys_err);
figure, nyquist(sys_err);
figure, pzmap(sys_err);

%%

function A = hurwitz(n)
    A = randn(n);
    B = randn(n,1);
    K = place(A,B,-1-n*rand(n,1));
    
    A = A-B*K;
end
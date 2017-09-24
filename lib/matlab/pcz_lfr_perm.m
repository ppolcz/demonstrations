function [A1,B1,C1,D1,Delta1,Theta1,z0,q,submatrices] = ...
    pcz_lfr_perm(A, B, C, D, Delta, x)
%% Script pcz_lfr_perm
%  
%  file:   pcz_lfr_perm.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.09. Sunday, 23:12:56
%
%%

[n,p] = size(B);

F = eye(p) - Delta*D;
G = -Delta*C;

Pi = simplify(-F\G*x);
Pib = [ x ; Pi ];

[Theta,z0,q] = pcz_Pi_canonical_decomp(Pib);

[~,~,submatrices] = pcz_rref(Theta);

sigma = submatrices.sigma;
rho = submatrices.rho;
Isb = submatrices.Isigma;
Ir = submatrices.Irho;
k = submatrices.nk-n;
K = submatrices.K;

assert(all(sigma(1:n) == 1:n), ...
    'The first n elements of sigma must be identity permutation (in theory)');

Is = Isb(n+1:end,n+1:end);

A1 = A;
B1 = B * Is';
C1 = Is * C;
D1 = Is * D * Is';
Delta1 = Is * Delta * Is';
Theta1 = Isb * Theta * Ir';
z01 = Ir * z0;


% simplify([A B] * Theta * z0 / q)
% simplify([A1 B1] * Theta1 * z01 / q)
% 
% simplify([A B] * Theta * z0 / q - [A B]*Pib)
% simplify([A1 B1] * Theta1 * z01 / q - [A B]*Pib)
% 
% simplify(Is'*inv(eye(p) - Delta1*D1)*Delta1*C1*x - Pi)

end
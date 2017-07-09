function [A_rref,A_perm,submatrices,S,iS] = pcz_rref(A)
% 
%  
%  file:   pcz_rref.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.06. Thursday, 20:22:20
%

%%

A_test = [
	   5    9   14   -3   25   -4   22
	  10   18   28   -6   50   -8   44
	  13   24   37   -8   66  -11   40
	  12   13   25   -3   47   -4   20
	  40   64  104  -20  188  -27  126
	  15   14   29   -2   56   -2   24
	  15   17   32   -3   61   -3   34
	   8   18   26   -6   46   -8   28
	  17   25   42   -7   77   -9   52
	  11   13   24   -3   45   -4   12
	];
% A = A_test;

[m,K] = size(A);
nk = rank(A);

[A_rref, Ic] = rref(A);

Jc = setdiff(1:K,Ic);

[~,Ir] = rref(A');
Jr = setdiff(1:m,Ir);

sigma = [Ic Jc];
rho = [Ir Jr];

Irho = pcz_permat(sigma)';
Isigma = pcz_permat(rho)';

A_perm = A(rho,sigma);

T = A(Ir,Ic);
iT = T\eye(nk);
U = A(Ir,Jc);
Tp = A(Jr,Ic);
Up = A(Jr,Jc);
V = [T U];
W = [Tp Up];
Gamma = W*V'/(V*V');

submatrices = struct;
submatrices = pcz_struct_append(submatrices,...
    T,U,Tp,Up,V,W,Gamma,rho,sigma,m,K,nk,Irho,Isigma);

S = [
    iT zeros(nk,m-nk)
    -Gamma eye(m-nk)
    ];

iS = [
    T zeros(nk,m-nk)
    Gamma*T eye(m-nk)
    ];

assert(rank(T) == nk && all(all(A_perm == [T U ; Tp Up])),...
    'A_can should have a form A_can = [T U ; Tp Up], with T invertible');

assert(all(all(Isigma*A*Irho' - A_perm == 0)),...
    'A_can == Isigma*A*Irho''');

end
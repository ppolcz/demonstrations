%% 
%  
%  file:   Mitya_ode.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.17. Saturday, 19:25:15
%

syms x real

S = 1;
R = x;

A = [0 1 ; -S 2*R]

% pretty(expm(A*x))

[S,val] = eig(A)

%%

syms s r real

A = [0 1 ; -s 2*r];

[S,D] = eig(A);

pretty(S)
pretty(D)

simplify(S*D/S)

simplify(S*expm(D*x)/S - expm(A*x))

s = 3; r = -2;

subs(S)
subs(inv(S))

subs(D)


%%

syms A B real

y = (A * exp(-x) + 3*B*exp(-3*x)) / (A * exp(-x) + B*exp(-3*x)) * exp(x^2+4*x) / 3;

NULL = -diff(y,x) + exp(x^2+4*x) + 2*x*y + 3*exp(-x^2-4*x)*y^2
simplify(NULL)

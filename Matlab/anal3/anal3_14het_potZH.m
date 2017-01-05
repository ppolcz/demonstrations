%% 
%  
%  file:   anal3_14het_potZH.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.20. Tuesday, 23:13:47
%
%%

R = 1;

syms r t u v x y z real
xi = [x;y;z];

F = [0 ; 0 ; y*z];

S1 = [
    R*cos(t)
    R*sin(t)
    z];

S2 = [
    r*cos(t)
    r*sin(t)
    0
    ];

S3 = S2; S3(3) = 1;

I1 = subs(F,xi,S1)' * cross(diff(S1,t),diff(S1,z))

I2 = subs(F,xi,S2)' * cross(diff(S2,t),diff(S2,r))

I3 = simplify(subs(F,xi,S3)' * cross(diff(S3,t),diff(S3,r)))
pretty(I3)

int(I3,t,[0,2*pi])

I3_fh = matlabFunction(I3)

integral2(I3_fh, 0, 1, 0, 2*pi)

%% Green tételes feladat

syms t x y real
r = [x;y];

F = [0 ; x];

g = [
    cos(t)^3
    sin(t)^3
    ];

dg = diff(g,t);

Integrand = subs(F,r,g)' * dg;

int(Integrand,t,[0, 2*pi])

%%

syms x real
syms u(x)

F = diff(u,x)^2 - 2*u^2

ode = functionalDerivative(F,u)

dsolve(ode)



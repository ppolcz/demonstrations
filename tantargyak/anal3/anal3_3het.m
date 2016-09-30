%% 
%  
%  file:   anal3_3het.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:57:36
%

grad = @jacobian;
div = @vekanal_div;
rot = @vekanal_rot;

%% anal3 3het gyak, 4. feladat
% Stokes tetel igazolasa egy fuggoleges helyzetu teglalapra, atol x,y szerint

syms R real;
syms x y z u v real;
r = [x;y;z];
R = 1;

s = [
    u
    u
    v
    ];

vekanal_plot_sym_surface(s, u, v, [0,1], [0,1])
% ezsurf(s(1),s(2),s(3),[0,1], [0,1])

dS = simplify(cross(diff(s,u), diff(s,v)));

F = [
    y*z
    x*z
    x*z
    ];

Integrand = subs(rot(F),r,s)' * dS;
symvar(Integrand)

integral2(matlabFunction(Integrand), 0, 1, 0, 1)

%% anal3 3het gyak, 5. feladat
% Stokes tetel igazolasa felul zart hengerpalast eseten

syms R real;
syms x y z u v real;
r = [x;y;z];
R = 2;
h = 3;

s1 = [
    R*cos(u)
    R*sin(u)
    v
    ];
vekanal_plot_sym_surface(s1, u, v, [0,2*pi], [0,h])

F = [
    -y
    x
    x^2
    ];

Integrand = subs(rot(F),r,s1)' * simplify(cross(diff(s1,u), diff(s1,v)));
symvar(Integrand)

integral2(matlabFunction(Integrand, 'vars', {u,v}), 0, 2*pi, 0, h)

%% anal3 3het gyak, 5. feladat
% Green tetel: Cikloid

syms t a real
a = 1;

gamma1 = a * [
    t - sin(t)
    1 - cos(t)
    ];
gamma2 = [
    2*a*pi*(1-t)
    0
    ];
figure, hold on;
vekanal_plot_sym_curve(gamma1, t, [0,2*pi], 'norms', true), axis equal
vekanal_plot_sym_curve(gamma2, t, [0,1], 'norms', true), axis equal

dG = diff(gamma1);
dG_n = [-dG(2) ; dG(1)];

F = 0.5 * [x ; y];

Integrand = simplify(subs(F, [x;y], gamma1)' * dG_n);

I = int(Integrand);

Area = subs(I, t, 2*pi) - subs(I, t, 0)

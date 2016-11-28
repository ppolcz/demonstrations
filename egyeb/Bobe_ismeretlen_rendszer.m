function [ret] = Bobe_ismeretlen_rendszer(xref, vref, aref)
%% 
%  
%  file:   Bobe_ismeretlen_rendszer.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.28. Monday, 12:09:19
%


%%


syms x1 x2 x3 x4 real
syms t u1 u2 v1 v2 real
x = [x1;x2;x3;x4];
u = [u1;u2];
v = [v1;v2];

L = 1;

fu_sym = [
    x4*cos(x3)
    x4*sin(x3)
    x4*u1 / L
    u2
    ];

M_sym = [
    -x4^2/L*sin(x3) cos(x3)
    x4^2/L*cos(x3)  sin(x3)
    ];

fv_sym = simplify(subs(fu_sym, u, M_sym \ v));

f_fh = matlabFunction(fv_sym, 'vars', {t,x,v'});

tu = linspace(0,10,100);
u = [
    sin(tu)
    cos(tu)
    ]';

f_ode = @(t,x) f_fh(t,x,interp1(tu,u,t));

[tt,xx] = ode45(f_ode, [0 10], [0;0;0;0]);

plot(tt,xx)

end
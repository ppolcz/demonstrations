%% 
%  
%  file:   anal3_2het.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:57:31
%

%% 2. het HF1 

syms R u v x y z real
r = [x;y;z];

C = [
    R*cos(v)*cos(u)
    R*cos(v)*sin(u)
    R*sin(v)
    ];

J = jacobian(C,[R;u;v])
simplify(det(J))

C = [
    R*sin(v)*cos(u)
    R*sin(v)*sin(u)
    R*cos(v)
    ];

J = jacobian(C,[R;u;v])
simplify(det(J))

assume([R > 0, in(R, 'real')])
assume([0 <= v < pi, in(v, 'real')])
dS_vec = simplify(-vekanal_cross(diff(C,u), diff(C,v)))
dS = simplify(norm(dS_vec))

fprintf('%s = %s %s \n= %s %s\n', '\mathrm{d}\vec{S}', ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(simplify(dS_vec / R / sin(v))), ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(r))

F = [y;x;z];

Integrand = simplify(subs(F,r,C)' * dS_vec);
pretty(Integrand)

expand(Integrand)

Integrand_u = int(Integrand, u, 0, 2*pi)
Integrand_uv = int(Integrand_u, v, 0, pi/2)

disp 'Tehat a fluxus: '
pretty(Integrand_uv)


%% 2. het HF2

syms R u v x y z real
r = [x;y;z];

C = [
    R*cos(u)
    R*sin(u)
    v
    ];

J = jacobian(C,[R;u;v])
simplify(det(J))

assume([R > 0, in(R, 'real')])
assume([0 <= v < 4, in(v, 'real')])
dS_vec = simplify(vekanal_cross(diff(C,u), diff(C,v)))
dS = simplify(norm(dS_vec))

dS23_vec = simplify(vekanal_cross(diff(C,u), diff(C,R)))
dS23 = simplify(norm(dS23_vec))

fprintf('%s = %s %s \n= %s %s\n', '\mathrm{d}\vec{S}', ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(simplify(dS_vec / R / sin(v))), ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(r))

F = [x^2;y^2;0];

Integrand = simplify(subs(F,r,C)' * dS_vec);
pretty(Integrand)
expand(Integrand)

Integrand_u = int(Integrand, u, 0, 2*pi)
Integrand_uv = int(Integrand_u, v, 0, 4)

disp 'Tehat a fluxus: '
pretty(Integrand_uv)

%% 2. het D3*

syms x y z real
r = [x;y;z];
f = 1 / norm(r);
F = simplify(jacobian(f,r))'
pretty(F)
vekanal_div(F)
simplify(vekanal_div(F))

C = [
    R*sin(v)*cos(u)
    R*sin(v)*sin(u)
    R*cos(v)
    ];

assume([R > 0, in(R, 'real')])
assume([0 <= v < pi, in(v, 'real')])
dS_vec = simplify(-vekanal_cross(diff(C,u), diff(C,v)))
dS = simplify(norm(dS_vec))

fprintf('%s = %s %s \n= %s %s\n', '\mathrm{d}\vec{S}', ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(simplify(dS_vec / R / sin(v))), ...
    pcz_latex(R*sin(v)), ...
    pcz_latex(r))

Integrand = simplify(subs(F,r,C)' * dS_vec);

disp 'Integrand:'
pretty(Integrand)

Integrand_u = int(Integrand, u, 0, 2*pi)
Integrand_uv = int(Integrand_u, v, 0, pi)


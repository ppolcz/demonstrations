%% 
%  
%  file:   num_feluletintegral.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.08. Thursday, 19:29:43
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%%

syms r u v x y z real

C = [
    r*cos(v)*cos(u)
    r*cos(v)*sin(u)
    r*sin(v)
    ];

J = jacobian(C,[r;u;v])
simplify(det(J))

%% 

syms zzzzzz u v x y z real

cross = @(F,G) [
    F(2)*G(3) - F(3)*G(2)
    F(3)*G(1) - F(1)*G(3)
    F(1)*G(2) - F(2)*G(1)
    ];

call = @(fh,args) fh(args{:});

CIKK = 4;
OFFSET_U = pi/3;
Resolution = [16,32] / CIKK;
Subs = @(F,u,v) cellfun(@(a) { reshape(a,size(u)) }, num2cell(call(matlabFunction(F+zzzzzz),{reshape(u,[1,numel(u)]),reshape(v,[1,numel(v)]),zeros([1,numel(v)])}),2));

syms u v x y z real

C = [
    cos(v)*cos(u)
    cos(v)*sin(u)
    sin(v)
    ];

Su = simplify(diff(C,u));
Sv = simplify(diff(C,v));
S = simplify(cross(Su,Sv));

norm_S = simplify(norm(S))
integral2(matlabFunction(norm_S, 'vars', {u,v}), 0, 2*pi, -pi/2, pi/2);

% [uu,vv] = meshgrid(linspace(0,2*pi,Resolution(2)),linspace(-pi/2,pi/2,Resolution(1)));
[uu,vv] = meshgrid(linspace(0,2*pi/CIKK,Resolution(2)),linspace(-pi/2/CIKK + OFFSET_U,pi/2/CIKK + OFFSET_U,Resolution(1)));

C_cell = Subs(C,uu,vv);
S_cell = Subs(S,uu,vv);
Su_cell = Subs(Su,uu,vv);
Sv_cell = Subs(Sv,uu,vv);

[fig,ax] = pcz_latex_axes;
set(fig, 'Units', 'normalized', 'Position', [ 0.347 , 0.439 , 0.459 , 0.461 ])
ax.View = [87 20];
hold(ax,'on')
surf(C_cell{:}, 'facealpha', 0.2), 
quiver3(C_cell{:},Su_cell{:},0.8, 'linewidth',2)
quiver3(C_cell{:},Sv_cell{:},0.8, 'linewidth',2)
quiver3(C_cell{:},S_cell{:}, 'linewidth', 2)
shading interp, axis equal tight

plegend '$C(\theta,\varphi)$' '$\partial_\theta C$' '$\partial_\varphi C$' '$\mathrm{d}\vec{S}$' 

%%

syms R real;
syms x y z u v real;
r = [x;y;z];
R = 1;

% [uu,vv] = meshgrid(linspace(0,2*pi,100), linspace(0,pi));
% surf(R*sin(vv).*cos(uu), R*sin(vv).*sin(uu), R*cos(vv))

s = [
    R*sin(v)*cos(u)
    R*sin(v)*sin(u)
    R*cos(v)
    ];

dS = simplify(cross(diff(s,u), diff(s,v)));

F = [
    x
    2*y
    5*z
    ];

F_s = subs(F,r,s);

Integrand = F_s' * dS;
symvar(Integrand)

integral2(matlabFunction(Integrand), 0, 2*pi, 0, pi)

%% anal3 3het gyak, 4. feladat
% Stokes tetel igazolasa egy fuggoleges helyzetu teglalapra, atol x,y szerint

grad = @jacobian;
div = @(F) diff(F(1),x) + diff(F(2),y) + diff(F(3),z);
rot = @(F) -[
    diff(F(2),z) - diff(F(3),y)
    diff(F(3),x) - diff(F(1),z)
    diff(F(1),y) - diff(F(2),x)
    ];

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

grad = @jacobian;
div = @(F) diff(F(1),x) + diff(F(2),y) + diff(F(3),z);
rot = @(F) -[
    diff(F(2),z) - diff(F(3),y)
    diff(F(3),x) - diff(F(1),z)
    diff(F(1),y) - diff(F(2),x)
    ];

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
% vekanal_plot_sym_surface(s1, u, v, [0,2*pi], [0,h])

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

gamma = a * [
    t - sin(t)
    1 - cos(t)
    ];
figure, hold on;
vekanal_plot_sym_curve(gamma, t, [0,2*pi], 'norms', true), axis equal

dG = diff(gamma);
dG_n = [-dG(2) ; dG(1)];

F = 0.5 * [x ; y];

Integrand = simplify(subs(F, [x;y], gamma)' * dG_n);

I = int(Integrand);

Area = subs(I, t, 2*pi) - subs(I, t, 0)

%% end of the scope
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb
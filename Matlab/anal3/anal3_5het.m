%%
%
%  file:   anal3_5het.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.30. Friday, 12:57:42
%

clear all

%% 2. feladat - Geodesic curves on a sphere
% segedszamitasok

syms t real
syms phi theta dPhi dTheta ddPhi ddTheta real

q = [theta ; phi];
dq = [dTheta ; dPhi];
ddq = [ddTheta ; ddPhi];

Gamma = [
    sin(phi) * cos(theta)
    sin(phi) * sin(theta)
    cos(phi)
    ];

dGamma = jacobian(Gamma, q) * dq;
F = sqrt(simplify(sum(expand(dGamma.^2))));

disp 'F(q,q'') = '
pretty(F)

% F gradiense q szerint
dFq = jacobian(F,q)';
disp 'F''_q = '
pretty(dFq)

% F gradiense q derivalt szerint
dFdq = jacobian(F,dq)';
disp 'F''_q'' = '
pretty(dFdq)

% Ido szerinti derivaltja az F q derivalt szerinti gradiensenek
dt_dFdq = simplify(jacobian(dFdq,[q;dq])*[dq;ddq]);
disp 'd/dt F''_q'' = IRDATLAN CSUNYA'
% pretty(dt_dFdq)

% Euler egyenletek:
Euler = dFq - dt_dFdq;
disp 'Euler egyenletek: MEG CSUNYABBAK'

% Hamiltonian (energiafuggveny)
H = F - simplify(dFdq' * dq)

%% [FOLYT] 2. feladat - Geodesic curves

disp 'Masik megkozelites'

% Atparameterezese a gorbenek:
% phi(t) --> t
% theta(t) --> theta(phi)
F = subs(F, dPhi, 1)

% F gradiense theta szerint
dFq = jacobian(F,theta)';
disp 'F''_theta = '
pretty(dFq)

% F gradiense theta derivalt szerint
dFdq = jacobian(F,dTheta)';
disp 'F''_theta'' = '
pretty(dFdq)

syms C1 real

% assume([...
%     C1^2 <= sin(phi)^2 & ( in(phi/pi, 'integer') | C1^2 == sin(phi)^2 | (sin(phi)^3 - C1^2*sin(phi))^2 ~= C1^2*sin(phi)^2*(C1 + sin(phi))*(C1 - sin(phi)) )
%     ])
% sol = solve(dFdq - C1, dTheta)

simplify(F - dTheta * dFdq)

%% Mit jelent egy parameteres gorbe masodik derivaltja?

syms t real
t_num = linspace(0,40,100);
t_dense = linspace(0,40,1000);

% g = [
%     (20-t)*cos(t)
%     (t/3+10)*sin(t)
%     t + log(t)
%     ];

g = [
    t
    5*sin(t/4)
    0
    ];

dg = diff(g,t);
ddg = diff(dg,t);

figure, hold on, axis equal tight

[v1,v2,v3] = vekanal_subsmeshn(g,t,t_dense);
[g1,g2,g3] = vekanal_subsmeshn(g,t,t_num);
[ddg1,ddg2,ddg3] = vekanal_subsmeshn(ddg,t,t_num);

plot3(v1,v2,v3)
quiver3(g1,g2,g3,ddg1,ddg2,ddg3,0.4,'linewidth', 2)

title '$\gamma(t)$ parameteres gorbe $\ddot{\gamma}(t)$ masodik derivaltjanak jelentese' 'interpreter' 'latex'
h = legend('trajektoria: $\gamma(t)$', 'testre hato aranyos ero: $\ddot{\gamma}(t)$');
set(h, 'interpreter', 'latex');

%% Forgastest felszinen a legrovidebbut

xmin = 1;
xmax = 2;

syms x theta dTheta C D real
assume(C > 0 & in(C,'real'))

f = x;
f_fh = matlabFunction(f);

S = [
    x
    f * cos(theta)
    f * sin(theta)
    ];

Integrand = C*sqrt(1 + diff(f,x)^2) / (f * sqrt(f^2 - C^2));
pretty(Integrand)
pretty(int(Integrand,x))

%%

figure, hold on

C = 0.1;
D = 2 - 4*pi;
xx = linspace(xmin, xmax, 100);
ttheta1 = D + sqrt(2)/C * atan(sqrt(xx - C^2));
plot3(xx, f_fh(xx).*cos(ttheta1), f_fh(xx).*sin(ttheta1))
[xx(1), f_fh(xx(1)).*cos(ttheta1(1)), f_fh(xx(1)).*sin(ttheta1(1))]
[xx(end), f_fh(xx(end)).*cos(ttheta1(end)), f_fh(xx(end)).*sin(ttheta1(end))]

% C = 3.5;
% D = 0.5;
% ttheta2 = D + C * log(xx);
% plot3(xx, f_fh(xx).*cos(ttheta2), f_fh(xx).*sin(ttheta2))
% [xx(1), f_fh(xx(1)).*cos(ttheta2(1)), f_fh(xx(1)).*sin(ttheta2(1))]
% [xx(end), f_fh(xx(end)).*cos(ttheta2(end)), f_fh(xx(end)).*sin(ttheta2(end))]
C = -4.9;
D = 5.4;
ttheta2 = D + C ./ xx;
plot3(xx, f_fh(xx).*cos(ttheta2), f_fh(xx).*sin(ttheta2))
[xx(1), f_fh(xx(1)).*cos(ttheta2(1)), f_fh(xx(1)).*sin(ttheta2(1))]
[xx(end), f_fh(xx(end)).*cos(ttheta2(end)), f_fh(xx(end)).*sin(ttheta2(end))]

[x_mesh,theta_mesh] = meshgrid(linspace(xmin,xmax,30),linspace(0,2*pi,30));
[s1,s2,s3] = vekanal_subsmeshn(S, [x, theta], {x_mesh , theta_mesh});
surf(s1,s2,s3,'facealpha',0.5), shading interp

axis equal
h = legend(...
    '$\theta_1(x) = D_1 + \frac{\sqrt{2}}{C_1} \, \arctan\left(\sqrt{x - C_1^2}\right)$',...
    ...'$\theta_2(x) = D_2 + C_2 \, \mathrm{ln}\,x$',...
    '$\theta_2(x) = D_2 - C_2 \frac{1}{x}$',...
    '$s(x,\theta) = \left(\begin{array}{ccc} x & f(x)\,\cos\!\left(\mathrm{theta}\right) & f(x)\,\sin\!\left(\mathrm{theta}\right) \end{array}\right)$, ahol $f(x) = x/2$');
set(h, 'Interpreter', 'latex');

figure,
plot(xx, ttheta1, xx, ttheta2),
h = legend(...
    '$\theta_1(x) = D_1 + \frac{\sqrt{2}}{C_1} \, \arctan\left(\sqrt{x - C_1^2}\right)$',...
    ...'$\theta_2(x) = D_2 + C_2 \, \mathrm{ln}\,x$'...
    '$\theta_2(x) = D_2 - C_2 \frac{1}{x}$'...
    );
set(h, 'Interpreter', 'latex');

%%

figure, hold on

syms theta phi real

S = [
    sin(phi) * cos(theta)
    sin(phi) * sin(theta)
    cos(phi)
    ];

% C = -2;
% D = 0;
% phi_vec = linspace(pi/6,pi/2,200);
% theta_vec = D - C*cot(phi_vec);
% [v1,v2,v3] = vekanal_subsmeshn(S, [theta phi], {theta_vec, phi_vec});
% plot3(v1,v2,v3)

[theta_mesh, phi_mesh] = meshgrid(linspace(0,2*pi,30), linspace(0,pi,15));
[s1,s2,s3] = vekanal_subsmeshn(S,[theta phi], {theta_mesh, phi_mesh});
surf(s1,s2,s3,'facealpha', 0.5), shading interp
axis equal


% %%

syms t theta phi real

C1 = 1.2;
C2 = 1;
dq = [
    C1 / sin(phi)^2
    sqrt(C1^2/sin(phi)^2 - C2)
    ];

dq_fh = matlabFunction(dq, 'vars', {t, [theta;phi]});

[t_vec, theta_phi_vec] = ode45(dq_fh, [0 1], [0,pi/2]);

[v1,v2,v3] = vekanal_subsmeshn(S, [theta phi], num2cell(theta_phi_vec,1));
plot3(v1,v2,v3)


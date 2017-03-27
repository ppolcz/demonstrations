%% CCS 1. Matlab gyakorlat
%
%  file:   gyak7_matlabgyak1_levezetesek.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.03.27. Monday, 10:35:39
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%% Inverz inga modell (1)

% model parameters
M = 0.5;
m = 0.2;
l = 1;
g = 9.8;

Theta = m * l^2 / 3;

A = [
    0  1  0                    0
    0  0  -3*m*g/(m+4*M)       0
    0  0  0                    1
    0  0  3*(m+M)*g/l/(m+4*M)  0
    ];

B = [
    0
    4/(m+4*M)
    0
    -3/(m+4*M)/l
    ];

C = [
    1 0 0 0
    0 0 1 0
    ];

D = [ 0 ; 0 ];

sys = ss(A,B,C,D);
bode(sys)

%% Inverted pendulum (Lantos model)

syms M m l x(t) phi(t) F g b

eqn1 = (m+M) * diff(x,t,t) + m*l*cos(phi)*diff(phi(t),t,t) - m*l*diff(phi)^2 *sin(phi) == F - b*diff(x,t);
eqn2 = m*l*diff(x,t,t)*cos(phi) + 4/3*m*l^2*diff(phi,t,t) - m*g*l*sin(phi) == 0;

[Y,S] = odeToVectorField(eqn1,eqn2)

% M = 1;
% m = 1;
% g = 10;
% F = 0;
% l = 1;

figure, subplot(121)
f_ode = matlabFunction(subs(Y,[M m g F l b],[1 1 10 0 1 10]),'vars',{'t','Y'});

[t,x] = ode45(f_ode, [0,10], [1 0 0 0]');
plot(t,x)

Y = subs(Y, 'Y[1]', 'phi');
Y = subs(Y, 'Y[2]', 'omega');
Y = subs(Y, 'Y[3]', 'x');
Y = subs(Y, 'Y[4]', 'v');

g_sym = simplify(Y - subs(Y,'F',0));
f_sym = simplify(Y - g_sym);

g_sym = g_sym([3 4 1 2],:);
f_sym = f_sym([3 4 1 2],:);

%% Inverted pendulum (nonlinear szepen leirva)

clear x phi
syms t x v phi omega m M l g b
X = [ x ; v ; phi ; omega ];

q = 4*(M+m) - 3*m*cos(phi)^2;

f_sym = [
    v
    (4*m*l*sin(phi)*omega^2 - 1.5*m*g*sin(2*phi) -4*b*v) / q
    omega
    3*(-m*l*sin(2*phi)*omega^2 / 2 + (M+m)*g*sin(phi) + b*cos(phi)*v) / (l*q)
    ];

g_sym = [
    0
    4*l
    0
    -3*cos(phi)
    ] / (l*q);

f_ode = matlabFunction(subs(f_sym,[M m g F l b],[1 1 10 0 1 10]), 'vars', {t X});

subplot(122)
[t,x] = ode45(f_ode, [0,10], [0 0 1 0]');
plot(t,x)
gyak7_simulate_pendulum_0(t,x)

%% Linearized model around 0

OP = [0 0 0 0]';

J_sym = simplify(jacobian(f_sym, X));
A_sym = subs(J_sym, X, OP);
B_sym = subs(g_sym, X, OP);

A = double(subs(A_sym));
B = double(subs(B_sym));

K = lqr(A,B,eye(4),1);
A_LQR = A - B*K;

[t,x] = ode45(@(t,x) A_LQR*x, [0,10], [0 0 0.5 0]);
gyak7_simulate_pendulum_0(t,x)

%% Linearized model around Pi

OP = [0 0 pi 0]';

J_sym = simplify(jacobian(f_sym, X));
A_sym = subs(J_sym, X, OP);
B_sym = subs(g_sym, X, OP);

A = double(subs(A_sym));
B = double(subs(B_sym));

[t,x] = ode45(@(t,x) A*x, [0,10], [0 0 0.5 0]);
gyak7_simulate_pendulum_Pi(t,x)

%%

sys = ss(A,B,C,D)
sys_tf = tf(sys)

bopts = bodeoptions;
bopts.FreqUnits = 'Hz';
bopts.FreqScale = 'linear';
bopts.MagUnits = 'abs';
bodeplot(sys_tf(2), bopts)

[u,tu] = gensig('sin', 1/0.49, 100);
lsim(sys_tf(2), u, tu)

%% 

u_fh = @(t) interp1(tu,u,t);
[t,x] = ode45(@(t,x) A*x + B*u_fh(t), [0,20], [0 0 0.5 0]);
x(:,3) = x(:,3) + pi;
gyak7_simulate_pendulum(t,x)

%% Plot inverted pendulum

l = 3;

angle = pi/6;

figure('Position', [ 520 374 470 424 ], 'Color', [1 1 1]), hold on
plot([-1 1],[0 0],'LineWidth',20)
plot([0 l*sin(angle)],[0 l*cos(angle)], 'LineWidth', 10)
plot([0 0],[0 l],'--','Color',[1 1 1]*0.6)
quiver(1,0,1,0)
text(1.5,0.25,'F')
text(0,-0.25,'M')
text(0.8,2*l/5,'m,l')
grid on,
axis([-1.5 2 -0.5 l])

fig = gcf;
fig.Children.Visible = 'Off';

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
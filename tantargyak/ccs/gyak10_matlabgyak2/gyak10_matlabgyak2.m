%% Script gyak10_matlabgyak2
%  
%  file:   gyak10_matlabgyak2.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.05.02. Tuesday, 22:39:05
%
%% Nonlinear model - parameters (A)
% No friction

syms t x v phi omega

% model parameters
M = 0.5;
m = 0.2;
l = 1;
g = 9.8;
b = 0;

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

f_ode = matlabFunction(f_sym, 'vars', {t , [ x ; v ; phi ; omega ]});
g_ode = matlabFunction(g_sym, 'vars', {t , [ x ; v ; phi ; omega ]});


%% Linearized model around the unstable equilibrium point

% model parameters
M = 0.5;
m = 0.2;
l = 1;
g = 9.8;
b = 0;

A = [
    0                     1                             0  0
    0      -(4*b)/(4*M + m)            -(3*g*m)/(4*M + m)  0
    0                     0                             0  1
    0   (3*b)/(l*(4*M + m))   (3*g*(M + m))/(l*(4*M + m))  0
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

K = place(A,B,-4:-1);
pcz_num2str(K)

K = lqr(A,B,eye(4),1);
pcz_num2str(K)

L = place(A',C',-4:0.1:-3.7)'
pcz_num2str(L)

%% Transfer function of the closed loop system

Ac = [ A-B*K B*K ; zeros(4,4) A-L*C ];
Bc = [ B ; zeros(4,1) ];
Cc = [ 1 0 0 0 -1 0 0 0 ];
Dc = 0;

cls = ss(Ac,Bc,Cc,Dc);
Ge = minreal(tf(cls))
pzmap(Ge)

Gi = pidtune(Ge,'I')

G_all = minreal(Ge*Gi / (1 + Ge*Gi));

step(G_all)


%% 

t = simx.Time;
x = simx.Data;
u = simu.Data;
gyak8_simulate_pendulum_0(t,x,u)

%% 

t = simx.Time;
x = simx.Data;
gyak8_simulate_pendulum_0(t,x)


%% 

T = 100;
N = 100;
t = linspace(0,T,N);
r = zeros(size(t));
r(30:70) = 1;

simr = [ t' r' ];


%%

t = simout.Time;
x = simout.Data;
gyak8_simulate_pendulum_0(t,x)

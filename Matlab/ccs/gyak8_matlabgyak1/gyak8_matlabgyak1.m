%% Script gyak8_matlabgyak1
%  
%  file:   gyak8_matlabgyak1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.27. Monday, 17:42:37
%
%% Linearized model around the stable equilibrium point

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
    0  -(3*b)/(l*(4*M + m))  -(3*g*(M + m))/(l*(4*M + m))  0
    ];

B = [
    0
    4/(m+4*M)
    0
    3/(m+4*M)/l
    ];

C = [
    1 0 0 0
    0 0 1 0
    ];

D = [ 0 ; 0 ];

%% 1. determine the transfer function of the system

sys = ss(A,B,C,D);
H = tf(sys);

H_r = H(1)
H_omega = H(2)

%% 2. determine the impulse response of the system

T = 5;
[y,t] = impulse(H,T);
gyak8_simulate_pendulum_Pi(t,y)

%% 3. determine the step response and the DC gain of the system

T = 20;

figure('Position', [ 226 318 1276 392 ], 'Color', [1 1 1])

subplot(121)
step(H_r,T)

subplot(122)
step(H_omega,T), hold on
DC_gain = dcgain(H_omega);
plot([0 T],[1 1]*DC_gain)

[y,t] = step(H,T);
gyak8_simulate_pendulum_Pi(t,y)

%% 4. determine the poles of the system
% Is the system stable, exponentially stable or unstable

eig(A)

%% 5. determine the Bode plot of the transfer function
% Plot only for the transfer function from F to omega.
% The frequency unit set to be in Hz.
% Determine the own (or resonance) frequency (f_r) of the system.

figure
bopts = bodeoptions;
bopts.FreqUnits = 'Hz';
% bopts.FreqScale = 'linear';
% bopts.MagUnits = 'abs';
bodeplot(H_omega, bopts), grid on

[gpeak,fpeak] = getPeakGain(H_omega);
fr = fpeak / (2*pi)

%% 6. Nyquist plot

nyquist(H_omega)

%% 7. Simulation using lsim

T = 20;
Ts = 0.01;
t = 0:Ts:T;

f = fr;
u = sin(2*pi*f*t);
y = lsim(H,u,t);
gyak8_simulate_pendulum_Pi(t,y);

f = 0.1;
u = 10*sin(2*pi*f*t);
y = lsim(H,u,t);
gyak8_simulate_pendulum_Pi(t,y);

f = 2;
u = 20*sin(2*pi*f*t);
y = lsim(H,u,t);
gyak8_simulate_pendulum_Pi(t,y);

% After a while we shall notice, that the system's motion is quite
% unusual, why?

%% 8. Simulation using ode45

x0 = [0 0 pi/6 0]';
u = 0;
T = 40;
[t,x] = ode45(@(t,x) A*x + B*u, [0 T], x0);
gyak8_simulate_pendulum_Pi(t,x)

%% 9. Controllability

C4 = [ B A*B A*A*B A*A*A*B ]
C4_ = ctrb(A,B);
rank(C4)

%% 10. Observability

C = [
    1 0 0 0
    0 0 1 0
    ];

O4 = obsv(A,C)
O4_ = ctrb(A',C')'

rank(O4)

% Measure only phi
C = [ 0 0 1 0 ];

O4 = obsv(A,C);
S = [ orth(O4) null(O4) ];
T = inv(S);

A_ = T*A/T
B_ = T*B
C_ = C/T

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

%% 11. Simulation with no input

[tt,xx] = ode45(f_ode, [0,10], [0 0 0.1 0]');
gyak8_simulate_pendulum_0(tt,xx)

[tt,xx] = ode45(f_ode, [0,10], [0 0 0.1 2]');
gyak8_simulate_pendulum_0(tt,xx)

%% 11. Simulation with large amplitude high frequency sinusoidal signal

Ampl = 20;
w0 = 2*pi*2;
u = @(t) Ampl*sin(w0*t);
[tt,xx] = ode45(@(t,x) f_ode(t,x) + g_ode(t,x)*u(t), [0,5], [0 0 pi 0]');
gyak8_simulate_pendulum_0(tt,xx,u)

%% 11. Simulation with small amplitude own frequency sinusoidal signal

Ampl = 1;
w0 = 2*pi*fr;
u = @(t) Ampl*sin(w0*t);
[tt,xx] = ode45(@(t,x) f_ode(t,x) + g_ode(t,x)*u(t), [0,30], [0 0 pi 0]');
gyak8_simulate_pendulum_0(tt,xx,u)

%% Nonlinear model - parameters (B)
% With friction

syms t x v phi omega

% model parameters
M = 0.5;
m = 0.2;
l = 1;
g = 9.8;
b = 10;

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

%% 11. Simulation

[t,x] = ode45(f_ode, [0,10], [0 0 pi/12 2]');
gyak8_simulate_pendulum_0(t,x)



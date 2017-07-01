%% Script gyak8_matlabgyak1_hallgato
%  
%  file:   gyak8_matlabgyak1_hallgato.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.05. Wednesday, 16:02:51
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

%% 1. Determine the transfer function of the system

help ss
help tf

%% 2. Determine the impulse response of the system

help impulse

% [y,t] = ???

% You can use the following function to simulate the behaviour of the
% inverted pendulum:
% gyak8_simulate_pendulum_Pi(t,y)

%% 3. Determine the step response and the DC gain of the system

help step
help dcgain

%% 4. Determine the poles of the system
% Is the linearized model locally/globally/asymptotically stable?
% What can we say about the original nonlinear system's stability?
% How does the stability properties change if we assume friction?

help pzmap

%% 5. Determine the Bode plot of the transfer function
% Plot only the transfer function from $u$ to $\phi$.
% The frequency unit set to be in Hz.
% Determine the own (or resonance) frequency ($f_r$) of the system.

help bodeoptions
help bodeplot

help getPeakGain

%% 6. Plot the Nyquist diagram

help nyquist

%% 7. Plot the output of the system if the input is given
% 
% # $u = \sin(2\pi f_r t)$
% # $u = 20\sin(2\pi 4 t)$
% 
% The time span could be $t \in [0,T]$, where T = 10sec. After a while
% we shall notice, that the system's motion is quite unusual, why?

help lsim

% gyak8_simulate_pendulum_Pi(t,y,u);

%% 8. Simulation using ode45
% Solve the linearized differential equation $\dot{x} = A x + B u$ with
% different initial conditions. The input may be zero first, than you
% can use the values from the previous example.

x0 = [0 0 pi/6 0]';

help ode45

% [t,x] = ode45(???)
% gyak8_simulate_pendulum_Pi(t,x)

%% 9. Controllability
% Is the linearized model controllable


%% 10. Observability
% Is the linearized model observable? How does this change if we
% measure only the angle of the rod $\phi$
% 
% (a) Compute the kernel (null space) of $\mathcal O_4$.
% 
% (b) Give the bases of the image space of $\mathcal O_4$.
% 
% (c) Give the matrix $T$ of the linear state transformation, which
% produces the observability staircase representation.

help null
help orth
help rref

% T = inv([ Im Ker ]);

%% Nonlinear model - parameters (A) - without friction
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
% Solve the nonlinear ODE numerically, use the |ode45| solver.

% (a)
x0 = [ 0 0 5*pi/6 0 ]';
u = 0;

% (b)
x0 = [ 0 0 pi/6 0 ]';
u = 0;

% (c)
x0 = [ 0 0 0 0 ]';
% u = @(t) sin(2*pi*fr*t);

% (d)
x0 = [ 0 0 0 0 ]';
f = 4;
u = @(t) 20*sin(2*pi*f*t);

% (e)
% Whatever you want!

%% Nonlinear model - parameters (B) - with friction
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
% The same ...

%% 12. PID controller design for a simple linear system (not pendulum) 
% 
%            s^2 + 3 s + 2
%  G(s) = ---------------------
%         s^3 + 2 s^2 - 6 s + 8
% 
% (a) Determine the poles and the zeros of the system. Is the system
% minimum-phase?
% 
% (b) Design a PID controller $C(s)$ which provides stability and
% reference tracking.

help pidtune
help pidTuner
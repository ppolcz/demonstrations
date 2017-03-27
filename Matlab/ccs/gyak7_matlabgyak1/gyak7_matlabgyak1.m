%% Script gyak7_matlabgyak1
%  
%  file:   gyak7_matlabgyak1.m
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
b = 10;

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

%% Ex: determine the transfer function of the system

sys = ss(A,B,C,D);
H = tf(sys);

H_pos = H(1);
H_omega = H(2)

step(H_omega)

%% Ex: determine the impulse response of the system

figure,
T = 50;
subplot(121), impulse(H_pos,T)
subplot(122), impulse(H_omega,T)

%% Ex: determine the DC gain of the system

dcgain(H)

%% Ex: determine the poles of the system
% Is the system stable, exponentially stable or unstable

eig(A)

%% Ex: determine the Bode plot of the transfer function
% Plot only for the transfer function from F to omega.
% The frequency unit set to be in Hz.
% Determine the own (or resonance) frequency (f_r) of the system.

bopts = bodeoptions;
bopts.FreqUnits = 'Hz';
bodeplot(H_omega, bopts)

[gpeak,fpeak] = getPeakGain(H_omega);
fr = fpeak / (2*pi);

nyquist(H_omega)

%% Ex: simulate the LINEAR system with a f = f_r frequency signal.




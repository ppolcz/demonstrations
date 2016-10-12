%% 
%  
%  file:   anal3_5het.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:57:42
%

clear all
%% 2. feladat
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
% H = F - simplify(dFdq' * dq)
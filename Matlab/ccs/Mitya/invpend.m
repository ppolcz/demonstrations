%% Script invpend
%  
%  file:   invpend.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.24. Friday, 17:21:56
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

%%

A = rand(4);
B = rand(4,1);
C = rand(2,4);

K = place(A, B, [-1 -1+1j -1-1j -2]);
A = A - B*K;

%% Linearizalt rendszer szimulacioja
% A bemenetet előre legyártom: $t \in [0,T]$.
% Legyen $u(t) = \sin(t)$.
% 

T = 20;
t_num = linspace(0,T,1000);
u_num = sin(t_num);

u = @(t) interp1(t_num, u_num, t);
f = @(t,x) A*x + B*u(t);

% ODE: 
[t_ode, x_ode] = ode45(f,[0,T],[1;0;0;0]);

plot(t_ode,x_ode)



%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
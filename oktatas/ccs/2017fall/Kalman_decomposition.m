%% Kalman decomposition
%  
%  File: Kalman_decomposition.m
%  Directory: demonstrations/oktatas/ccs/2017fall
%  Author: Peter Polcz (ppolcz@gmail.com)  
% 
%  Created on 2018. January 13.
% 
%% 
% Inhereted from: 
% 
%  CCS 2017 fall. Homework 2. Solutions
%  
%  File: d2017_10_26_hf2_mo.m
%  Directory: demonstrations/oktatas/ccs/2017fall
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. October 04.
%  Reviewed on 2017. October 30.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH VERBOSE 
SCOPE_DEPTH = 0;
VERBOSE = 1;

%% Generate a decomposable system

a = 4;        % Nr. of contr. and obs.
b = 2;        % Nr. of contr. and unobs.
c = 1;        % Nr. of uncontr. and obs.
d = 2;        % Nr. of uncontr. and unobs.
n = a+b+c+d;  % Nr. of states
r = 2;        % Nr. of inputs
m = 2;        % Nr. of outputs

A_ = [
    randn(a,a) zeros(a,b) randn(a,c) zeros(a,d)
    randn(b,a) randn(b,b) randn(b,c) randn(b,d)
    zeros(c,a) zeros(c,b) randn(c,c) zeros(c,d)
    zeros(d,a) zeros(d,b) randn(d,c) randn(d,d)
    ];
B_ = [
    randn(a,r)
    randn(b,r)
    zeros(c,r)
    zeros(d,r)
    ];
C_ = [
    randn(m,a) zeros(m,b) randn(m,c) zeros(m,d)
    ];

D = zeros(m,r);

%%% 
% System $(\bar A, \bar B, \bar C, D)$ is in Kalman decomposed form. The
% transfer function is reducible to a $a$rd order system.
sys = ss(A_,B_,C_,D)

%% 
% Transfer function
H = minreal(tf(sys))

%% 
% Transform the system with a random orthogonal transformation matrix $T$.
T = orth(rand(n));
A = T * A_ * T';
B = T * B_;
C = C_ * T';

sys = ss(A,B,C,D)

%% Kalman decomposition. Solution
%% 1. Controllability staircase form
% Controllability matrix
Cn = ctrb(A,B);

%%
% Transformation matrix, which generates the controllability staircase
% form.
[S1,~,~] = svd(Cn)

%%
% The transformation.
A1 = S1' * A * S1
B1 = S1' * B
C1 = C * S1

%%
% Order of the controllable subsystem
ab = rank(Cn);

%% 2. Observability staircase form
% 2.1. Observability staircase form of the controllable subsystem
On1 = obsv(A1(1:ab,1:ab), C1(:,1:ab));
[~,~,S21] = svd(On1);

%%
% 2.2. Observability staircase form of the uncontrollable subsystem
On2 = obsv(A1(ab+1:end,ab+1:end), C1(:,ab+1:end));
[~,~,S22] = svd(On2);

%%
% Second transformation matrix to generate the observability staircase form
% for both controllable and uncontrollable subsystems.
S2 = blkdiag(S21, S22)

%% 
% Transformation
A2 = round(S2' * A1 * S2,10)
B2 = round(S2' * B1,10)
C2 = round(C1 * S2,10)

%% Kalman decomposition using |minreal|
% Using |minreal| the transfer function which generates the Kalman
% decomposition can be retained easily, however, this does not work all the
% times. The uncontrollable subsystem is not always decomposed (since the
% uncontrollable subsystem is already redundant).
[H,U] = minreal(sys);

A1 = round(U*A/U,10)
B1 = round(U*B,10)
C1 = round(C/U,10)

%% Subspaces
%% Controllable subspace

dim_X_C = rank(Cn);

X_C = S1(:,1:dim_X_C)

%%%
% Alternatively
% 
%  X_C = orth(Cn);

%%
% Check if $Im(B) \subset X_c$. 
%
% *Background.* Let $V$ and $W$ be two subspaces of $\mathbb{R}^n$, dim$(V)
% = k$, dim$(W) = m$. $V \subset W$ if there exists a matrix
% 
% $$ 
% A = \begin{pmatrix} 
%     a_{11} & ... & a_{1k} \\ ... & ... & ... \\ a_{m1} & ... & a_{mk}
% \end{pmatrix}
% $$
% 
% such that $V = W A$. If there exists such matrix, it can be computed as
% follows: $A = \left(W^T W\right)^{-1} W^T V$. If the equility $V = W A$
% holds for this matrix $A$, than $V \subset W$. So, we need that $W
% \left(W^T W\right)^{-1} W^T V - V$ be approximately the zero matrix.
%
% For this purpose, we define the following function (in a separate file,
% called |pcz_vecalg_subset.m|)
% 
%   function [ret] = pcz_vecalg_subset(V, W, tol)
%   ret = rank(W / (W'*W) * W' * V - V, tol) == 0;
% 
% Using this function we can check whether $Im(B) \subset X_c$.
pcz_info(pcz_vecalg_subset(orth(B),X_C,1e-10), 'Im(B) ⊂ X_C')

%% 
% Check if $A X_c \subseteq X_c$.
pcz_info(pcz_vecalg_subset(A*X_C,X_C,1e-10), 'A X_C ⊆ X_C')

disp '$a$'
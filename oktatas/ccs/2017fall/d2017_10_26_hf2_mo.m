%% CCS 2017 fall. Homework 2. Solutions
%  
%  file:   ccs2017_hf2_mo.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. October 04.
%  Reviewed on 2017. October 30.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_wgiSzglEBgsToKZiSoXF = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Acetone - human body

A = [
    -6 0 0
    4 0 0
    2 0 0
    ];
B = [ 1 ; 0 ; 0 ];
C = [ 0 0 1 ];

On = obsv(A,C)
Cn = ctrb(A,B)

rank(On)
rank(Cn)

orth(sym(Cn))
null(sym(On))

Hs = minreal(tf(ss(A,B,C,0)))

syms s t
clear H
H(s) = simplify(C/(s*eye(3) - A)*B)

h(t) = ilaplace(H)

disp 'NEM BIBO STABIL'

%% Kalman decomposition
%% Generate a decomposable system

a = 3;
b = 2;
c = 1;
d = 2;
n = a+b+c+d;
r = 1;
m = 1;

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
% transfer function is reducible to a 3rd order system.
sys = ss(A_,B_,C_,D);
H = minreal(tf(sys))

%% 
% Transform the system with a random transformation matrix $T$.
T = orth(rand(n));
A = T * A_ * T';
B = T * B_;
C = C_ * T';

sys = ss(A,B,C,D);

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

%%
% End of the script.
pcz_dispFunctionEnd(TMP_wgiSzglEBgsToKZiSoXF);
clear TMP_wgiSzglEBgsToKZiSoXF
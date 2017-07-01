%% Első zárthelyi dolgozat megoldásai
%
%  file:   gyak6_ZH1_megoldasai.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.03.20. Monday, 17:59:20
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_LqIHBLAzzWugmJRYlNEu = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%%

T = [ 1 2 0 ; -1 0 1 ; 0 -1 0 ];

A_ = diag([-1 -2 -3]);
A = T\A_*T;

B = [ 1 ; 1 ; 1 ];
C = [ 0 0 2 ];

clc

%% 1. feladat
% Give the matrices of the transformed model $(\bar A, \bar B, \bar C)$
A_ = T*A/T
B_ = T*B
C_ = C/T

%% 2. feladat
% Give the eigenvalues and the corresponding eigenvectors of matrix
% $A$.
eigvals = diag(A_)'
eigvecs = inv(T)

%% 3. feladat
% Is the system globally asymptotically stable? Why or why not?
% YES

%% 4. feladat
% Is this state-space model $(A,B,C)$ minimal?

Cn = ctrb(A,B)
On = obsv(A,C)

rank_Cn = rank(Cn)
rank_On = rank(On)

%% 5. feladat
% Give the controllable subspace of $(A,B,C)$.
Csub_orthogonal = orth(Cn);

[~,jb] = rref(Cn);
Csub_linearly_indep_cols = Cn(:,jb)


%% 6. feladat
% Determine the transfer function $H(s)$ of the system.
sys = minreal(tf(ss(A,B,C,0)))

%% 7. feladat
% Compute the impulse response of the system
[b,a] = tfdata(sys,'v');

syms s t
H(s) = poly2sym(b,s) / poly2sym(a,s);
h(t) = ilaplace(H(s))

%% 8. feladat
% Determine a jointly controllable and observable state space representation for this system.
Ac = [-a(2:end) ; 1 0 ];
Bc = [1 ; 0];
Cc = b;

%% 9. feladat
% Calculate the output $y(t)$ of the system if the initial
% condition is given in the transformed coordinates system $\bar x(0)
% = \pmatrix{ 1 \cr 2 \cr 3 }$ and the input is the
% Dirac-delta: $u(t) = \delta(t)$.
x0 = [1;2;3];
y(t) = C_*expm(A_*t) * x0 + h(t)

%% 10. feladat
% Give the DC gain of the system.
DC_gain_computed_by_dcgain = dcgain(sys);
DC_gain_computed_symbolically = H(0)

%% 11. feladat
% Does there exist an input $u(t)$, $t \in [0,t_1]$, which can lead
% the system from the origin $(x_0 = 0)$ to
%
% # $x(t_1) = \pmatrix{1 \cr 1 \cr 1 }$ [YES]
% # $x(t_1) = \pmatrix{ 1 \cr 1 \cr 2 }$ [NO]

x1_this_can_be_expressed = rank([ Csub_orthogonal [1;1;1] ])
x2_this_cannot_be_expressed = rank([ Csub_orthogonal [1;1;2] ])

%%

syms s real
s*eye(3) - A
simplify(adjoint(s*eye(3) - A))

%%
% End of the script.
pcz_dispFunctionEnd(TMP_LqIHBLAzzWugmJRYlNEu);
clear TMP_LqIHBLAzzWugmJRYlNEu
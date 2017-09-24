%% Standard 1-D order reduction. Demonstration.
% Moore 1981, _Principal Component Analysis in Linear Systems: Controllability, 
% Observability, and Model Reduction_
% 
% |file:   standard_1d_order_reduction.m|
% 
% |author: Peter Polcz <ppolcz@gmail.com> |
% 
% |Created on 2017. September 02.|
% 
% |Reviewed on 2017. September 24.|
%%
% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;
%% Generate a good transformation matrix
%%
detT = 0;

while ~(0 < detT && detT <= 2)
    T = randn(4);
    detT = det(T);
end
T, detT
%% Generate a good state-space model
%%
A = [
    1 0 1 0
    1 1 1 1
    0 0 1 0
    0 0 1 1
    ] .* randn(4);

B = [
    1
    1
    0
    0
    ] .* randn(4,1);

C = [ 1 0 1 0 ] .* randn(1,4);

A = T*A/T;
B = T*B;
C = C/T;
D = 0;

rtol = 1e-10;

pcz_display(A,B,C)
%% Controllability, observability matrix 

Cn = ctrb(A,B), rank(Cn,rtol)
On = obsv(A,C), rank(On,rtol)
%% Controllable subspace $X_{c \cdot} = X_{co} \otimes X_{c \bar o} = \mathrm{Im} \left\{\mathcal{C}_n \right\}$
%%
[U,Sigma,~] = svd(Cn);
XC_ = U(:,1:rank(Sigma,rtol))
% Alternatively: 
% Xcx = orth(Cn)
%% Unobservable subspace: $X_{\cdot \bar o} = X_{c \bar o} \otimes X_{\bar c o}  = \mathrm{Ker} \left\{\mathcal O_n\right\}$
%%
[~,Sigma,V] = svd(On);
X_o = V(:,rank(Sigma,rtol)+1:end)
% Alternatively:
% Xx_2 = null(On)
%% Controllable and unobservable sybsystem: $X_{c \bar o} = X_{c \cdot} \cap X_{\cdot \bar o}$
%%
XCo = intersection_of_subspaces(XC_',X_o')';
XCo_ORTH = null(XCo');
%% Controllable and observable subsystem: $X_{co} = (X_{c \cdot} \cap X_{\cdot \bar o})^\perp \cap X_{c \cdot} = X_{c \bar o}^\perp \cap X_{c \cdot}$

XCO = intersection_of_subspaces(XCo_ORTH', XC_')'
%% Orthogonal basis of $X_{co}$

U = orth(XCO);
%% Transfer function of the original state-space model
%%
H = tf(ss(A,B,C,D));
H_min = minreal(H)
%% Transfer function of the reduced state-space model
% We do not need to use |minreal|.
%%
A_ = U'*A*U;
B_ = U'*B;
C_ = C*U;
D_ = D;

tf(ss(A_,B_,C_,D_))
%% Kalman decomposition
% The transformation matrix is returned by function |minreal|.
%%
sys = ss(A,B,C,D);
[sysmin,S] = minreal(sys);
Kalman_decomp_A = S*A/S
%% 2017b CCS gyak4. Subspaces
%% Cascade tank system
%% System model
% Generate symbolic system parameters $k_1 ,k_2 ,k_3 ,k_4 >0$ (flow rate of 
% the corresponding tank).
%%
pcz_generateSymStateVector(4,'k');
pcz_generateSymStateVector(4,'x');
assumeAlso(k>0)
%% 
% State space matrices

A = [
    -k1 0 0 0
    k1 -k2 0 0 
    0 k2 -k3 0
    0 0 k3 -k4
    ];
B = [ 0 1 0 0 ]';
C = [ 0 0 1 0 ];
%% 
% Observability and controllability matrices

C4 = [ B A*B A^2*B A^3*B ], rank(C4)
O4 = [ C ; C*A ; C*A^2 ; C*A^3 ], rank(O4)
%% Subspaces
% Controllable subspace
%%
XC_ = orth(C4)
%% 
% State variables $\left(x_2 ,x_3 ,x_4 \right)$ are controllable
% 
% Uncontrollable subspace
%%
Xc_ = null(XC_')
%% 
% State variable $x_1$ is not controllable
% 
% Unobservable subspace
%%
X_o = null(O4)
%% 
% State variable $x_4$ is not observable
% 
% Observable subspace
%%
X_O = null(X_o')
%% 
% State variables $\left(x_1 ,x_2 ,x_3 \right)$ are observable
%% Controllable staircase form
%%
S = [XC_ Xc_]
x_ = S'*x
A_ = S' * A * S, B_ = S' * B, C_ = C * S
%% Kalman decomposition (todo)
%% System model
%%
A = [
   1.613378610435994  -3.995855597631523  -0.810450484741737  -0.168720889102838
   0.734243523886419  -1.441227814368974  -0.230398914393346  -0.184908002657739
  -0.645586131749136  -2.271869456330054  -1.257298097726161   0.738442163303650
   1.337529417392070  -5.440050610034118  -1.733590645293144  -0.143058326670208
   ];

B = [
    1.420709123535001
    0.656198450951251
   -0.385009953764639
    1.668593611633082
    ];
%% Observability and controllability matrices

C = [ 0.715755046956996  -3.906572661173081  -0.886008486028291   0.751557463505590 ]; 
rtol = 1e-10;
Cn = ctrb(A,B), rank(Cn,rtol)
On = obsv(A,C), rank(On,rtol)
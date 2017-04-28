%% Script gyak9_pole_placement_LQR
%  
%  file:   gyak9_pole_placement_LQR.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.27. Thursday, 12:05:49
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_zxHKNoJIigzXrElNnAKU = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Pole placement SISO, using the method based on Bass-Gura formula

% State space matrices
A = [
    2 -2
    0 1
    ];
B = [ 1 ; 2 ];
C = [ 1 1 ];

% Numerator and denominator of the transfer function of the system
[b,a] = ss2tf(A,B,C,0);

% Controllability matrix
Cn = [ B A*B ];

% Auxiliary matrix $T_l$
Tl = toeplitz([1 0],a(1:end-1));

% Desired poles and characteristic polynomial of the closed-loop system
alpha = poly([-1 -2]);

% Computed feedback gain
K = (alpha(2:end) - a(2:end)) / Tl / Cn

% Eigen values of the closed-loop system 
eig(A - B*K)

%% Pole placement MIMO, using |place| command

n = 5; % dim(x)
r = 2; % dim(u)
m = 3; % dim(y)

T = rand(n);
B = rand(n,r);
C = rand(m,n);
D = zeros(m,r);

% Desired poles of the closed-loop system
p = -n:-1

% Feedback gain
K = place(A,B,p)

% Actual poles of the closed-loop system
eig(A - B*K)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_zxHKNoJIigzXrElNnAKU);
clear TMP_zxHKNoJIigzXrElNnAKU
%% Script analyse_properties_of_svd
%  
%  file:   analyse_properties_of_svd.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.09. Friday, 22:43:13
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_kzOUaGOyFoGAkcaGKdUB = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

N = 10;
M = 5;
d = 3;

s = rand(d,N);
A = rand(M,d);

X = A*s;

[U,Sigma,Vh] = svd(X);

Us = U(:,1:d);
U0 = U(:,d+1:M);

Vsh = Vh(:,1:d);
V0h = Vh(:,d+1:N);

Sigmas = Sigma(1:d,1:d);
Sigma0 = Sigma(d+1:M,d+1:N);

pcz_info(norm(X - Us * Sigmas * Vsh') < 1e-10,'X == Us * Sigmas * Vsh''')
pcz_info(norm(U0' * X) < 1e-10,'U0'' spans the null space of X')

%%

A = [
    1 2 3 4 5 6 7 8
    3 4 5 6 7 8 2 1
    ];

[U,Sigma,Vh] = svd(A)


%% Pseudo inverse of rank deficient matrix using SVD

d = 9;
M = 100;
N = 10;

A = rand(M,d) * rand(d,N); % rank(A) == d

[U,Sigma,Vh] = svd(A);

Sigma_pinv = [ blkdiag(diag(1./diag(Sigma(1:d,1:d))), zeros(N-d,N-d)) zeros(N,M-N) ];
Sigma_pinv * Sigma;

A_pinv = Vh*Sigma_pinv*U';
I_approx = A_pinv * A
% Vh*Sigma_pinv*U' * U*Sigma*Vh'

%% System of linear equations
% Overdetermined systems

m = 5;
d = 3;

A = rand(m,d);
s = rand(d,1);
x = A*s;

s_hat = (A'*A) \ A' * x; 

A*s_hat - x

%% Trace things

A = [
    0 0 0 1
    0 0 1 0
    0 1 0 0
    1 0 0 0
    ];

[S,D] = eig(A)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_kzOUaGOyFoGAkcaGKdUB);
clear TMP_kzOUaGOyFoGAkcaGKdUB
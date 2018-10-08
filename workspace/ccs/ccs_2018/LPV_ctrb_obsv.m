%% Renerate matrices

tol = 1e-10;

a = 2;        % Nr. of contr. and obs.
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
    randn(a+b,round(r/2)) * randn(round(r/2),r)
    % randn(a,r)
    % randn(b,r)
    zeros(c,r)
    zeros(d,r)
    ];
C_ = [
    randn(m,a) zeros(m,b) randn(m,c) zeros(m,d)
    ];

D0 = zeros(m,r);

%%%
% System $(\bar A, \bar B, \bar C, D)$ is in Kalman decomposed form. The
% transfer function is reducible exactly to an $a$th order system.

fprintf '\nSize of (A_,B_,C_,D0): \n'
sys = ss(A_,B_,C_,D0);
size(minreal(sys,tol,false))

%%
% Transform the system with a random transformation matrix $T$.

%%%
% Random permutation matrix

T = pcz_permat(randperm(n));

%%%
% Random "nice" transformation matrix

while 1
    T = round(randn(n)) .* (rand(n) > 0.8);
    if abs(det(T)) < 0.9 || abs(det(T)) > 20 || sum(sum(T ~= 0)) > 2*n
        continue
    end

    Ti = inv(T);
    if sum(sum(Ti ~= 0)) > 2*n
        continue
    end

    break
end

% pcz_display(T)

%%

A0 = T \ A_ * T;
B0 = T \ B_;
C0 = C_ * T;

fprintf '\nSize of (A0,B0,C0,D0): \n'
sys = minreal(ss(A0,B0,C0,D0),tol,false);
size(sys)

%%
% Now, generate $A(\rho) = A_0 + A_1 \rho$ with a sparse matrix $A_1$. The
% same with $B$.

A1 = randn(n).*(rand(n) > 0.95);
B1 = randn(n,r).*(rand(n,m) > 0.94);
C1 = zeros(m,n);
D1 = zeros(m,r);

pcz_display(A1,B1);

%%
% Check joint controllability and observability for a few values of $\rho$.
A_fh = @(rho) A0 + A1*rho;
B_fh = @(rho) B0 + B1*rho;
C_fh = @(rho) C0 + C1*rho;
D_fh = @(rho) D0 + D1*rho;

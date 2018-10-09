%%
%  File: LPV_ctrb_obsv.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
% 
%  Created on 2018. October 09.

%% [Step1] Instabil, nem min. fazisu MIMO LTI

a = 4;        % Nr. of contr. and obs.
b = 2;        % Nr. of contr. and unobs.
c = 1;        % Nr. of uncontr. and obs.
d = 2;        % Nr. of uncontr. and unobs.
n = a+b+c+d;  % Nr. of states
m = 2;        % Nr. of inputs and outputs

while true

    A = round([
        randn(a,a) zeros(a,b) randn(a,c) zeros(a,d)
        randn(b,a) randn(b,b) randn(b,c) randn(b,d)
        zeros(c,a) zeros(c,b) hurwitz(c) zeros(c,d)
        zeros(d,a) zeros(d,b) randn(d,c) hurwitz(d)
        ],8);
    B = round([
        randn(a,m)
        randn(b,m)
        zeros(c,m)
        zeros(d,m)
        ],8);
    C = round([
        randn(m,a) zeros(m,b) randn(m,c) zeros(m,d)
        ],8);

    D = zeros(m,m);

    T = randn(n,n);
    T = orth(T);
    
    A = T*A*T';
    B = T*B;
    C = C*T';
    
    %%%
    % System $(\bar A, \bar B, \bar C, D)$ is in Kalman decomposed form. The
    % transfer function is reducible to a $a$rd order system.
    sys = ss(A,B,C,D);


    System_zeros = sort(tzero(sys));
    % [~,ZEROS] = pzmap(sys)

    sys = minreal(sys,[],false);

    Transmission_zeros = sort(tzero(sys));
    % [~,ZEROS] = pzmap(H)


    [~,eigvals] = eig(A);
    if false ...
            || any(real(diag(eigvals)) ~= diag(eigvals)) ...
            || all(real(diag(eigvals)) < 0) ...
            
        continue
    end
    if all(real(diag(eigvals)) < 0)
        continue
    end

    % Detektálhatóság ellenőrzése (kvadratikus értelemben)

    P = sdpvar(n);
    N = sdpvar(n,m,'full');

    Big_M = P*A + A'*P - N*C - C'*N';

    I = eye(n);

    Constraints = [
        P - I >= 0
        Big_M + I <= 0
        ];

    sdpopts = sdpsettings('verbose', false);
    sol = optimize(Constraints,[],sdpopts);
    % check(Constraints)

    Big_M = value(Big_M);
    N = value(N);
    P = value(P);
    L = P\N;

    % eig(A - L*C)

    if sol.problem == 0
        break
    end

end

pcz_display(A,B,C,D)




%%

function A = hurwitz(c)
    A = randn(c,c);
    B = randn(c,1);
    eigs = -rand(c,1)-0.1;
    K = place(A,B,eigs);
    A = A - B*K;
end


function [A,B,C,D,System_zeros,Transmission_zeros] = LTI_generate_sys(a, b, c, d, m, p, is_stabilisable)
%% LTI_generate_sys
%  
%  File: LTI_generate_sys.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 06.
%

%%

n = a+b+c+d;  % Nr. of states

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
        randn(p,a) zeros(p,b) randn(p,c) zeros(p,d)
        ],8);

    D = zeros(p,m);

    if ~is_stabilisable
        A(end-d+1:end,end-d+1:end) = -hurwitz(d);
    end
    
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

    sys_min = minreal(sys,[],false);

    Transmission_zeros = sort(tzero(sys_min));
    % [~,ZEROS] = pzmap(H)


    % disp 'LTI Generated'
    
    if ~is_stabilisable
        break;
    end
    
    [~,eigvals] = eig(A);
    if false ...
            || any(real(diag(eigvals)) ~= diag(eigvals)) ...
            || all(real(diag(eigvals)) < 0) ...
            
        continue
    end
    if all(real(diag(eigvals)) < 0)
        continue
    end
    
    % disp 'Eigenvalues OK'

    % Detektálhatóság ellenőrzése (kvadratikus értelemben)

    P = sdpvar(n);
    N = sdpvar(n,p,'full');

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
        % disp 'Detectable OK'
        break
    end

end

end

function A = hurwitz(c)
    A = randn(c,c);
    B = randn(c,1);
    eigs = -rand(c,1)-0.1;
    K = place(A,B,eigs);
    A = A - B*K;
end

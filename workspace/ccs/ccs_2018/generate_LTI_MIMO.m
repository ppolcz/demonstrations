function [A,B,C,D] = generate_LTI_MIMO(a, b, c, d, m, p, is_stabilisable)
%% 
%  
%  File: generate_LTI_MIMO.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 06.
%

%%

n = a+b+c+d;  % Nr. of states

A = round([
   -hurwitz(a) zeros(a,b) randn(a,c) zeros(a,d)
    randn(b,a) hurwitz(b) randn(b,c) randn(b,d)
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

end

function A = hurwitz(c)
    A = randn(c,c);
    B = randn(c,1);
    eigs = -rand(c,1)-0.1;
    K = place(A,B,eigs);
    A = A - B*K;
end
%% LTI controllability observability
% <html><p class="lead">Check controllability and observability of an LTI
% system using LMI conditions</p></html>
%  
%  File: LTI_ctrb_obsv.m
%  Directory: 2_demonstrations/workspace/ccs/ccs_2018
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 06.
%

%% Generate an unstable non-minimum phase MIMO LTI system

a = 4;        % Nr. of contr. and obs.
b = 2;        % Nr. of contr. and unobs.
c = 1;        % Nr. of uncontr. and obs.
d = 2;        % Nr. of uncontr. and unobs.
n = a+b+c+d;  % Nr. of states
m = 2;        % Nr. of inputs
p = 3;        % Nr. of outputs
is_stabilisable = 1;

[A,B,C,D] = generate_LTI_MIMO(a,b,c,d,m,p,is_stabilisable);

pcz_display(A,B,C,D)

%% Compute the uncontrollable eigenvalues
%
% Check wether the system is stabilisable.


%%%
% Check wether the system is detectable.


%% Compute a stabilising static state feedback gain with LMI

CONS = [
    ...
    ];

sdpopts = sdpsettings('solver', 'sedumi');
sol = optimize(CONS,[],sdpopts)

K = zeros(m,n);

%%%
% Check solution

Eigenvalues_of_the_closed_loop = eig(A - B*K)

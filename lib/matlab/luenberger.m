function [A,B,C,T,mu,sigma] = luenberger(A,B,C,varargin)
%% 
%  
%  file:   luenberger.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.13. Friday, 17:37:49
% 
% Examples:
%  [A,B,C,T,mu,sigma] = luenberger(A,B,C)
%  [A,B,C,T,mu,sigma] = luenberger(sys), sys should be an ss system
% 

if ~isnumeric(A)

    if isa(A,'ss')
        sys = A;
        A = sys.a;
        B = sys.b;
        C = sys.c;
    else
        error('first argument should be numeric or a state-space model')
    end

end

[n,r] = size(B);

Mc = ctrb(A,B);

[~,jb] = rref(Mc');

mu = sum(mod(repmat(jb,[r,1]),r) == repmat([1:r-1,0],n,1)',2);
sigma = cumsum(mu);

I = cellfun(@(a,b) {[1:a]*r+b-r},num2cell(mu),num2cell(1:r)');
indices = [ I{:} ];

P = Mc(:,indices);
Pinv = P \ eye(n);

q = Pinv(sigma,:);

Tmp = ctrb(A',q')';

T = Tmp(indices,:);

A = T*A/T;
B = T*B;
C = C/T;

end
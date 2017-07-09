function [Theta,z0,q] = pcz_Pi_canonical_decomp(z,w)
%% Script pcz_Pi_canonical_decomp
%  
%  file:   pcz_Pi_canonical_decomp.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.09. Sunday, 23:14:53
%
%%

if nargin == 1
    w = symvar(z);
end

m = numel(z);
r = sym('NONAMETMPVAR',[1 m]);

[zp,q] = numden(simplify(r*z));
[c,t] = coeffs(expand(zp),w);
[A,~] = equationsToMatrix(c,r);

Theta = double(A');
z0 = t';

end
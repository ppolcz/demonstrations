function [ret] = pcz_symzero(z, prec, N)
%% Script pcz_symzero
%  
%  file:   pcz_symzero.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.31. Monday, 23:54:28
%
%%

if nargin < 3
    N = 10;
end

if nargin < 2
    prec = 10;
end

if pcz_symzero1(z,prec,N)
    ret = true;
    return
end

s = symvar(sym(z));

try
    [Theta,z0,q] = P_Pi_canonical_decomp(z(:), s);
    ret = pcz_symzero(Theta, prec, N);
catch
    ret = false;
end

end
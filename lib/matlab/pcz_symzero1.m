function [ret] = pcz_symzero1(z, prec, N)
%% Script pcz_symzero1
%  
%  file:   pcz_symzero1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.31. Monday, 23:53:35
%
%%

if nargin < 3
    N = 10;
end

if nargin < 2
    prec = 10;
end

s = symvar(sym(z));

if isempty(s)
    ZERO = double(z);
    ret = all(abs(ZERO(:)) < 10^(-prec));
else
    for i = 1:N
        ZERO = double(subs(z, s, prec*randn(size(s))));
        if any(abs(ZERO(:)) > 10^(-prec))
            ret = false;
            return
        end
    end
    ret = true;
end 

end
function [ret] = pcz_symeq(a,b,prec,N)
%% Script pcz_symeq
%  
%  file:   pcz_symeq.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.20. Thursday, 09:46:28
%
%%

if nargin < 4
    N = 10;
end

if nargin < 3
    prec = 10;
end

ZERO_sym = a - b;

s = symvar(ZERO_sym);

if isempty(s)
    ZERO = double(ZERO_sym);
    ret = all(ZERO(:) == 0);
else
    for i = 1:N
        ZERO = double(subs(ZERO_sym, s, prec*randn(size(s))));
        if any(abs(ZERO(:)) > 10^(-prec))
            ret = 0;
            return
        end
    end
    ret = 1;
end 


end
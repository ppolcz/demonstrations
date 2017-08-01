function [indices,maxdiff,perc] = pcz_symzero_perc(z, prec, N)
%% Script pcz_symzero_perc
%  
%  file:   pcz_symzero_perc.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 01:21:16
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
    indices = find(abs(ZERO(:)) < 10^(-prec));
    perc = numel(indices) / numel(ZERO);
    maxdiff = max(abs(ZERO(:)));
else
    z_fh = matlabFunction(z(:), 'vars', {s(:)});
    ZERO = zeros(numel(z),N);    
    for i=1:N
        ZERO(:,i) = z_fh(rand(numel(s),1));
    end
    
    greater = sum(abs(ZERO) > 10^(-prec),2);
    indices = find(greater);
    perc = numel(indices) / numel(z);
    maxdiff = max(abs(ZERO(:)));
end

end
function [r_indices,r_maxdiff,r_perc] = pcz_symzero_report(z, prec, N, varargin)
%% Script pcz_symzero_perc
%  
%  file:   pcz_symzero_perc.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 01:21:16
%
%%

if nargin < 3 || isempty(N) || ischar(N)
    if nargin >= 3 && ischar(N)
        varargin = [N varargin];
    end
    N = 10;
end

if nargin < 2 || isempty(prec) || ischar(prec)
    if nargin >= 2 && ischar(prec)
        varargin = [prec varargin];
    end
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

if nargout > 2
    r_perc = perc;
end

if nargout > 1
    r_maxdiff = maxdiff;
end

if nargout > 0
    r_indices = indices;
end

if nargout == 0
    bool = perc == 0 && maxdiff < 10^(-perc);
    
    fprintf('\nEquality report ')
    pcz_OK_FAILED(bool, varargin{:})
    fprintf('\n---------------\n')
    fprintf('Equality percentage: %g%%\n', (1-perc)*100)
    fprintf('Maximal difference: %g\n', maxdiff)
    
    if ~isempty(indices)
        fprintf('Indices, where not equal: \n');
        disp(indices(:)');
    end
end
    
end
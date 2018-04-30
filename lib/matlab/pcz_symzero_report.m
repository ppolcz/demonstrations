function [r_indices,r_maxdiff,r_perc] = pcz_symzero_report(z, prec, N, varargin)
%% Script pcz_symzero_perc
%  
%  file:   pcz_symzero_perc.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 01:21:16
%
%%

% TMP_ZNEWEagSzRkCGbFsczkg = pcz_dispFunctionName;

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
    indices = find(abs(ZERO(:)) > 10^(-prec));
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

S = dbstack;
% S.name

first = 1;
for i = 1:numel(S)-1
    if strcmp(S(2).name, 'pcz_symzero_report')
        first = i;
        break;
    end
end

if strcmp(S(first+1).name, 'pcz_symeq_report')
    first = first+1;
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
    bool = perc == 0 && maxdiff < 10^(-prec);
    
    if bool
        if ~isempty(varargin)
            varargin{1} = [ varargin{1} ' Maximal difference: %g' ];
        else
            varargin{1} = 'Maximal difference: %g';
        end
        
        varargin = [ varargin maxdiff ];
    end
    
    pcz_info_report(bool, varargin{:}, {'first', first+1})
    
    if ~bool
        pcz_dispFunction('Maximal difference: %g', maxdiff)
        pcz_dispFunction('Equality percentage: %g%%', (1-perc)*100)
        pcz_dispFunction('Precision: %g', 10^(-prec))

        if ~isempty(indices)
            pcz_dispFunction('Indices, where not equal: %s', pcz_num2str(indices(:)'));
            pcz_dispFunction('nr of elements where not zero/all: %d/%d', numel(indices), numel(z))
        end

        % pcz_dispFunctionStackTrace
        % pcz_dispFunctionNeedNewLine
    end
end
%%

% pcz_dispFunctionEnd(TMP_ZNEWEagSzRkCGbFsczkg);


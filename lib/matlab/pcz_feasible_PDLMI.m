function [ret] = pcz_feasible_PDLMI(PDLMI, x_lim, varargin)
%% pcz_feasible_PDLMI
%  
%  File: pcz_feasible_PDLMI.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. February 14.
%

%%

opts.title = 'PDLMI check';
opts.postol = 1e-6;
opts.tolerance = 1e-10;
opts = parsepropval(opts, varargin{:});

TMP_PwVjnhhTEChSGsAudmgj = pcz_dispFunctionName(opts.title);

%%

Mode_xlim = 0;

if size(x_lim,2) == 2 && all(x_lim * [-1 ; 1] > 0) && numel(PDLMI.subsvars) == size(x_lim,1)
    [X_v,~,~] = P_ndnorms_of_X(x_lim);
    Mode_xlim = 1;
else
    X_v = x_lim;
end

PDLMI = value(PDLMI);

X_Nr = size(X_v,1);

Mode_str = { 'vertices are given' 'rectangular region: limits are given' };
pcz_info('Mode: %s, nr. of corners: %d', Mode_str{Mode_xlim+1}, X_Nr);
pcz_info('Tolerance: %g, positive tolerance: %g.', opts.tolerance, opts.postol)
pcz_info('LMI size: (%dx%d) ', size(PDLMI));
% pcz_dispFunction2('X_v = %s', pcz_num2str(X_v));
% pcz_dispFunction ''

feasible = zeros(X_Nr,1);
min_eig = zeros(X_Nr,1);
max_eig = zeros(X_Nr,1);
percentage = zeros(X_Nr,1);
iszero = zeros(X_Nr,1);

if ~any(isnan(PDLMI.Theta(:)) | isinf(PDLMI.Theta(:)))

    for i = 1:X_Nr        
        [eigvals,min_eig(i),percentage(i)] = pcz_posdef_report(PDLMI(X_v(i,:)'), opts.tolerance);
        feasible(i) = min_eig(i) > -opts.tolerance;
        max_eig(i) = max(eigvals);
        
        if max_eig(i) < opts.postol
            iszero(i) = 1;
        end
    end

    bool = all(feasible) && ~any(iszero);

    for i = 1:X_Nr
        if min_eig(i) < 0 && feasible(i)
            pcz_warning(false, 'Least eigv: %g, in corner %s', min_eig(i), pcz_num2str(X_v(i,:)));
        elseif ~feasible(i)
            pcz_info(false, 'Least eigv: %g, in corner %s', min_eig(i), pcz_num2str(X_v(i,:)));
        end
        
        if iszero(i)
            pcz_info(false, 'P+LN+N''L'' is almost zero (max eig: %d) in corner %s', max_eig(i), pcz_num2str(X_v(i,:)));
        end
    end

    pcz_dispFunctionSeparator
    
    if any(iszero)
        [indices,~,overallperc] = pcz_symzero_report(iszero);  
        pcz_info(false, 'P+LN+N''L'' is almost zero in %d corner points out of %d, (%g%%).', numel(indices), X_Nr, overallperc);
    end
    
    if ~bool
        [indices,~,overallperc] = pcz_symzero_report(~feasible);    
        pcz_info(false, 'This LMI is NOT feasible in %d corner points out of %d, (%g%%).', numel(indices), X_Nr, overallperc*100);
    else
        pcz_info(true, 'This LMI is feasible along the given tolerance value.');
    end
        
else
    
    pcz_info(false, 'The solution contains NaN or Inf. The LMI is NOT feasible.')
    Coefficient_matrix = PDLMI.Theta;
    pcz_display(Coefficient_matrix);
    
end
    
pcz_dispFunctionEnd(TMP_PwVjnhhTEChSGsAudmgj);


end
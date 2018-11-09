function [varargout] = pcz_split_matrix(M, sizes_i, sizes_j)
%% pcz_split_matrix
%  
%  File: pcz_split_matrix.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 09.
%

%%

n = numel(sizes_i);
m = numel(sizes_j);

if (nargout > n*m)
    error('To many output arguments. Must not exceed %d x %d = %d', n, m, n*m);
end

sizes_i = num2cell([0 cumsum(sizes_i)]);
sizes_j = num2cell([0 cumsum(sizes_j)]);

to_domains = @(sizes) cellfun( @(from,to) {from+1:to}, ...
    sizes(1:end-1), sizes(2:end));

sizes_i = to_domains(sizes_i);
sizes_j = to_domains(sizes_j);

varargout = cell(n,m);

for i = 1:n
    for j = 1:m
        varargout{i,j} = M(sizes_i{i}, sizes_j{j});
    end
end


end
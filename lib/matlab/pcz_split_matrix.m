function [varargout] = pcz_split_matrix(M, sizes_i, sizes_j, varargin)
%% pcz_split_matrix
%  
%  File: pcz_split_matrix.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 09.
%

opts.RowWise = true;
opts = parsepropval(opts,varargin{:});

%%

warning 'pcz_split_matrix: FIGYELEM változás történt! Régi működés: ''RowWise'', false'
pcz_dispFunctionStackTrace('first',0,'last',0)

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

if opts.RowWise

    % Uj mukodese
    % Output arguments row-vise:
    % [A,B,C,D] = ~([A B ; C D], [nx nu], [nx ny])
    for i = 1:n
        for j = 1:m
            varargout{j,i} = M(sizes_i{i}, sizes_j{j});
        end
    end
    
else
    
    % Regi mukodese:
    % Output arguments column-vise:
    % [A,C,B,D] = ~([A B ; C D], [nx nu], [nx ny])
    for i = 1:n
        for j = 1:m
            varargout{i,j} = M(sizes_i{i}, sizes_j{j});
        end
    end
    
end

end


function test1
%%
    [A,B,C,D] = pcz_split_matrix([1 2 ; 3 4], [1 1], [1 1])

    [A,C,B,D] = pcz_split_matrix([1 2 ; 3 4], [1 1], [1 1], 'RowWise', false)

    A = pcz_split_matrix([1 2 3 ; 4 5 6 ; 7 8 9], [2], [2])
    
end


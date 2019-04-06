function [x,x_cell] = pcz_generateLFRStateVector(name,dim_bounds)
%% pcz_generateLFRStateVector
%  
%  File: pcz_generateLFRStateVector.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. April 06.
%

%%

if isscalar(dim_bounds)
    dim = dim_bounds;
    bounds = [ ones(1,dim) -ones(1,dim) ]';
else
    bounds = dim_bounds;
    dim = size(bounds,2);
end

% % Delta interface for LFR Toolbox
% blk.desc = [
%     % 1: row dimension
%     % 2: column dimension
%     % 3: real(1)/complex(0)
%     % 4: scalar(1)/full(0)
%     % 5: linear(1)/nonlinear(0)
%     % 6: time-invariant(1)(memoryless if nonlinear)/time-varying(0)
%     % 7,8: bound informations (given as intervals: 1,2)
%     ones(7,dim)    % 1-7
%     ones(1,dim)*2  % 8
%     % b.i.: intervals
%     bounds'
%     % b.i.: nominal values
%     [0.5 0.5]*bounds'
%     ];
% blk.names = cellfun(@(i) { [ name num2str(i) ] }, num2cell(1:dim));
% 
% A = zeros(dim,1);
% B = eye(dim);
% C = ones(dim,1);
% D = zeros(dim);
% 
% x = lfr(D,C,B,A,blk);

x_cell = cellfun(@(i) { lfr([name num2str(i)],'ltisr',1,bounds(i,:),'minmax') }, num2cell(1:dim));
x = vertcat(x_cell{:});

end
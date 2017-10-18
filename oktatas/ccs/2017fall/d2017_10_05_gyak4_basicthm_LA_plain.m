%% Fundamental theorem of LA
% File: d2017_10_05_gyak4_basicthm_LA.mlx
% 
% Author: Peter Polcz <ppolcz@gmail.com> 
% 
% Created on 2017. October 18.
%%
A = rand(3,2);
A = A * A'
%% 
% Matrix $A$ is rank deficient:

rank(A)
%% 
% Image space or range of matrix $A$ : $\mathrm{Im}(A)$

orth(A)
%% 
% Null space or kernel of matrix $A^T$: $\mathrm{Ker} \left(A^T\right)$

null(A')
%% 
% Due to the fundamental theorem of linear algebra, $\mathrm{Im}(A) \perp 
% \mathrm{Ker} \left(A^T\right)$
%% Visual demonstration

figure, hold on, view(3)
pcz_plotvec(orth(A))
pcz_plotvec(null(A'))
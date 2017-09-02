%% Standard 1D order reduction
%  
%  file:   standard_1d_order_reduction.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 02.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% 
% <html><h1>Some preliminary important linear algebra facts</h1></html>
%
%% Image and kernel space of linear transformation $y = Ax$
% Let us detonte $\mathcal U = \rm{Im}(A)$, $\mathcal V =
% \rm{Ker}(A)$, where $A \in \mathbb R^{n \times n}$.
% It is not necessary that $\mathcal U = \mathcal V^\perp$.

A = [
    0 1
    0 0 
    ];

U = orth(A)
V = null(A)

rank([U V])

%% Controllability and observability
% 
% $$
% \begin{aligned}
%     &\dot x = A x + B y \\
%     &y = C x
% \end{aligned}
% $$
% 
% The state space could be partitioned as follows:
% 
% $$
% X = X_{co} \otimes X_{c \bar o} \otimes X_{\bar c o} \otimes X_{\bar c \bar o}
% $$
% 
% $X_{\cdot \cdot}$ are pairwise orthogonal subsets of the state
% space.



%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
%% Script zh_generate_nice_matrices
%  
%  file:   zh_generate_nice_matrices.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.20. Monday, 21:25:53
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_zxHKNoJIigzXrElNnAKU = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% 2017 1. ZH
% 
% * $A \in \bf{R}^{3 \times 3}$
% * unobservable
% * stable

p = [-1 -2 -3];
while 1
    T = round(randn(3));
    if det(T) ~= 1 || sum(sum(T ~= 0)) > 5
        continue
    end
        
    Ti = inv(T);
    if sum(sum(Ti ~= 0)) > 6
        continue
    end
    
    A = T\diag(p)*T;    
    
    if numel(find(A)) > 7
        continue
    end
    
    if numel(find(A)) - numel(find(abs(A) - A)) < 3
        continue
    end

    B = round(randn(3,1));
    C = round(randn(1,3));

    C3 = ctrb(A,B);
    O3 = obsv(A,C);
    
    [rank(C3) rank(O3)]
    if rank(C3) < 2 || rank(C3) == 3 || rank(O3) < 2
        continue
    end
    
    break
end

LTI = [A B ; C 0]
T,Ti

B_ = T*B
C_ = C/T
C3

%%

pcz_num2str_latex(A,B,C,T)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_zxHKNoJIigzXrElNnAKU);
clear TMP_zxHKNoJIigzXrElNnAKU
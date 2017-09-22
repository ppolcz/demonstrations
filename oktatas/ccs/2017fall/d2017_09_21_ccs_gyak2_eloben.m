%% Script d2017_09_21_ccs_gyak2_eloben
%  
%  file:   d2017_09_21_ccs_gyak2_eloben.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 21.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_VgVGfoCXYiYXzPhvVPXI = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

A = randn(3);
B = rand(3,1);

K = place(A,B,[-1+1i,-1-1i,-0.5]);

A = A - B*K;

eig(A)

x0 = [1 ; 2];

f_fh = @(t,x) A*x;

figure, hold on
for i = 1:200
    [t,x] = ode45(f_fh, [0 10], randn(3,1));
    plot3(x(:,1),x(:,2),x(:,3))
    plot3(x(1,1),x(1,2),x(1,3),'.')
end
%%
% End of the script.
pcz_dispFunctionEnd(TMP_VgVGfoCXYiYXzPhvVPXI);
clear TMP_VgVGfoCXYiYXzPhvVPXI
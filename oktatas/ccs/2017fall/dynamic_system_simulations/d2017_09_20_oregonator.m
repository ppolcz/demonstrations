%% Script d2017_09_20_oregonator
%  
%  file:   d2017_09_20_oregonator.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 20.
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

syms f A B P X Y Z real
Y_mat = [
    0 1 1 2 0 , 1 0 2 0 0 
    1 1 0 0 0 , 0 0 0 0 0.5*f
    0 0 0 0 1 , 0 0 2 0 0 
    ];

k = diag(sym('k',[1,5]));
Ak = [ -k zeros(5) ; k zeros(5) ];

M = Y_mat*Ak;

phi = [
    A*Y ; X*Y ; A*X ; X^2 ; B*Z ; X*P ; 2*P ; X^2*Z^2 ; A*P ; Y^(f/2) 
    ];

f_sym = M*phi;

x = [
    X
    Y
    Z
    ];

J0 = subs(jacobian(f_sym, x),x,x*0);

k1 = 1;
k2 = 1;
k3 = 1;
k4 = 1;
k5 = 1;
A = 0.1;
B = 0.1;
f = 0.1;

double(eig(subs(J0)))

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
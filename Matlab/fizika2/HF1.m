%% Script HF1
%  
%  file:   HF1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.21. Tuesday, 16:55:03
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

syms l d0 Q ke k real

Poly(d0,Q,ke,k) = coeffs( ((d0 - l)^2)*k*l - Q^2*ke, l )

P = double(Poly(0.1,1e-5,8.988e+9,20000))
P(4:-1:1)

roots(P(4:-1:1))

%%

d0 = 0.1;
Q = 1e-5;
ke = 8.988e+9;
k = 20000;
l = 0.0050;
m = 0.1;

C = Q^2 * ke / (d0 - l)^2 - k*l

f = @(t,x) [
    x(2)
    (-k*x(1) + C)/m
    ];

[tt,xx] = ode45(f,[0,0.2],[l,0]);
plot(tt,xx(:,1))

%%

syms t x(t) k l Q d0 m
L = m*diff(x,1)/2 - k*(l-x)^2/2 - ke*Q/(d0-l+x)
EL_equation = simplify(functionalDerivative(L,x))

pretty(EL_equation)

%%

syms t x dx k l Q d0 m
L = m*dx/2 - k*(l-x)^2/2 - ke*Q/(d0-l+x)

diff_Lx = simplify(diff(L,x))
diff_Ldx = simplify(diff(L,dx))

EL_equation = diff_Ldx - diff_Lx;
pretty(EL_equation)


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
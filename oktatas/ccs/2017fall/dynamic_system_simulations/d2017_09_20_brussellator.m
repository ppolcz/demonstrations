%% Brussellator
%  
%  file:   d2017_09_20_brussellator.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 20.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

syms t real
pcz_generateSymStateVector(2);

a = 1;
b = 3;

f_sym = [
    a + x1^2*x2 - (b + 1)*x1
    b*x1 - x1^2*x2
    ];

f_fh = matlabFunction(f_sym, 'vars', {t x});

xeq = [
    a
    b/a
    ]

[tt,xx] = ode45(f_fh, [0,100], [1;2.99]);

plot(xx(:,1),xx(:,2))


%%
% End of the script.
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb
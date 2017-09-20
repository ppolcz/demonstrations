%% Rössler attractor
%  
%  file:   d2017_09_20_Rossler_attractor.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 20.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_sRECVoNNtDdcBOWgDyar = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% System model
% <https://en.wikipedia.org/wiki/R%C3%B6ssler_attractor Rössler
% attractor on the Wikipedia>

syms x y z real
syms a b c real


f_sym = [
    -y - z
    x + a*y
    b + z*(x - c)
    ];

%% Chaotic
a = 0.2;
b = 0.2;
c = 5.7;
f_fh = matlabFunction(subs(f_sym), 'vars', {'t' [x;y;z]});
[t,r] = ode45(f_fh, [0,1000], [1;1;0]);
plot3(r(:,1),r(:,2),r(:,3))
xlabel 'x'; ylabel 'y'; zlabel 'z'

%% Periodic
a = 0.1;
b = 0.1;
c = 12; % 4,6,8
f_fh = matlabFunction(subs(f_sym), 'vars', {'t' [x;y;z]});
[t,r] = ode45(f_fh, [0,1000], [1;1;0]);

% Plot only the last part of the simulation (do not show transients)
I = round(numel(t)/2):numel(t);
plot3(r(I,1),r(I,2),r(I,3))
xlabel 'x'; ylabel 'y'; zlabel 'z'

%%
% End of the script.
pcz_dispFunctionEnd(TMP_sRECVoNNtDdcBOWgDyar);
clear TMP_sRECVoNNtDdcBOWgDyar
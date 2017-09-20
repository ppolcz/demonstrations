%% Lorentz system
%
%  file:   d2017_09_20_Lorentz_system.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017. September 20.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_wtNPjzxHKNoJIigzXrEl = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%%

sigma = 10;
beta = 8/3;
rho = 28;

f = @(t,x) [
    -sigma*x(1) + sigma*x(2)
    rho*x(1) - x(2) - x(1)*x(3)
    -beta*x(3) + x(1)*x(2)
    ];

[t,x] = ode45(f,[0 50],[1 1 1]);
figure, plot3(x(:,1),x(:,2),x(:,3))

figure,
subplot(311), plot(t, x(:,1));
subplot(312), plot(t, x(:,2));
subplot(313), plot(t, x(:,3));

%%
% End of the script.
pcz_dispFunctionEnd(TMP_wtNPjzxHKNoJIigzXrEl);
clear TMP_wtNPjzxHKNoJIigzXrEl
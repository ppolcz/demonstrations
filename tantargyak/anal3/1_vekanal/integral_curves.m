%% Script integral_curves
%  
%  file:   integral_curves.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.01. Saturday, 23:33:53
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

[x1,x2] = meshgrid(linspace(-4,4,30));

dx1 = 1;
dx2 = x1.^2 - x1 - 2;
r = (dx1.^2 + dx2.^2).^0.5;
quiver(x1,x2,dx1./r,dx2./r), hold on

f = @(t,x) [
    1
    x(1).^2 - x(1) - 2
    ];

[t,x] = ode45(f,[0,6],[-2.5;-4]);

plot(x(:,1), x(:,2))

%% Integral curves

f = @(t,x) [
    1
    x(1).^2 - x(1) - 2
    ];

figure, 
quiver(x1,x2,dx1./r,dx2./r,'-');, hold on
for x1_val = linspace(-4,0,20);
    [t,x] = ode45(f,[0,10],[x1_val;-4]);
    plot(x(:,1), x(:,2), 'r')
end
axis([-4 4 -4 4])

%% Centered normalized tangent space (examples)

figure, pcz_integral_slopes(x1,x2,dx1,dx2,0.2,'r')
figure, pcz_integral_slopes(x1,x2,dx1,dx2,'b')
figure, pcz_integral_slopes(x1,x2,dx1,dx2,'Color','green')
figure, pcz_integral_slopes(x1,x2,dx1,dx2,1,'Color',[0 1 1])

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
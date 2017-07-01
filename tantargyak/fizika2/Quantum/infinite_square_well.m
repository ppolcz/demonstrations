%% Script infinite_square_well
%  
%  file:   infinite_square_well.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.05.18. Thursday, 13:55:59
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

%% Linear combination of two stationary solution

a = 1;
h = 1.05457e-34;
k1 = 1*pi/a;
k2 = 2*pi/a;

syms t x real

A = 1;
m = 1;
Psi1_sym = A*sin(k1*x) * exp(-1i * k1 * t);
Psi2_sym = A*sin(k2*x) * exp(-1i * k2 * t);

Psi1 = matlabFunction(Psi1_sym, 'vars', {t,x});
Psi2 = matlabFunction(Psi2_sym, 'vars', {t,x});

T = 10;
N = 500;
tspan = linspace(0,T,N);
xspan = linspace(0,a,100);
[t,x] = meshgrid(tspan, xspan);

Psi_num = Psi1(t,x) + Psi2(t,x);

for j = 1:N
    plot(xspan, [imag(Psi_num(:,j)), abs(Psi_num(:,j)).^2, real(Psi_num(:,j))]);
    axis([0,a,-4*A,4*A])
    drawnow
    pause(0.01)
end

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
%% Script gyak12_disztribuciok
%  
%  file:   gyak12_disztribuciok.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.05.18. Thursday, 21:06:16
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

a = -1;
b = 1;


phi = exp(-1./(x-a).^2).*exp(-1./(x-b).^2);


%% 

a = 0;
b = 0.2;
phi = @(x) exp(-1./(x-a).^2).*exp(-1./(x-b).^2);

x = linspace(a,b,1000);
phi_norm = @(x) exp(-1./(x-a).^2).*exp(-1./(x-b).^2) / integral(phi,a,b);
integral(phi_norm,a,b)

phi_norm = exp(-1./(x-a).^2).*exp(-1./(x-b).^2) / integral(phi,a,b);
plot(x,phi_norm)

%%

figure, subplot(131)

n = 1;
a = -1/n;
b = 1/n;
x = linspace(a,b,1000);
phi_norm = exp(-1./(x-a).^2).*exp(-1./(x-b).^2) * exp(2*n^2);
plot(x,phi_norm)

subplot(132)

n = 3;
a = -1/n;
b = 1/n;
x = linspace(a,b,1000);
phi_norm = exp(-1./(x-a).^2).*exp(-1./(x-b).^2) * exp(2*n^2);
plot(x,phi_norm)

subplot(133)

n = 10;
a = -1/n;
b = 1/n;
x = linspace(a,b,1000);
phi_norm = exp(-1./(x-a).^2).*exp(-1./(x-b).^2) * exp(2*n^2);
plot(x,phi_norm)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
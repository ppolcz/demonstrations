%% Script lagrange_multiplier
%  
%  file:   lagrange_multiplier.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.12. Monday, 17:47:11
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

[x,y,l] = meshgrid(linspace(-3,3,40));

f = @(x,y) x.^2 + y.^2;
g = @(x,y) x + y - 1;
L = f(x,y) - l.*g(x,y);

slice3(L)
xlabel x
ylabel y
zlabel lambda

%%
figure, hold on;
[x,y] = meshgrid(linspace(-3,3,40));
surf(x,y,f(x,y));

[x,z] = meshgrid(linspace(-2,3,40),linspace(min(min(f(x,y))),max(max(f(x,y))),40));
surf(x,1-x,z);



%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
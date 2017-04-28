%% Script demo_1_gradient_normal_vector
%  
%  file:   demo_1_gradient_normal_vector.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.27. Thursday, 14:24:33
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_UdmcwaUkepxfZrpdpcAN = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Numerical gradient

h = 0.1;
[x,y] = meshgrid(-1:h:1);
z = x.^2 + y.^2;
[n1,n2] = gradient(z,h);
n3 = -ones(size(z));

figure('Position', [ 181 184 1400 463 ], 'Color', [1 1 1])
subplot(121)
surf(x,y,z), hold on
quiver3(x,y,z,n1,n2,n3), axis equal

subplot(122),
quiver(x,y,n1,n2), axis equal, axis tight

%% Symbolic gradient

syms x y z real
r = [x ; y ; z];

f = x^2 + y^2;
n = gradient(f);

[xx,yy] = meshgrid(linspace(-1,1,20));
ff = double(subs(f, {x y}, {xx yy}));

nn1 = double(subs(n(1), {x y}, {xx yy}));
nn2 = double(subs(n(2), {x y}, {xx yy}));
nn3 = -ones(size(ff));

figure('Position', [ 181 184 1400 463 ], 'Color', [1 1 1])
subplot(121)
surf(xx,yy,ff), hold on
quiver3(xx,yy,ff,nn1,nn2,nn3), axis equal

subplot(122),
quiver(xx,yy,nn1,nn2), axis equal, axis tight

%% Tangent plane

syms x y z real
r = [x ; y ; z];

P_xy = [0.2 0.2];
P = [P_xy subs(f,[x y], P_xy)]'
n = double([subs(gradient(f),[x y],P_xy) ; -1])

n'*P

eqn = n' * r - n' * P
z_plane = solve(eqn,z)

zz_plane = double(subs(z_plane, {x y}, {xx yy}))

figure, hold on
surf(xx,yy,ff)
surf(xx,yy,zz_plane)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_UdmcwaUkepxfZrpdpcAN);
clear TMP_UdmcwaUkepxfZrpdpcAN
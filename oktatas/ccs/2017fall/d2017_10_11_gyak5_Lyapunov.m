%% Script d2017_10_11_gyak5_Lyapunov
%  
%  file:   d2017_10_11_gyak5_Lyapunov.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. October 11.
%
%% Hamiltonian system

syms alpha t x y real
r = [x;y];

V = alpha - (x + 1 + alpha) * exp(-x - 1 - alpha) / (1 + exp(-x - 1 - alpha)) + sqrt(y^2 + 1) / 2 - 1/2;

gradV = jacobian(V,r);

f = [ gradV(2) ; -gradV(1) ] + diag([-0.03 -0.03])*r;


alpha = lambertw(exp(-1));
V_sym = subs(V);
f_sym = subs(f);

V_fh = matlabFunction(V_sym, 'vars', r);
f_ode = matlabFunction(f_sym, 'vars', {t r});
f1_fh = matlabFunction(f_sym(1), 'vars', r);
f2_fh = matlabFunction(f_sym(2), 'vars', r);

[tt,xx] = ode45(f_ode, [0, 100], [3;1]);
V_xx = V_fh(xx(:,1), xx(:,2));

res = 300;
[x_mesh,y_mesh] = meshgrid(linspace(-2,6,res),linspace(-2,2,res));
V_mesh = V_fh(x_mesh,y_mesh);
V_mesh(V_mesh > 0.5) = NaN;

res = 16;
[x_mesh2,y_mesh2] = meshgrid(linspace(-2,6,res),linspace(-2,2,res));
v1 = f1_fh(x_mesh2,y_mesh2);
v2 = f2_fh(x_mesh2,y_mesh2);

r = sqrt(v1.^2 + v2.^2);
v1 = v1 ./ r;
v2 = v2 ./ r;

figure('Position', [ 349 368 1238 583 ]), 
subplot(1,3,[1 2])
view([ 40.9 , 34 ]), hold on, grid on
xlim([-2,6])
ylim([-2,2])
axis vis3d
plot(xx(:,1), xx(:,2),'linewidth',2)
plot(xx(1,1), xx(1,2),'.k')
plot3(xx(:,1), xx(:,2),V_xx,'linewidth',2)
plot3(xx(1,1), xx(1,2),V_xx(1),'.k')
surf(x_mesh,y_mesh,V_mesh,'facealpha',0.5)
shading interp
ax = gca;
ax.FontSize = 16;

quiver(x_mesh2,y_mesh2,v1,v2,0.5, 'Color', [1 1 1]*0.5);

subplot(1,3,3)
plot(tt,V_xx), grid on
title('$V(t) := V(x(t))$', 'interpreter', 'latex','fontsize',22)
xlabel('time $t$ [s]', 'interpreter', 'latex','fontsize',22)
ax = gca;
ax.FontSize = 16;


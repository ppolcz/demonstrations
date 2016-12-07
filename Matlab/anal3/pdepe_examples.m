%% 
%  
%  file:   pdepe_examples.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.07. Wednesday, 11:51:36
%
%% 

sigma = 1;

%%%
% $$c = \pi^2 ~,~~ f = u'_x ~,~~ s = 0$$
pdex1pde = @(x,t,u,DuDx) deal( pi^2 , DuDx , 0);

%%%
% Initial condition:
% $u(x,t_0) = u_0(x)$
pdex1ic = @(x) (sigma * sqrt(2*pi)) \ exp(-x.^2 / (2 * sigma^2));

%%%
%
pdex1bc = @(xl,ul,xr,ur,t) deal( ul, 0, ur , 0 );

x_lim = 10;

m = 0;
x = linspace(-x_lim,x_lim,50);
t = linspace(0,50,50);

sol = pdepe(m,pdex1pde,pdex1ic,pdex1bc,x,t);
% Extract the first solution component as u.
u = sol(:,:,1);

figure('Position', [165 540 1066 380], 'Color', 'white');

% A surface plot is often a good way to study a solution.
subplot(121),
surf(x,t,u) 
title('Numerical solution computed with 20 mesh points.')
xlabel('Distance x')
ylabel('Time t')
% zlim([0,10])

subplot(122),
for i = 1:numel(t)
   plot(x, u(i,:));
   title(sprintf('time = %g, $\\int u(x,t) = %g$', t(i), trapz(x, u(i,:))), 'Interpreter', 'latex'),
   axis([-x_lim, x_lim, 0, 1/(sigma * sqrt(2*pi))])
   pause(0.1),
end
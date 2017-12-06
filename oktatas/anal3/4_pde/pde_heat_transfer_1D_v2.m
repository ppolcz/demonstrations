%% Hővezetés egyenlete végtelen rúdban
%  
%  file:   pde_heat_transfer_1D_v2.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.07. Wednesday, 11:51:36
%  Reviewed on 2017. December 06.
% 
%%

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

PUBLISH = 1; 

%% Hővezetés egyenlete adott kezdeti feltétel mellett
% Hővezetés egyenlete: $u'_t = k u''_{xx}$, ahol $k=1$.
% 
% Kezdeti feltételek: 
% $$
%     u(x,0) = \left\{\begin{array}{lc} 0 & x < 0 \\
%     e^{-x} & x \ge 0 \end{array}\right.
% $$
% 
% A Matlab |pdepe| függvénye a következő típusú egyváltozós időfüggő PDE-t
% tudja megoldani: 
% 
% $$
%     c(x,t,u,u'_x) \, u'_t = x^{-m} \frac{\partial}{\partial
%     x} \Big(x^m f(x,t,u,u'_x)\Big) + s(x,t,u,u'_x),
% $$ 
% 
% ahol $m=0,1,2$. Ha $c = 1$, $m=0$, $f = k u'_x$, $s=0$, akkor épp a
% hullámegyenletet kapjuk. A Matlab numerikus megoldója peremfeltételeket is kíván, ezért legyen
% $u(-5,t) = u(10,t) = 0$.

k = 1;
pde = @(x,t,u,DuDx) deal( 1 , k*DuDx , 0);

%%%
% Initial condition:
% $u(x,t_0) = u_0(x)$
ic1 = @(x) exp(-x) * (1 + sign(x)) / 2;

%%%
% 
bc = @(xl,ul,xr,ur,t) deal( ul, 0, ur , 0 );

x_lim1 = -5;
x_lim2 = 10;

m = 0;
x = linspace(x_lim1,x_lim2,1000);
t = linspace(0,0.1,201);

%%%
% $$c = 1 ~,~~ f = k u'_x ~,~~ s = 0$$
sol = pdepe(m,pde,ic1,bc,x,t);
% Extract the first solution component as u.
u = sol(:,:,1);

fig = figure('Position', [165 540 1066 380], 'Color', 'white');
subplot(121),
surf(x,t,u), light, shading interp
xlabel('Distance x')
ylabel('Time t')

clear frames
for i = 1:numel(t)
    subplot(222),

    u_ref = exp(k*t(i)-x) .* ...
        ( 1 - normcdf((2*k*t(i) - x) / sqrt(2*k*t(i))) );

    plot(x, [ u(i,:) ; u_ref ]);
    title(sprintf('time = %.4f, %s', t(i),...
        '$u(x,t) = e^{kt-x}\,\left( 1 - \Phi\left(\frac{2 k t - x}{\sqrt{2 k t}}\right)\, \right)$'), 'Interpreter', 'latex'),
    axis([-5, 5, 0, 1.5]);

    L = legend('numerikus megoldás 0-0 kezdeti feltételekkel',...
        'analitikus megoldás végtelen hosszú rúd esetén');
    L.FontSize = 8;

    subplot(224),
    plot(x,u_ref-u(i,:))
    L = legend('hiba');
    L.Location = 'southeast';
    xlim([-5 5])
   
    if PUBLISH
        frames(i) = getframe(fig);
    else
        pause(0.1)
    end
end

if PUBLISH
    delete(fig)
    persist.pub_vid_write(frames)
end

%% Hővezetés egyenlete más kezdeti feltétel mellett
% Hővezetés egyenlete: $u'_t = k u''_{xx}$, ahol $k=1$.

sigma = 1;
k = 1;

%%%
% $$c = 1 ~,~~ f = k u'_x ~,~~ s = 0$$
pde = @(x,t,u,DuDx) deal( 1 , k*DuDx , 0);

%%%
% Initial condition:
% $u(x,t_0) = u_0(x)$
ic2 = @(x) (sigma * sqrt(2*pi)) \ exp(-x.^2 / (2 * sigma^2));

%%%
%
bc = @(xl,ul,xr,ur,t) deal( ul, 0, ur , 0 );

x_lim = 10;

m = 0;
x = linspace(-x_lim,x_lim,1000);
t = linspace(0,2,101);

sol = pdepe(m,pde,ic2,bc,x,t);
% Extract the first solution component as u.
u = sol(:,:,1);

fig = figure('Position', [165 540 1066 380], 'Color', 'white');

% A surface plot is often a good way to study a solution.
subplot(121),
surf(x,t,u), light, shading interp
xlabel('Distance x')
ylabel('Time t')
% zlim([0,10])

clear frames
subplot(122),
for i = 1:numel(t)
    plot(x, u(i,:));
    title(sprintf('time = %0.2f, $\\int u(x,t) = %g$', t(i), trapz(x, u(i,:))), 'Interpreter', 'latex'),
    axis([-x_lim, x_lim, 0, 1])
   
    if PUBLISH
        frames(i) = getframe(fig);
    else
        pause(0.1)
    end
end

if PUBLISH
    delete(fig)
    persist.pub_vid_write(frames)
end

%% Hővezetés egyenlete más kezdeti feltétel mellett
% Hővezetés egyenlete: $u'_t = k u''_{xx}$, ahol $k=1$.

sigma = 1;
k = 1;

%%%
% $$c = 1 ~,~~ f = k u'_x ~,~~ s = 0$$
pde = @(x,t,u,DuDx) deal( 1 , k*DuDx , 0);

%%%
% Initial condition:
% $u(x,t_0) = u_0(x)$
ic3 = @(x) triangularPulse(0,1,x);

% x = linspace(0,1,100);
% plot(x,ic3(x))

%%%
%
bc = @(xl,ul,xr,ur,t) deal( ul, 0, ur , 0 );

m = 0;
x = linspace(0,1,100);
t = linspace(0,0.1,101);

sol = pdepe(m,pde,ic3,bc,x,t);
% Extract the first solution component as u.
u = sol(:,:,1);

fig = figure('Position', [165 540 1066 380], 'Color', 'white');

% A surface plot is often a good way to study a solution.
subplot(121),
surf(x,t,u), light, shading interp
xlabel('Distance x')
ylabel('Time t')
% zlim([0,10])

clear frames
subplot(122),
for i = 1:numel(t)
    plot(x, u(i,:));
    title(sprintf('time = %0.3f, $\\int u(x,t) = %0.5f$', t(i), trapz(x, u(i,:))), 'Interpreter', 'latex'),
    axis([0, 1, 0, 1])
   
    if PUBLISH
        frames(i) = getframe(fig);
    else
        pause(0.1)
    end
end

if PUBLISH
    delete(fig)
    persist.pub_vid_write(frames)
end

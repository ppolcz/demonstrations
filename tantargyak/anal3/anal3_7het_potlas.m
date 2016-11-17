%%
%
%  file:   anal3_7het_potlas.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.11.14. Monday, 11:57:37
%

%% Documentation
web(fullfile(docroot, 'symbolic/vector-analysis.html'))

%% Vektoranalizis - divergencia (divergence)

clc
fprintf '\n[1] Vektoranalizis - divergencia (divergence)\n\n\n'

x = sym('x',[5,1], 'real')

F = round(rand(5)) * x + (sin(round(rand(5)*0.6) * x))

fprintf '`divergence(F,x)` = \n'
disp(divergence(F,x))

fprintf 'a `curl` csak 3 dimenzios fuggvenyekre mukodik: \ncurl(F(1:3),x(1:3)) = \n'
disp(curl(F(1:3),x(1:3)))

%% Vektoranalizis - rotacio (curl)

clc
fprintf '\n[2] Vektoranalizis - rotacio (curl)\n\n\n'

syms x y z real
F = [
    sin(x)*cos(y) + z^2
    exp(z)*x
    x*y / (x^2 + 1)
    ];

disp 'curl(F) = '
disp(curl(F))

disp 'pretty(curl(F)) = '
pretty(curl(F))

disp 'curl(F,[z;x;y]) = '
disp(curl(F,[z;x;y]))

%% Vektoranalizis - gradiens (gradient)

clc
fprintf '\n[3] Vektoranalizis - gradiens (gradient)\n\n\n'

syms x1 x2 x3 x4 x5 real
x = [x1;x2;x3;x4;x5];

f = x' * round(rand(5)) * x;
disp 'f = x'' * round(rand(5)) * x = '
disp(f)

f = expand(f);
disp 'expand(f) = '
disp(f)

disp 'gradient(f) = '
disp(gradient(f))

disp 'gradient(f,x) = '
disp(gradient(f,x))

disp 'gradient(f,[x1;x5;x2]) = '
disp(gradient(f,[x1;x5;x2]))

%% Vektoranalizis - Jacobi matrix (jacobian)

clc
fprintf '\n[4] Vektoranalizis - Jacobi matrix (jacobian)\n\n\n'

syms x1 x2 x3 x4 x5 u v w real
x = [x1;x2;x3;x4;x5];

F = [
    x2^2 + sin(x1)*x4
    x3 + cos(x2) + u*x1
    exp(x2)*sin(x1)
    ];
disp 'F(x1,x2,x3,x4;u) = '
pretty(F)

disp 'jacobian(F) = '
disp(jacobian(F))

fprintf 'E szerint tortenik a gradiens szamolas, ha nem adjuk meg explicite mi szerint szamolja a gradienst: '
fprintf '`symvar(F)` = '
disp(symvar(F))

fprintf 'Tehat `jacobian(F)` == `jacobian(F,symvar(F))`\n\n'

disp 'jacobian(F,x) = '
disp(jacobian(F,x))

disp 'jacobian(F,[x;u;v;w]) = '
disp(jacobian(F,[x;u;v;w]))

%% Vektoranalizis - Laplace operator (laplacian), Hesse matrix (hessian)

clc
fprintf '\n[5] Vektoranalizis - Laplace operator (laplacian), Hesse matrix (hessian)\n\n\n'

syms x y z real
r = [x;y;z];

f = simplify([sin(x) exp(z)] * round(rand(2,3)*0.7) * r + sin(x)^2);
disp 'f = simplify([sin(x) exp(z)] * round(rand(2,3)*0.7) * r + sin(x)^2) = '
disp(f)

disp 'pretty(f) = '
pretty(f)

Lf = laplacian(f,r);
disp 'Lf = laplacian(f) = '
disp(Lf)

Lf = simplify(Lf);
disp 'simplify(Lf) = '
disp(Lf)

ddf = simplify(hessian(f,r));
disp 'ddf = simplify(hessian(f)) = '
disp(ddf)

%% Vektoranalizis - Potencialfuggvenyek kiszamitasa

clc
fprintf '\n[6] Vektoranalizis - Potencialfuggvenyek kiszamitasa\n\n\n'

syms x y z real
r = [x;y;z];

F = [
    y*z + 1 + y + cos(z)*sin(x)
    x*z + x
    x*y + sin(z)*cos(x)
    ];

disp 'F(x,y,z) = '
disp(F)

disp 'potential(F,r) [ha letezik potencialfuggveny] = '
disp(potential(F,r))


F = [
    z
    0
    0
    ];

fprintf 'F(x,y,z) = '
disp(F')

disp 'potential(F,r) [ha letezik potencialfuggveny] = '
disp(potential(F,r))

%% Matlab - function handle - szimbolikus objektum

clc

fprintf 'Adott egy fuggveny handle: f = '
f = @(t,x) [ 
    x(2)
    -sin(x(1)) - 0.6*x(2)
    ];
disp(f)

T = 30;
[tt,xx] = ode45(f, [0,T], [1;0]);

plot(tt,xx),
h = legend('$\theta$ angle', '$\dot{\theta}$ angular velocity');
set(h,'Interpreter','latex');

% uj_x = interp1(regi_t, regi_x, uj_t)
theta = interp1(tt,xx(:,1),linspace(tt(1),tt(end),T*10));

coordx = sin(theta);
coordy = -cos(theta);

if false 
    %%
    figure(1);
    for i = 1:numel(theta)
        tic
        plot([0,coordx(i)],[0,coordy(i)], 'linewidth', 4),
        axis([-2,2,-2,2])
        elapsed_time = toc;
        pause(max(0.01-elapsed_time,0.01))
    end
end

%% Matlab symbolikus fuggvenybol fuggveny handle
clc
syms t x1 x2 real

f_sym = [
    x2
    -sin(x1) - x2/2
    ];
disp('f(x) = ')
pretty(f_sym)

disp 'matlabFunction(f_sym) [erre nem mukodik az ode45] = ' 
f_fh1 = matlabFunction(f_sym);
disp(f_fh1)

disp 'matlabFunction(f_sym, ''vars'', {t, [x1;x2]}) = ' 
f_fh2 = matlabFunction(f_sym, 'vars', {t, [x1;x2]});
disp(f_fh2)

figure,
[tt,xx] = ode45(f_fh2, [0,30], [1;0]);
plot(tt,xx)

%% Szimbolikus integralas
clc

syms a b x y z real
f = 1 / ( cos(x)^2 * cot(x)^2);

disp 'f(x) = '
pretty(f)

F = int(f);

fprintf 'F(x) = `int(f)` = \n', 
pretty(F)

fprintf '`rewrite(F,''sincos'')` = \n'
pretty(rewrite(F,'sincos'))

fprintf '`rewrite(F,''exp'')` = \n'
pretty(rewrite(F,'exp'))

%% Numerikus integralas - ode45-el

T = 10;
Ts = 0.01;

syms t x real
f_sym = sin(t^2);
f_fh = matlabFunction(f_sym, 'vars',{t,x});
[t,F] = ode45(f_fh, linspace(0,T,T/Ts), 1);
% [t,F] = ode45(f_fh, [0,10], 1);
plot(t,F), hold on
plot(t,f_fh(t,0),'linewidth',2)
plot(t(2:end), diff(F)/Ts)

%% Numerikus integralas - integral -al

syms x y real

f = x^2 + sin(x)^2;
f_fh = matlabFunction(f);

I = integral(f_fh, 2, 3)

%%
F = int(f,x)
II = double(subs(F,x,3) - subs(F,x,2))

%% integral2

syms x y real

f = x^2 + y^2 + sin(x)^2;
f_fh = matlabFunction(f);

I = integral2(f_fh, -1, 1, @(x) -sqrt(1-x.^2), @(x) sqrt(1-x.^2))


%%

syms x y real
f = x^2 + y^2 + sin(x)^2;

F = int(f,x,2,3)

%%

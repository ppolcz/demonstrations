%%
%
%  file:   num_vonalintegral.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.08. Thursday, 09:06:20
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Numerikus primitiv fuggveny szamitas `ode45`-el
%  (csak egyvaltozos fuggvenyek eseten mukodik)

f = @(x,~) 2*x;
x0 = 0; x_max = 5; F0 = -1;
[x,F] = ode45(f,[x0 x_max],F0);
plot(x,F)

%% subs parancs

syms x y t real

f_xy = (sin(x) + cos(y) * x^2) / (x^2 + y^2 + 1);
x_t = (t+2) / (t^2 + 1);

pretty(f_xy)
pretty(x_t)

g_ty = subs(f_xy, x, x_t);

pretty(g_ty)


%% Numerikus (határozott) integrálás `integral` függvénnyel

f = @(x) 4*cos(x).*sin(x).^2 - cos(x).^2.*sin(x);

% integrálási tartomány: D = [a,b]
a = 0;
b = pi/2;

I = integral(f, a,b)

%% Skalarszorzat

A = [ 0.5 0.5 ]';
n = [ 1 0 ]';

figure, hold on
quiver(0,0,A(1),A(2),'r');
quiver(0,0,n(1),n(2),'g');

An = A'*n * n;
quiver(0,0,An(1),An(2),'b');

%% Vektormezo numerikus integralasa egy adott gorbe menten (Munkavégzés egy erőtérben)
%  2015 gyak1 5.)

dot = @(f,g,dim) sum(f.*g,dim);

syms t x y real
r = [x;y];

% Az ellipszis átmérői
a = 2;
b = 1;

% F(x,y) = F(r) kétdimenziós vektormező
F = [
    x^2
    y^2
    ];

% g, mint gamma paraméteres megadású függvény
g = [
    a*cos(t)
    b*sin(t)
    ];

% Integrálási tartomány:
t1 = 0;
t2 = pi/2;

% r = [x;y] helyére behelyettesítjük g deriváltját
Integrand = subs(F,r,g)' * diff(g, t);
pretty(Integrand)

% Átalakítjuk fügvény handle-é (anonim függvény)
Integrand_fh = matlabFunction(Integrand)

numerikusan_kiszamolt_ertek = integral(Integrand_fh, t1, t2)
analitikusan_kiszamolt_ertek = (b^3 - a^3)/3

% symbolikus integralassal:
Integral = int(Integrand, t);
szimbolikus_integralassal = subs(Integral,t,t2) - subs(Integral,t,t1)
vagyis = double(szimbolikus_integralassal)


%% Vektormezo numerikus integralasa egy adott gorbe menten (Munkavégzés egy erőtérben)
%  2015 gyak1 6.)

dot = @(f,g,dim) sum(f.*g,dim);

syms t x y z real
r = [x;y;z];

a = 2;
b = 1;

T = pi/2;

F = [
    3*x^2*y^2*z
    2*x^3*y*z
    x^3*y^2
    ];

P = [1;2;3];
g = t*P;

Integrand = subs(F,r,g)' * diff(g, t);

numerikusan_kiszamolt_ertek = integral(matlabFunction(Integrand), 0, 1)

% symbolikus integralassal:
Integral = int(Integrand, t);
szimbolikus_integralassal = double(subs(Integral,t,1) - subs(Integral, t, 0))

%% Vektormezo numerikus integralasa egy adott gorbe menten (Munkavégzés egy erőtérben)
%  2015 gyak1 7.)
%  konzervativ eroter

call = @(fh,args) fh(args{:});
dot = @(f,g,dim) sum(f.*g,dim);

syms t x y z real
r = [x;y;z];

a = 2;
b = 1;

T = pi/2;

F = [
    y*z
    x*z
    x*y
    ];

g = [
    2*cos(7*t*pi/2 + pi/2)
    3*sin(9*t*pi/2)
    5*sin(t*pi/2)*cos(3*t*pi/2 + pi/2) - 4*t
    ];

g_lin = [
    2*t
    3*t
    t
    ];

% 7. feladat (a) DE egyenes menten (ugyanaz kell kijojjon: 216)
% g_lin = [
%     18*t
%     9*t - 5
%     3*t
%     ];

t0 = 0;
t1 = 1;

Integrand = subs(F,r,g)' * diff(g, t);
numerikusan_kiszamolt_ertek_girbe_gurba = integral(matlabFunction(Integrand), t0, t1)

% symbolikus integralassal:
Integral = int(Integrand, t);
szimbolikus_integralassal = double(subs(Integral, t, t1) - subs(Integral, t, t0))

Integrand = subs(F,r,g_lin)' * diff(g_lin, t);
numerikusan_kiszamolt_ertek_egyenes = integral(matlabFunction(Integrand), t0, t1)

% symbolikus integralassal:
Integral = int(Integrand, t);
szimbolikus_integralassal = double(subs(Integral, t, t1) - subs(Integral, t, t0))

tt = linspace(t0,t1,1000);
[xx,yy,zz] = ndgrid(linspace(-5,5,6));
gg = call(matlabFunction(g), {tt})';
gg_lin = call(matlabFunction(g_lin), {tt})';

figure, hold on
quiver3(xx,yy,zz,yy.*zz,xx.*zz,xx.*yy)
plot3(gg(1,1),gg(1,2),gg(1,3), 'ro',...
    gg(:,1),gg(:,2),gg(:,3), 'r',...
    gg(end,1),gg(end,2),gg(end,3), 'ro', 'linewidth', 2)
plot3(gg_lin(1,1),gg_lin(1,2),gg_lin(1,3), 'bo',...
    gg_lin(:,1),gg_lin(:,2),gg_lin(:,3), 'b',...
    gg_lin(end,1),gg_lin(end,2),gg_lin(end,3), 'bo', 'linewidth', 2)
axis equal tight

%%

dr = sqrt(dgx.^2 + dgy.^2);

F1 = matlabFunction(F_sym(1), 'vars', {x,y});
F2 = matlabFunction(F_sym(2), 'vars', {x,y});

[xx,yy] = meshgrid(linspace(0,max(a,b),40));

figure
quiver(xx,yy,F1(xx,yy),F2(xx,yy)), hold on
quiver(gx,gy,dgy./dr,-dgx./dr,0.3)
plot(gx,gy,'r')
axis equal tight

%% Vektormezo numerikus integralasa egy adott gorbe menten

syms x y real
r = [x;y];

a = 2;
b = 1;

T = pi/2;

F_sym = [
    x^2
    y^2
    ];

T = pi/2;
N = 40;
Ts = T / N;
t = linspace(0,T,N);

gx = a*cos(t);
gy = b*sin(t);

dgx = -a*sin(t);
dgy = b*cos(t);

dr = sqrt(dgx.^2 + dgy.^2);

F1 = matlabFunction(F_sym(1), 'vars', {x,y});
F2 = matlabFunction(F_sym(2), 'vars', {x,y});

[xx,yy] = meshgrid(linspace(0,max(a,b),40));

figure
quiver(xx,yy,F1(xx,yy),F2(xx,yy)), hold on
quiver(gx,gy,dgy./dr,-dgx./dr,0.3)
plot(gx,gy,'r')
axis equal tight


%% Skalarmezo numerikus integralasa egy adott gorbe menten

syms t x y real
r = [x;y];

a = 2;
b = 1;

T = pi/2;

g = [
    a*cos(t)
    b*sin(t)
    ];

F_sym = [ x^2 + y^2 ];
F = matlabFunction(F_sym, 'vars', {r});
Fg = matlabFunction(F(g), 'vars', {t});

numerikusan_kiszamolt_ertek = integral(Fg, 0, T)

%% Plottolas

syms x y real
r = [x;y];

T = pi/2;
N = 1000;
Ts = T / N;
t = linspace(0,T,N);

gx = a*cos(t);
gy = b*sin(t);

F_sym = [ x^2 + y^2 ];
F = matlabFunction(F_sym, 'vars', {x,y});

[xx,yy] = meshgrid(linspace(-2,2,40));

% Create figure
fig = figure('InvertHardcopy','off','Color',[1 1 1], ...
    'Units', 'normalized', 'Position', [0 0 0.4 1]);

% Create axes
ax = axes('Parent',fig,'LineWidth',2,'FontSize',20,...
    'FontName','TeX Gyre Schola Math',...
    'PlotBoxAspectRatio',[1.73581081081081 2.425 1],...
    'DataAspectRatio',[1 1 1]);
hold(ax, 'on');
axis(ax, 'tight');

colorbar
view(ax,[145,22]);
% box(ax,'on');
grid(ax,'on');

light('Parent',ax);
xlabel('$x_1$','FontSize',25,'Interpreter','latex');
ylabel('$x_2$','FontSize',25,'Interpreter','latex');
zlabel('$x_3$','FontSize',25,'Interpreter','latex');


surf(xx,yy,F(xx,yy), 'facealpha', 0.7)
plot3(gx,gy,F(gx,gy),'r', 'linewidth', 3)
plot(gx,gy,'r', 'linewidth', 3)
pcz_area3(gx,gy,F(gx,gy), ones(1,N)*8,'facecolor', 'interp', 'facealpha', 0.7);
shading interp

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
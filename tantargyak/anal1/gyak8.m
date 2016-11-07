%% 
%  
%  file:   gyak8.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.07. Monday, 16:15:09
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% 9. feladat

syms x u real

f = (x+1) * (3-x)^(1/3);
df = simplify(diff(f,x));

figure, hold on
ezplot(f,[-3,1])

x = -1;

y = subs(f + df*(u-x));
ezplot(y,[-3,1])

pretty(f)
pretty(df)
pretty(y)

%% 10. feladat

syms x real
ezplot(2+x-x^2,[0,1]), grid on

%% 11. feladat

syms x real

f = x^3 - x + 1;
ezplot(f, [-1.2,1.2]), hold on, axis equal, grid on

s = solve(diff(f,x) == 2,x)

plot(s, feval(matlabFunction(f),s), 'o')

%% 17. (a) feladat

syms x y real
syms f(x)

figure, hold on
ezplot(x^2 + y^2 == 1)

x0 = 1/2;
y0 = sqrt(3)/2;
dy0 = -x0/y0;

ezplot(y0 + dy0*(x-x0),[-1,1.5])

axis equal
axis([-2 2 -2 2])

%% 17. (b) feladat

syms x y real
syms f(x)

figure, hold on
ezplot(y^4 + 3*y - 4*x^3 == 5*x + 1)

x0 = 1;
y0 = -2;
dy0 = (5 + 12 * x0^2) / (4*y0^3 + 3);

ezplot(y0 + dy0*(x-x0),[-1,4])

axis equal
axis([-2 2 -2 2]*3)

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
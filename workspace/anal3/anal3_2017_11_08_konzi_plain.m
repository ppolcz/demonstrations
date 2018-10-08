%% Anal3 matlab konzi, 2017. november 7.
%%
syms x y z real

r = [x;y;z]
F = [
    y*z + 2
    x*z
    x*y
    ]
potential(F,r)
%%
b = 1;
c = 1;
f = @(t,x) [
    x(2)
    -b * x(2) - c*x(1) + exp(-t)
    ];

x0 = [
    -1
    1
    ];

[t,x] = ode45(f, [0 10], x0);

plot(x(:,1),x(:,2))
xlabel y
ylabel p
%%
syms t b c y p
x = [ y ; p ];

f = [
    p
    -b * p - c*y + exp(-t)
    ]
f = subs(f, [b c], [1 2])
f_fh = matlabFunction(f,'vars',{ t x })
[t,x] = ode45(f_fh,[0,10],x0);
plot(x(:,1),x(:,2))
xlabel y
ylabel p
%% 
% Numerikus integralas
%%
f = @(x) x.^2;

integral(f,0,2)
f = @(x,y) x.^2 + y.^2;
integral2(f,-1,1,@(x) -sqrt(1 - x.^2), @(x) sqrt(1 - x.^2))
f = @(x,y,z) x.^2 + y.^2 + sin(z);
integral3(f,-1,1,@(x) -sqrt(1 - x.^2), @(x) sqrt(1 - x.^2), ...
    @(x,y) -sqrt(1 - x.^2 - y.^2), @(x,y) sqrt(1 - x.^2 - y.^2))
f = @(y,x,z) x.^2 + y.^2 + sin(z);
integral3(f,-1,1,@(y) -sqrt(1 - y.^2), @(y) sqrt(1 - y.^2), ...
    @(y,x) -sqrt(1 - x.^2 - y.^2), @(y,x) sqrt(1 - x.^2 - y.^2))
%% 
% Szimbolikus integralas
%%
syms x y z C real

f = 1 / sqrt(x^2/C^2 - 1)
int(f,x), rewrite(acosh(x),'log')
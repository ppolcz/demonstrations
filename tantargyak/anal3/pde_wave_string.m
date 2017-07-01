%% 
%  
%  file:   pde_wave_string.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.17. Saturday, 16:58:20
%

% fname: full path of the actual file
pcz_cmd_fname('fname'); stack = dbstack;
if ~ismember('publish', {stack.name}), persist = pcz_persist(fname); end
%persist.backup();

%% Kezdeti feltétel

A = 1;
a = 1;

f1 = @(x) A*(1 - abs(x)/a) .* rectangularPulse(-a,a,x);
fplot(f1,[-3*a,3*a]), axis equal, hold on

%% 

f2 = @(x) A*(abs(x - 2*a)/a - 1) .* rectangularPulse(a,3*a,x);

x = linspace(-a,3*a,1000);
plot(x,f2(x)), axis equal

%%

f = @(x) f1(x)+f2(x);
fper = @(x) f(mod(x+a,4*a)-a);

x = linspace(-a,3*a,1000);
plot(x,f(x)), axis equal, hold on
plot(x,fper(x))

%%
T = 10;
tspan = linspace(0,T,1000);

c = 5;
x = linspace(-a,a,30);

figure
for i = 1:numel(tspan)
    t = tspan(i);
    plot(x, (fper(x+c*t) + fper(x-c*t) )/2),
    axis([-a a -A A])
    drawnow
%     pause(0.01)
end


%% Kezdeti feltétel

A = 0.2;
a = 1;

finit = @(x) A*(1 - abs(x)/a);
finit = @(x) A*(sin(pi*x/a) + sin(2*pi*x/a));
finit = @(x) A*(sin(pi*x/a) + sin(2*pi*x/a + pi/3));
finit = @(x) A*(sin(3*pi*x/a) + sin(5*pi*x/a));
finit = @(x) A*(sin(3*pi*x/a) + sin(5*pi*x/a + pi/4));

f1 = @(x) finit(x) .* rectangularPulse(-a,a,x);
f1per = @(x) f1(mod(x+a,2*a)-a);

figure('Position', [665 553 1115 422]), subplot(121)
x = linspace(-2*a,2*a,1000);
plot(x,f1(x)), axis equal, hold on
plot(x,f1per(x))

T = 10;
tspan = linspace(0,T,1000);

c = 5;
x = linspace(-a,a,100);

subplot(122)
for i = 1:numel(tspan)
    t = tspan(i);
    plot(x, (f1per(x+c*t) + f1per(x-c*t) )/2),
    axis([-a a -1 1])
    drawnow
%     pause(0.01)
end


%% Kezdeti feltétel

A = 1;
a = 1;

finit = @(x) A*(1 - abs(x)/a);
finit = @(x) A*sin(pi*x/a/2);
finit = @(x) A*(sin(pi*x/a/2) + sin(3*pi*x/a/2));
% finit = @(x) A*(sin(pi*x/a) + sin(2*pi*x/a + pi/3));
% finit = @(x) A*(sin(3*pi*x/a) + sin(5*pi*x/a));
% finit = @(x) A*(sin(3*pi*x/a) + sin(5*pi*x/a + pi/4));

f1 = @(x) finit(x) .* rectangularPulse(-a,a,x) - finit(x-2*a) .* rectangularPulse(a,3*a,x);
f1per = @(x) f1(mod(x+a,4*a)-a);

figure('Position', [665 553 1115 422]), subplot(121)
x = linspace(-5*a,5*a,1000);
plot(x,f1(x)), axis equal, hold on
plot(x,f1per(x))
%%
T = 10;
tspan = linspace(0,T,1000);

c = 5;
x = linspace(-a,a,100);

subplot(122)
for i = 1:numel(tspan)
    t = tspan(i);
    plot(x, (f1per(x+c*t) + f1per(x-c*t) )/2),
    axis([-a a -1 1])
    drawnow
%     pause(0.01)
end
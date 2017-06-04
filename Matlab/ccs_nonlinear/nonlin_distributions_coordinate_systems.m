%% Script nonlin_distributions_coordinate_systems
%  
%  file:   nonlin_distributions_coordinate_systems.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.04. Sunday, 14:57:05
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

syms x y theta r real
assume(in(r,'real') | in(r,'positive'))

Zi = [x;y];
Zip = [r;theta];

R = [sqrt(x^2 + y^2) ; atan(y/x) ];
J = jacobian(R, Zi);

Rp = [r*cos(theta) ; r*sin(theta)];
Jp = jacobian(Rp, Zip);

% simplify(subs(simplify(subs(Jp * J, Zi, Rp)), sign(r), 1))
% simplify(subs(simplify(subs(Jp * J, Zip, R)), sign(r), 1))

f = [
    -y
    x
    ];

g = [
    x
    y
    ] / sqrt(x^2 + y^2);

br_fg = simplify(jacobian(g,Zi)*f - jacobian(f,Zi)*g)

f = matlabFunction(f,'vars',{'t' Zi});
g = matlabFunction(g,'vars',{'t' Zi});

figure, hold on
for h = linspace(0.05,0.5,10)
    x0 = [0.1,0];
    N = 1000;
    [~,p1] = ode45(f, linspace(0,h,N), x0);
    [~,p2] = ode45(g, linspace(0,h,N), p1(end,:)');
    [~,p3] = ode45(@(t,x) -f(-t,x), linspace(0,h,N), p2(end,:)');
    [~,p4] = ode45(@(t,x) -g(-t,x), linspace(0,h,N), p3(end,:)');
    
    plot(p1(:,1),p1(:,2)),
    plot(p2(:,1),p2(:,2)),
    plot(p3(:,1),p3(:,2)),
    plot(p4(:,1),p4(:,2)),
end


%% Cycloid coordinate system

syms x y t r real
assume(in(r,'real') | in(r,'positive'))

Z = [x;y];
Zp = [r;t];

R = [
    r*(t-sin(t))
    r*(1-cos(t))
    ];

J = jacobian(R,Zp)



%%

syms x1 x2 x3 real
x = [x1;x2;x3];

tau1 = [
    cos(x3)
    sin(x3)
    0
    ];
tau2 = [
    0
    0
    1
    ];

jacobian(tau2,x)*tau1 - jacobian(tau1,x)*tau2


f = @(t,x) [
    sin(x(1))
    cos(x(2))
    ];
g = @(t,x) [
    -cos(x(1))
    sin(x(2))
    ];

figure, hold on
for h = linspace(0.05,0.5,10)
    x0 = [1,1];
    N = 1000;
    [~,p1] = ode45(f, linspace(0,h,N), x0);
    [~,p2] = ode45(g, linspace(0,h,N), p1(end,:)');
    [~,p3] = ode45(@(t,x) -f(-t,x), linspace(0,h,N), p2(end,:)');
    [~,p4] = ode45(@(t,x) -g(-t,x), linspace(0,h,N), p3(end,:)');
    
    plot(p1(:,1),p1(:,2)),
    plot(p2(:,1),p2(:,2)),
    plot(p3(:,1),p3(:,2)),
    plot(p4(:,1),p4(:,2)),
end


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
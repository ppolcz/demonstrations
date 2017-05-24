%% Script mintazh1
%  
%  file:   mintazh1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.05.24. Wednesday, 21:41:55
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

%% 1. feladat

beta = 8/3;
rho = 28;
sigma = 10;
T = 25;

f = @(t,x) [
    sigma*(x(2) - x(1))
    x(1)*(rho-x(3)) - x(2)
    x(1)*x(2) - beta*x(3)
    ];

[t,x] = ode45(f,[0,T],[1;1;1]);

subplot(221)
plot(t,x)

subplot(222), hold on
% plot3(x(:,1),x(:,2),x(:,3),'.')

for i = 1:T
    xi = x(i-1 < t & t <= i,:);
    plot3(xi(:,1),xi(:,2),xi(:,3),'.','Color',[1-i/25 i/25 i/25])
end
view([15 20]), grid on



[x,y] = meshgrid(-5:0.1:5);
z = sin(x).*cos(y) + x/10 - y/10;

subplot(223)
surfc(x,y,z), view([-110 30])


subplot(224)
z(0 < z & z < 1) = 0.5;
meshc(x,y,z), view([-110 30])

%% 2. feladat

mu = 1;
f = @(t,x) [
    x(2)
    mu*(1-x(1)^2)*x(2) - x(1)
    ];

[t,x] = ode45(f, [0,20],[0.1;0.1]);

plot(x(:,1), x(:,2)), hold on

[x,p] = meshgrid(-3:0.5:3);
fx = p;
fp = mu*(1 - x.^2).*p - x;

quiver(x,p,fx,fp);

%% 3. feladat

fileID = fopen('uvwhgt.csv','r');
data = fscanf(fileID,'%s,',4);
data = fscanf(fileID,'%f,%f,%f,%f\n',[4,Inf]);
fclose(fileID);


fileID = fopen('domborzat.csv','r');
data = fscanf(fileID,'%s,',3);
data = fscanf(fileID,'%f,%f,%f\n',[3,Inf]);
fclose(fileID);

S = [51 51];
x = reshape(data(1,:),S);
y = reshape(data(2,:),S);
z = reshape(data(3,:),S);

surf(x,y,z)

load('szinek.mat')

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
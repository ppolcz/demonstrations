%%
% dx = f(t,x)

mu = 1;

f = @(t,x) [
    x(2)
    mu*(1 - x(1)^2)*x(2) - x(1)
    ];

[t,x] = ode45(f,[0 20],[0.1;0.1]);

plot(x(:,1),x(:,2))

%%

x = 0:0.1:10;

f = sin(x);
g = exp(-1./x.^2);

plot(x,[f;g])

%%

t = readtable('tablazat.csv','ReadVariableNames',true,'Delimiter',',')

summary(t)

%% 

fid = fopen('array','r');
N = fscanf(fid,'%f',1);
t = fscanf(fid,'%f ',N)
x = fscanf(fid,'%f ',N)
y = fscanf(fid,'%f,',N)
fclose(fid);

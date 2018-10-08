%% Elfajzott tórusz korrigált
%  Blazsek Martin János
%  File: elfajzott_torusz_korrigalt
%% 

R = 5;
a = 2;

%r = @(p,t) a*(t-pi);
r = @(p,t) (a/2).*(1-cos(t));
x = @(p,t) (R+r(p,t).*cos(p)).*cos(t);
y = @(p,t) (R+r(p,t).*cos(p)).*sin(t);
z = @(p,t) r(p,t).*sin(p);
fsurf(x,y,z, [-pi pi 0 2*pi]);
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
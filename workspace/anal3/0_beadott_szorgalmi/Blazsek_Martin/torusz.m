%% Tórusz
%  Blazsek Martin János
%  File: torus
%%

R = 5;
r = 2;

x = @(p,t) (R+r.*cos(p)).*cos(t);
y = @(p,t) (R+r.*cos(p)).*sin(t);
z = @(p,t) r.*sin(p);
fsurf(x,y,z, [-pi pi 0 2*pi]);
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');

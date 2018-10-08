%% Elfajzott tórusz alternatív
%  Blazsek Martin János
%  File: elfajzott_torusz_alternativ
%%
R = 5;
r = 2;

x = @(u,v) (R+r*(2+sin(u/2).*cos(v))).*cos(u);
y = @(u,v) (R+r*(2+sin(u/2).*cos(v))).*sin(u);
z = @(u,v) r*sin(u/2).*sin(v);
fsurf(x,y,z, [-pi pi 0 2*pi]);
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
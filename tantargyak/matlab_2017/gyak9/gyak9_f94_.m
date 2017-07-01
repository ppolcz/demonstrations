function [abrak]=gyak9_f94_()
%%

t = readtable('geodata.csv','ReadVariableNames', 1, 'Delimiter', '\t');
S = [33 45];

X = reshape(t.X, S);
Y = reshape(t.Y, S);
Z = reshape(t.Z, S);

f = figure; hold on;
demcmap(Z)
surf(X,Y,Z)

[Nx,Ny,Nz] = surfnorm(X,Y,Z);
quiver3(X,Y,Z,Nx,Ny,Nz,'m')

view([-15 60])

print(f,'-dpng','-zbuffer','-r300','surf2.png')

end
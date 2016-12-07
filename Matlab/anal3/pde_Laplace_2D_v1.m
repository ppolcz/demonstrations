%% 
%  
%  file:   pde_Laplace_2D_v1.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.07. Wednesday, 15:58:30
%

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Szimpla

%%% Geometry

polygon = [
     0  1  0
     1  1  0
     1 -1  0
    -1 -1  0
    -1  0  0.2
     0  0  -0.2 ];

pdeGeom = geomDataFromPolygon(polygon(:,1:2));

%%% PDE model
% Create a PDE Model with a single dependent variable
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

geometryFromEdges(pdem,pdeGeom);

% Plot the geometry and display the edge labels for use in the
% boundary condition definition.
figure;
pdegplot(pdem, 'edgeLabels', 'on');
axis equal
title 'Geometry With Edge Labels Displayed';

for i = 1:size(polygon,1);
    applyBoundaryCondition(pdem,'Edge', i, 'u', polygon(i,3));
end

%%%  Mesh
msh = generateMesh(pdem,'Hmax',0.04);
figure;
pdemesh(pdem);
axis equal

[p,~,t] = meshToPet(msh);

[u] = assempde(pdem,1,0,0);

figure, hold on
trisurf(t(1:3,:)',p(1,:)',p(2,:)',u),
shading interp,
light
axis vis3d

edge = polygon(repmat(1:size(polygon,1),[2,1]), :);
edge = [edge(:,1:2) , circshift(edge(:,3),1)];
edge = [edge ; edge(1,:)];
plot3(edge(:,1), edge(:,2), edge(:,3),'r', 'LineWidth', 3)

%% Extras

%%% Geometry

polygon = [
     0  1  0
     1  1  NaN
     1 -1  NaN
    -1 -1  0
    -1  0  0.2
     0  0  -0.2 ];

pdeGeom = geomDataFromPolygon(polygon(:,1:2));

%%% PDE model
% Create a PDE Model with a single dependent variable
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

geometryFromEdges(pdem,pdeGeom);

% Plot the geometry and display the edge labels for use in the
% boundary condition definition.
figure;
pdegplot(pdem, 'edgeLabels', 'on');
axis equal
title 'Geometry With Edge Labels Displayed';

for i = 1:size(polygon,1);
    applyBoundaryCondition(pdem,'Edge', i, 'u', polygon(i,3));
end

bcfun2 = @(x,y) 0.05*sin(-2*pi*y);
bcfun2if = @(region,state) bcfun2(region.x, region.y);

bcfun3 = @(x,y) -0.2*(x.^2-1);
bcfun3if = @(region,state) bcfun3(region.x, region.y);

%%% Non-constant Dirichlet boundary condition
% # $u = f$ on the boundaries. |u|
% # $hu = r$ on the boundaries. |h|, |r|
applyBoundaryCondition(pdem,'Edge', 2, 'r', bcfun2if, 'h', 1);
applyBoundaryCondition(pdem,'Edge', 3, 'u', bcfun3if);
applyBoundaryCondition(pdem,'Edge', 4, 'q', 1, 'g', -0.1);


%%%  Mesh
msh = generateMesh(pdem,'Hmax',0.04);
figure;
pdemesh(pdem);
axis equal

[p,~,t] = meshToPet(msh);

[u] = assempde(pdem,1,0,0);

figure, hold on
trisurf(t(1:3,:)',p(1,:)',p(2,:)',u),
shading interp,
light
axis vis3d

edge = polygon(repmat(1:size(polygon,1),[2,1]), :);
edge = [edge(:,1:2) , circshift(edge(:,3),1)];
edge = [edge ; edge(1,:)];
plot3(edge(:,1), edge(:,2), edge(:,3),'r', 'LineWidth', 3)

x = linspace(-1,1,100);
plot3(x*0+1,x,bcfun2(x,x),'r', 'LineWidth', 3);
plot3(x,x*0-1,bcfun3(x,x),'r', 'LineWidth', 3);

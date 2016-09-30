%% Minimal Surface Problem on the Unit Disk
% 
% Ezt a példát a
% <http://www.mathworks.com/help/pde/examples/minimal-surface-problem-on-the-unit-disk.html
% MathWorks> oldaláról töltöttem le és írtam át demonstráció végett.
% 
% This example shows how to solve a nonlinear elliptic problem numerically,
% using the |pdenonlin| function in Partial Differential Equation
% Toolbox(TM).
%
% In many problems, the coefficients not only depend on spatial
% coordinates, but also on the solution itself. In toolbox wording, this
% kind of problem is called nonlinear. An example of this is the minimal
% surface equation
%
% $$-\nabla \cdot \left( \frac{1}{\sqrt{1 + \left|\nabla u\right|^2}} \nabla u \right) = 0$$
%
% on the unit disk, with 
%
% $u(x,y) = \sin(3x)\cos(3y)$ 
%
% on the boundary. The PDE coefficient |c| is the multiplier of $\nabla u$, namely
%
% $$\frac{1}{\sqrt{1 + \left|\nabla u\right|^2}}$$
%
% |c| is a function of the solution $u$, so the problem is nonlinear.

%       Copyright 1994-2014 The MathWorks, Inc.
 
%% Problem Definition
% The following variables define the problem:
%
% information, see the documentation page for |circleg| and |pdegeom|.
% * |c|, |a|, |f|: The coefficients of the PDE. Note that |c| is a
% character array. For more information on passing coefficients into
% |pdenonlin|, see the documentation page for |assempde|.
% * |rtol|: Tolerance for nonlinear solver.

c = '1./sqrt(1+ux.^2+uy.^2)';
a = 0;
f = 0;
rtol = 1e-3;

%% Geommetry

% Create a PDE Model with a single dependent variable
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

% Create a geometry entity and append to the pde model
pdeGeom = @circleg;
geometryFromEdges(pdem,pdeGeom);

% Plot the geometry and display the edge labels for use in the boundary condition definition.
figure; 
pdegplot(pdem, 'edgeLabels', 'on');
axis equal
title 'Geometry With Edge Labels Displayed';

%% Boundary Conditions
bc_fh = @(x,y) sin(3*x).*cos(3*y);
bcFunc = @(thePde, loc, state) bc_fh(loc.x,loc.y);
applyBoundaryCondition(pdem,'Edge',(1:4), 'u', bcFunc);

%% Generate Mesh
msh = generateMesh(pdem,'Hmax',0.02);
figure; 
pdemesh(pdem); 
axis equal
 
%% Solve PDE
% Because the problem is nonlinear, we solve it using the |pdenonlin| function.
u = pdenonlin(pdem,c,a,f,'tol',rtol, 'Jacobian', 'full', 'Report', 'on');
 
%% Plot Solution

% Ennek segitsegevel lehet visszakerni a celtartomany hatarainak koordinatait
figure,
h = pdegplot(pdeGeom);
x1 = h.XData;
x2 = h.YData;
delete(h), close;

% Koordinata rendszer kialakitasa, stb...
fig = figure('InvertHardcopy','off','Color',[1 1 1], ...
    'Units', 'normalized', 'Position', [0 0 0.6 1]);
ax = axes('Parent',fig,'LineWidth',2,'FontSize',16,...
    'FontName','TeX Gyre Schola Math',...
    'DataAspectRatio',[1 1 1]);
hold(ax, 'on');
axis(ax, 'tight');
colorbar, 
light('Parent', ax)
view(ax,[135,32]);
grid(ax,'on');
xlabel('$x_1$','FontSize',30,'Interpreter','latex');
ylabel('$x_2$','FontSize',30,'Interpreter','latex');
zlabel('$x_3$','FontSize',30,'Interpreter','latex');

% Felulet kirajzolasa
trisurf(msh.Elements', msh.Nodes(1,:)', msh.Nodes(2,:)', u, 'facealpha', 1);
shading interp

% Drotkeret kirajzolasa
plot3(x1,x2,bc_fh(x1,x2), 'r', 'LineWidth', 4)

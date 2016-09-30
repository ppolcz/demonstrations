%% Minimal Surface Problem on an Arbitrarily Shaped Region
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
% Boundary conditions:
% 
% $u(x,y) = \sin(3x)\cos(3y)$ (outer condition)
% 
% $u(x,y) = 0$ (inner condition)
% 
% The PDE coefficient |c| is the multiplier of $\nabla u$, namely
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
L = 1;
nHoles = 1;
R = L/(2+2*nHoles+(nHoles-1));
xyRect = [-L/2 -L/2; L/2 -L/2; L/2 L/2; -L/2 L/2];

holes = zeros(nHoles*nHoles,3);
holeCounter =1;
x = -L/2 + 2*R;
for i = 1:nHoles
    y = -L/2 + 2*R;
    for j = 1:nHoles
        holes(holeCounter,:) = [x y R];
        holeCounter = holeCounter + 1;
        y = y + 3*R;
    end
    x = x+3*R;
end
pdeGeom = [geomDataFromPolygon(xyRect) geomDataOfCircularHoles(holes)];
geometryFromEdges(pdem,pdeGeom);

% Plot the geometry and display the edge labels for use in the boundary
% condition definition.
figure;
pdegplot(pdem, 'edgeLabels', 'on');
axis equal
ptitle 'Geometry With Edge Labels Displayed';

%% Boundary Conditions
bc_outer_fh = @(x,y) sin(3*x).*cos(3*y);
bc_inner_fh = @(x,y) x*0;
applyBoundaryCondition(pdem,'Edge',(1:4), 'u', @(~,r,~) bc_outer_fh(r.x,r.y));
applyBoundaryCondition(pdem,'Edge',(5:8), 'u', @(~,r,~) bc_inner_fh(r.x,r.y));

%% Generate Mesh
msh = generateMesh(pdem,'Hmax',0.02);
figure;
pdemesh(pdem);
axis equal

%% Solve PDE
% Because the problem is nonlinear, we solve it using the |pdenonlin|
% function.
u = pdenonlin(pdem,c,a,f,'tol',rtol, 'Jacobian', 'full', 'Report', 'on');

%% Plot Solution

% Ennek segitsegevel lehet visszakerni a celtartomany hatarainak koordinatait
figure,
h = pdegplot(pdeGeom(:,1:4));
x1_outer = h.XData;
x2_outer = h.YData;
delete(h), close;
figure,
h = pdegplot(pdeGeom(:,5:8));
x1_inner = h.XData;
x2_inner = h.YData;
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
view(ax,[-141,24]);
grid(ax,'on');
xlabel('$x_1$','FontSize',30,'Interpreter','latex');
ylabel('$x_2$','FontSize',30,'Interpreter','latex');
zlabel('$x_3$','FontSize',30,'Interpreter','latex');

% Felulet kirajzolasa
trisurf(msh.Elements', msh.Nodes(1,:)', msh.Nodes(2,:)', u, 'facealpha', 1);
shading interp

% Drotkeret kirajzolasa
plot3(x1_outer,x2_outer,bc_outer_fh(x1_outer,x2_outer), 'r', 'LineWidth', 4)
plot3(x1_inner,x2_inner,bc_inner_fh(x1_inner,x2_inner), 'r', 'LineWidth', 4)

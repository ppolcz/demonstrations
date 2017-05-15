%%
%
%  file:   pde_minimal_surface_arbgeom.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.03. Saturday, 18:40:36
%
%%
%
%  file:   pde_minimal_surface_unit_disc.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.02. Friday, 14:03:56
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_PjzxHKNoJIigzXrElNnA = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Minimal Surface Problem on the Unit Disk
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
% $u(x,y) = x^2$
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
title 'Geometry With Edge Labels Displayed';

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

% Create figure
fig = figure('InvertHardcopy','off','Color',[1 1 1]);

% Create axes
ax = axes('Parent',fig,'LineWidth',2,'FontSize',30,...
    'FontName','TeX Gyre Schola Math',...
    'PlotBoxAspectRatio',[1.73581081081081 2.425 1],...
    'DataAspectRatio',[1 1 1]);
hold(ax, 'on');
axis(ax, 'tight');

trisurf(msh.Elements', msh.Nodes(1,:)', msh.Nodes(2,:)', u, 'facealpha', 1);
colorbar
shading interp
light

% Drotkeret kirajzolasa
plot3(x1_outer,x2_outer,bc_outer_fh(x1_outer,x2_outer), 'r', 'LineWidth', 4)
plot3(x1_inner,x2_inner,bc_inner_fh(x1_inner,x2_inner), 'r', 'LineWidth', 4)

% xlim(axes1,[-1 1.569]);
% ylim(axes1,[-0.973 2.616]);
% zlim(axes1,[-0.727 0.753]);
view(ax,[-141,24]);
% box(axes1,'on');
grid(ax,'on');

% Create light
light('Parent',ax);

% Create xlabel
xlabel('$x_1$','FontSize',30,'Interpreter','latex');

% Create ylabel
ylabel('$x_2$','FontSize',30,'Interpreter','latex');

% Create zlabel
zlabel('$x_3$','FontSize',30,'Interpreter','latex');

% Create legend
% legend1 = legend(' \alpha level set of V(x)');
% set(legend1,'Position',[0.56675173074133 0.241263083976993 0.213194451418188 0.0484272476147948],...
%     'FontSize',30,...
%     'EdgeColor',[0.945098042488098 0.968627452850342 0.949019610881805]);

%% end of the scope
pcz_dispFunctionEnd(TMP_PjzxHKNoJIigzXrElNnA);
clear TMP_PjzxHKNoJIigzXrElNnA
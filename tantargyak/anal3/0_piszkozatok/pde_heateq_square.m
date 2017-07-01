%% 
%  
%  file:   pde_heateq_square.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.03. Saturday, 19:30:24
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_qGlEFFxbAvfxxCPKTclx = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Inhomogeneous Heat Equation on a Square Domain
% This example shows how to solve the heat equation with a source term
% using the |parabolic| function in the Partial Differential Equation
% Toolbox(TM).
%
% The basic heat equation with a unit source term is
%
% $$\frac{\partial u}{\partial t} - \Delta u = 1$$
%
% This is solved on a square domain with a discontinuous initial condition and zero
% Dirichlet boundary conditions.

% Copyright 1994-2014 The MathWorks, Inc.


%% Problem Definition
% * |g|: A specification function that is used by |initmesh|. For more
% information, please see the documentation page for |squareg| and |pdegeom|.
% * |c|, |a|, |f|, |d|: The coefficients of the PDE.
g = @squareg;
c = 1;
a = 0;
f = 1;
d = 1;

%% Create a PDE Model with a single dependent variable
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

%% Create a geometry and append it to the PDE Model
geometryFromEdges(pdem,g);

%% Apply Boundary Conditions

% Plot the geometry and display the edge labels for use in the boundary
% condition definition.
figure
pdegplot(pdem, 'edgeLabels', 'on'); 
axis([-1.1 1.1 -1.1 1.1]);
title 'Geometry With Edge Labels Displayed'

% Solution is zero at all four outer edges of the square
applyBoundaryCondition(pdem,'Edge',(1:4), 'u', 0);


%% Generate Mesh
msh = generateMesh(pdem);
figure;
pdemesh(pdem); 
axis equal

%% Generate Initial Conditions
% The discontinuous initial value is 1 inside a circle of radius 0.4 and
% zero outside.
[p,~,t] = meshToPet(msh);
u0 = zeros(size(p,2),1);
ix = find(sqrt(p(1,:).^2+p(2,:).^2)<0.4);
u0(ix) = ones(size(ix));

%% Generate Time Discretization
% We want the solution at 20 points in time between 0 and 0.1.
nframes = 100;
tlist = linspace(0,1,nframes);

%% Find FEM Solution
u1 = parabolic(u0,tlist,pdem,c,a,f,d);

%% Plot FEM Solution
% To speed up the plotting, we interpolate to a rectangular grid.
figure
colormap(cool);
x = linspace(-1,1,31);
y = x;
[~,tn,a2,a3] = tri2grid(p,t,u0,x,y);
umax = max(max(u1));
umin = min(min(u1));
for j = 1:nframes,
    u = tri2grid(p,t,u1(:,j),tn,a2,a3);
    i = find(isnan(u));
    u(i) = zeros(size(i));
    surf(x,y,u);
    caxis([umin umax]);
    axis([-1 1 -1 1 0 1]);
    shading interp;
    Mv(j) = getframe;
end
movie(Mv,1);

%% end of the scope
pcz_dispFunctionEnd(TMP_qGlEFFxbAvfxxCPKTclx);
clear TMP_qGlEFFxbAvfxxCPKTclx
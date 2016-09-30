%% 
%  
%  file:   pde_heat_transfer_regi.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.02. Friday, 13:48:39
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_aOQTeunPwVjnhhTEChSG = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%%

% Create a PDE Model with a single dependent variablenumberOfPDE = 1;
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

% GeometryTo construct the geometry we create one rectangle the size of the block and a second
% rectangle the size of the slot.
r1 = [3 4 -.5 .5 .5 -.5  -.8 -.8 .8 .8];
r2 = [3 4 -.05 .05 .05 -.05  -.4 -.4 .4 .4];
gdm = [r1; r2]';

% Subtract the second rectangle from the first to create the block with a slot.
g = decsg(gdm, 'R1-R2', ['R1'; 'R2']'); 

% Convert the decsg format into a geometry objectThe geometry is appended to the PDEModel
geometryFromEdges(pdem,g); 

% Plot the geometry with edge labels displayed. The edge labels will be used below in the function
% for defining boundary conditions.
figure
pdegplot(pdem, 'edgeLabels', 'on');
axis([-.9 .9 -.9 .9]);
title 'Block Geometry With Edge Labels Displayed'

% MeshCall the generateMesh method  to create a mesh with elements no larger than about 0.2.
hmax = .2; % element size
msh=generateMesh(pdem,'Hmax', hmax);
figure
pdeplot(pdem);
axis equal
title 'Block With Finite Element Mesh Displayed'

% PDE Coefficients and Boundary ConditionsBoundary conditions are defined below. For the steady
% state cases, we set the temperature on the left edge to 100 degrees. In the transient cases, the
% temperature on the left edge is zero at time=0 and ramps to 100 degrees over .5 seconds. On the
% right edge, there is a prescribed heat flux out of the block. The top and bottom edges as well as
% the edges inside the cavity are all insulated, i.e. no heat is transferred across these
% edges.
uRight = applyBoundaryCondition(pdem, 'Edge', 1, 'g', -10);
uLeft = applyBoundaryCondition(pdem, 'Edge', 6, 'u', @boundaryFileHeatedBlock);

% Coefficient DefinitionWe will first consider the case where the material properties are simple
% scalars, all equal one. We will later consider a case where the thermal conductivity is a function
% of temperature.
rho = 1; % density
Cp = 1; % specific heat
k = 1; % thermal conductivity

c = k;
a = 0;
f = 0;
d = rho*Cp;

% Steady State SolutionFirst calculate the steady-state solution. We want to compare this with the
% solution obtained below from a transient analysis.
u = assempde(pdem, c, a, f);
figure
pdeplot(pdem, 'xydata', u, 'contour', 'on', 'colormap', 'hot');
axis equal
title 'Temperature, Steady State Solution'

% Transient SolutionPerform a transient analysis from zero to five seconds. The solution will be
% saved every .1 seconds so that plots of the results as functions of time can be created.
tlist = 0:.1:5;
u0 = 0;
u = parabolic(u0, tlist, pdem, c, a, f, d);

% 139 successful steps
% 4 failed attempts
% 288 function evaluations
% 1 partial derivatives
% 33 LU decompositions
% 287 solutions of linear systems

% Two plots are useful in understanding the results from this transient analysis. The first is a
% plot of the temperature at the final time. The second is a plot of the temperature at a specific
% point in the block, in this case near the center of the right edge, as a function of time. To
% identify a node near the center of the right edge, it is convenient to define this short utility
% function.
getClosestNode = @(p,x,y) min((p(1,:) - x).^2 + (p(2,:) - y).^2); 
% Call this function to get a node near the center of the right edge.
[~,nid] = getClosestNode( msh.Nodes, .5, 0 );

% The two plots are shown side-by-side in the figure below.
h = figure;
h.Position = [1 1 2 1].*h.Position;
subplot(1,2,1);
axis equal
pdeplot(pdem, 'xydata', u(:,end), 'contour', 'on', 'colormap', 'hot');
axis equal
title 'Temperature, Final Time, Transient Solution'
subplot(1,2,2);
axis equal
plot(tlist, u(nid,:));
grid on
title 'Temperature at Right Edge as a Function of Time';
xlabel 'Time, seconds'
ylabel 'Temperature, degrees-Celsius'

% As can be seen, the temperature distribution at this time is very similar to that obtained from
% the steady-state solution above. At the right edge, for times less than about one-half second, the
% temperature is less than zero. This is because heat is leaving the block faster than it is
% arriving from the left edge. At times greater than about three seconds, the temperature has
% essentially reached steady-state.Steady State Solution (Temperature-Dependent Thermal
% Conductivity)It is not uncommon for material properties to be functions of the dependent
% variables. In this case we will assume that the thermal conductivity is a simple linear function
% of temperature. The most convenient way to define this function is by using a string expression:
k = '.3+.003*u'; 

% In this case, the variable u is the temperature. We will assume that the density and specific heat
% are not functions of temperature but, if they were temperature-dependent, these coefficients could
% also be defined as string expressions.
c = k; 

% Because the c-coefficient is a function of the dependent variable, we now have a nonlinear PDE and
% the pdenonlin function must be used to calculate the solution.
u = pdenonlin(pdem, c, a, f, 'Jacobian', 'full', 'U0', u(:,end));
figure
pdeplot(pdem, 'xydata', u, 'contour', 'on', 'colormap', 'hot');
axis equal
title 'Temperature, Steady State Solution (Nonlinear)'

% As can be seen, compared with the constant-conductivity case, the temperature on the right-hand
% edge is lower. This is due to the lower conductivity in regions with lower temperature.Transient
% Solution (Temperature-Dependent Thermal Conductivity)We now perform a transient analysis with the
% temperature-dependent conductivity. The parabolic function can be used for both linear and
% nonlinear analyses. Just as for the linear case, the timespan is from zero to five secondsu =
% parabolic(u0, tlist, pdem, c, a, f, d);

% 170 successful steps
% 26 failed attempts
% 328 function evaluations
% 21 partial derivatives
% 60 LU decompositions
% 327 solutions of linear systems

% Again we will plot the temperature at the final time and the temperature at the right edge as a
% function of time. These two plots are shown side-by-side in the figure below.
h = figure;
h.Position = [1 1 2 1].*h.Position;
subplot(1,2,1);
axis equal
pdeplot(pdem, 'xydata', u(:,end), 'contour', 'on', 'colormap', 'hot');
axis equal
title 'Temperature, Final Time, Transient Solution (Nonlinear)'
subplot(1,2,2);
axis equal
plot(tlist(1:size(u,2)), u(nid,:));
grid on
title 'Temperature at Right Edge as a Function of Time (Nonlinear)';
xlabel 'Time, seconds'
ylabel 'Temperature, degrees-Celsius'

% The plot of temperature at the final time is only slightly different from the comparable plot from
% the linear analysis; temperature at the right edge is slightly lower than the linear case. The
% plot of temperature as a function of time is considerably different from the linear case. Because
% of the lower conductivity at lower temperatures, the heat takes longer to reach the right edge of
% the block. In the linear case, the temperature is essentially constant at around three seconds but
% for this nonlinear case, the temperature curve is just beginning to flatten at five seconds.



%% end of the scope
pcz_dispFunctionEnd(TMP_aOQTeunPwVjnhhTEChSG);
clear TMP_aOQTeunPwVjnhhTEChSG
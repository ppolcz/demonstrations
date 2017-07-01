%% 
%  
%  file:   pde_vibration_unit_disc.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.03. Saturday, 19:10:46
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_iHMHxCpMjJjtGOeWOzwx = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Vibration Of a Circular Membrane Using The MATLAB eigs Function
%
% This example shows the calculation of the vibration modes of a circular
% membrane. The calculation of vibration modes requires the solution of
% the eigenvalue partial differential equation (PDE).
% In this example the solution of the eigenvalue problem is performed using 
% both the PDE Toolbox(TM) |pdeeig| solver and the core MATLAB(TM) 
% |eigs| eigensolver. 
%
% The main objective of this example is to show how |eigs| can be used
% with PDE Toolbox(TM). Generally, the eigenvalues calculated by |pdeeig|
% and |eigs| are practically identical. However, sometimes, it is simply
% more convenient to use |eigs| than |pdeeig|. One example of this is when
% it is desired to calculate a specified number of eigenvalues in the
% vicinity of a user-specified target value. |pdeeig| requires that a
% lower and upper bound surrounding this target value be specified. |eigs|
% requires only that the target eigenvalue and the desired number of 
% eigenvalues be specified.

% Copyright 2013-2014 The MathWorks, Inc.

%% Create a pde entity for a PDE with a single dependent variable
numberOfPDE = 1;
pdem = createpde(numberOfPDE);

%% Geometry And Mesh
%
% The geometry for a circle can easily be defined as shown below.
radius = 2;
g = decsg([1 0 0 radius]', 'C1', ('C1')');
% Create a geometry object and append it to the PDE Model
geometryFromEdges(pdem,g);

% Plot the geometry and display the edge labels for use in the boundary
% condition definition.
figure; 
pdegplot(pdem, 'edgeLabels', 'on'); 
axis equal
title 'Geometry With Edge Labels Displayed';


generateMesh(pdem,'hmax', .2);


% [p,e,t] = initmesh(g, 'hmax', .2);

%% Define the PDE Coefficients and Boundary Conditions
c = 1e2;
a = 0;
f = 0;
d = 10;

% Solution is zero at all four outer edges of the circle
bOuter = applyBoundaryCondition(pdem,'Edge',(1:4), 'u', 0);


%% Solve the eigenvalue problem using |eigs|
%
% Use |assempde| and |assema| to calculate the global finite element mass and
% stiffness matrices.
%
[K,~,B] = assempde(pdem,c,a,f);
[~,M] = assema(pdem,c,d,f);
M = B'*M*B; % apply the constraints to the mass matrix from |assema|
sigma = 1e2; 
numberEigenvalues = 5;
[eigenvectorsEigs,eigenvaluesEigs] = eigs(K,M,numberEigenvalues,sigma);
% eigs orders the eigenvalues (and their eigenvectors) from highest to 
% lowest. Reorder these from lowest to highest to be consistent with |pdeeig|.
eigenvaluesEigs = flipud(diag(eigenvaluesEigs));
% Reorder the eigenvectors. Also transform the eigenvectors with constrained
% equations removed to the full eigenvector including constrained equations.
eigenvectorsEigs = B*fliplr(eigenvectorsEigs);

%% Solve the eigenvalue problem using |pdeeig|
%
% Define the eigenvalue range for pdeeig from the output eigenvalues
% from eigs so that it computes the same ones.
r = [eigenvaluesEigs(1)*.99 eigenvaluesEigs(end)*1.01];
[eigenvectorsPde,eigenvaluesPde] = pdeeig(pdem,c,a,d,r);

%% Compare the solutions computed by |eigs| and |pdeeig|
%
eigenValueDiff = eigenvaluesPde - eigenvaluesEigs;
fprintf('Maximum difference in eigenvalues from pdeeig and eigs: %e\n', ...
  norm(eigenValueDiff,inf));
% 
% As can be seen, both functions calculate the same eigenvalues. For any
% eigenvalue, the eigenvector can be multiplied by an arbitrary scalar.
% eigs and pdeeigs choose a different arbitrary scalar for normalizing
% their eigenvectors as shown in the figure below.
%
h = figure;
h.Position = [1 1 2 1].*h.Position;
subplot(1,2,1); 
axis equal
pdeplot(pdem,'xydata', eigenvectorsEigs(:,end), 'contour', 'on');
title(sprintf('eigs eigenvector, eigenvalue: %12.4e', eigenvaluesEigs(end)));
xlabel('x'); 
ylabel('y');
subplot(1,2,2); 
axis equal
pdeplot(pdem,'xydata', eigenvectorsPde(:,end), 'contour', 'on');
title(sprintf('pdeeig eigenvector, eigenvalue: %12.4e', eigenvaluesPde(end)));
xlabel('x'); 
ylabel('y');

displayEndOfDemoMessage(mfilename)


%% end of the scope
pcz_dispFunctionEnd(TMP_iHMHxCpMjJjtGOeWOzwx);
clear TMP_iHMHxCpMjJjtGOeWOzwx
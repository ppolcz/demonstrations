%% A Laplace egyenlet megoldása az egységnégyzeten belül
%
%  File:   pde_Laplace_2D_v2_gyaktipusu.m
%  Author: Peter Polcz (ppolcz@gmail.com)
%
%  Created on 2016.12.07. Wednesday, 15:58:30 [inherited]
%  Created on 2017. November 30.
%
%%
% <html><h1>Négyzetes peremfeltételek mellett</h1></html>

%%%
% *Az* $\Omega$ *tartomány létrhozása*. A |polygon| tömb a tartomány
% sarkait tartalmazza: első oszlop $x$, második oszlop $y$
% koordináták.
%
% Peremfeltételek:
%
% $$
% \begin{aligned}
%     &u(0,y) = 0, && u'_y(x,0) = 0,\\
%     &u(1,y) = 0, && u(x,1) = f(x).
% \end{aligned}
% $$
%
% Az |assempde| a következő alakú egyenleteket tudja megoldani:
%
% $$
%     - \nabla \cdot \left( c \nabla u \right) + a u = f
% $$
%
% Legyen $c = 1$, $a = f = 0$. Ekkor a fenti egyenletből a Laplace
% egyenletet kapjuk.
%
% A derivatív peremfeltételt egy Neumann feltételként adhatjuk meg:
% $$
%     \vec n \cdot \left( c \nabla u \right) + q u = g
% $$
%
% Ahol $\vec n$ a perem kifele mutató normálvektora. A mi esetünkben a
% felső perem ($y = 1$) esetét $\vec n = \begin{pmatrix} 0 \\ 1 \end{pmatrix}$.
% Továbbá, legyen $q = g = 0$, ekkor épp az $u'_y = 0$ feltételt
% kapjuk. Tehát a következőt kell majd használni:
% |applyBoundaryCondition(pdem,'Edge', 3, 'g', 0, 'q', 0)|.
%

polygon = [
    0  0
    0  1
    1  1
    1  0
    ];
pdeGeom = geomDataFromPolygon(polygon);

%%%
% *PDE modell.*
% Létrehozunk egy PDE modellt, ahol egyetlen függő változó van, az
% $u(x,y)$
numberOfPDE = 1;

pdem = createpde(numberOfPDE);
geometryFromEdges(pdem,pdeGeom);

figure('Position', [668 596 1012 377]); subplot(121)
pdegplot(pdem, 'edgeLabels', 'on'); axis equal
title('$\Omega$ tartomany, amelyen megoldom az egyenletet', 'Interpreter', 'latex');
plabel 'x' '$x$ tengely', plabel 'y' '$y$ tengely'


%%%
% *Peremfeltételek*
% 
% Alsó peremfeltétel: $u(0,y) = 0$
applyBoundaryCondition(pdem,'Edge', 1, 'u', 0);

%%%
% Felső peremfeltétel: $u(1,y) = 0$
applyBoundaryCondition(pdem,'Edge', 3, 'u', 0);

%%%
% Bal oldali peremfeltétel: $u'_y(x,0) = 0$
applyBoundaryCondition(pdem,'Edge', 4, 'q', 0, 'g', 0);

%%%
% Jobb oldali peremfeltétel: $u(x,1) = f(x) = x - x^2$
bcfun2 = @(x,y) x - x.^2;
bcfun2if = @(region,state) bcfun2(region.x, region.y);
applyBoundaryCondition(pdem,'Edge', 2, 'u', bcfun2if);

%%% 
% *Az* $\Omega$ *tartomány felosztása, háromszögelés.* A háromszögelés
% finomságát, sűrűségét a |generateMesh| |Hmax| tulajdonságával tudjuk
% szabályozni. A |Hmax| gyakorlatilag a háromszögek átmérőjének
% nagyságát szabályozza (megközelítőleg ekkorák lesznek a
% háromszögek.)
% 

subplot(122); axis equal
msh = generateMesh(pdem,'Hmax',0.02);
pdemesh(pdem);
plabel 'x' '$x$ tengely', plabel 'y' '$y$ tengely'
ptitle 'Triangulation'

%%
% *Megoldjuk az egyenletet.*
% 
% $$
%     - \nabla \cdot \left( c \nabla u \right) + a u = f,
% $$
%
% ahol $c = 1$, $a = f = 0$. Ekkor a fenti egyenletből a Laplace
% egyenletet kapjuk.

c = 1;
a = 0;
f = 0;
[u] = assempde(pdem,c,a,f);

%%%
% *Vizualizáció*
%
[p,~,t] = meshToPet(msh);

figure('Position', [668 220 674 753]), hold on
trisurf(t(1:3,:)',p(1,:)',p(2,:)',u,'AmbientStrength',0.9),
shading interp; axis square, view([ 233 , 34 ])
plabel 'x' '$x$ tengely', plabel 'y' '$y$ tengely'
light('Position',[5 0 1],'Style','local')
view([ 34 , 40 ])

tricontour([p(1,:)',p(2,:)'], t(1:3,:)', u, 30)


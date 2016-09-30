%%
%
%  file:   pde_geometry_examples.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.03. Saturday, 18:02:46
%

close all
global MMA_DEBUG;
global MMA_REL_TOL;
global MMA_ABS_TOL;
global MMA_FLAT_VERTEX_ON;

MMA_DEBUG = false; %set to true to MA_DEBUG
MMA_REL_TOL = 1e-6; % relative tolerance to merge nearby medial pts, etc
MMA_FLAT_VERTEX_ON = false; % set to true if you find some medial branches to be missing
                    % it will make the code run even slower!!

%% rectangle

L = 1;
H = 0.1;
xy = [0 0; L 0; L H; 0 H];
pdeGeom = geomDataFromPolygon(xy);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% a convex polygon

xy = [0 0; 1 0; 0.9999 0.1; 0.5 0.65; 0.1 0.5];
pdeGeom = geomDataFromPolygon(xy);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% L Bracket with rounded corners

L = 1;
H1 = 0.1;
H2 = 0.1;
R = 0.1;
if (R <= 0)
    xy = [0 0; L 0; L H1; H2 H1; H2 L; 0 L];
    pdeGeom = geomDataFromPolygon(xy);
else
    pdeGeom = [2 0 L 0 0 1 0 0 0 0 0; ...
        2  L L 0 H1 1 0 0 0 0 0 ; ...
        2  L (H2+R) H1  H1 1 0 0 0 0 0 ; ...
        1  H2 (H2+R) (H1+R) H1 0 1 (H2+R) (H1+R) R R; ...
        2  H2 H2 (H1+R) L 1 0 0 0 0 0 ; ...
        2  H2 0 L  L 1 0 0 0 0 0 ; ...
        2  0 0 L  0 1 0 0 0 0 0]';
end

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% rectangle with square hole

L = 1;
H = 0.4;
a = H/4;
xyRect= [-L/2 -H/2; L/2 -H/2; L/2 H/2; -L/2 H/2];
xySquare = [-a/2 -a/2; a/2 -a/2; a/2 a/2; -a/2 a/2];
xySquare(:,2) = xySquare(:,2) + a/2;
pdeGeom = [geomDataFromPolygon(xyRect)  geomDataFromPolygon(xySquare,1)];

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% rectangle with  semidisc cutout

L = 1;
h = 0.2;
r = h/3;
yc = 0;
pdeGeom = [2 -L L -h -h 1 0 0 0 0 0 ; ...
    2  L L -h  h 1 0 0 0 0 0 ; ...
    2  L -L h  h 1 0 0 0 0 0 ; ...
    2 -L -L h -h 1 0 0 0 0 0 ; ...
    2 -r  r yc yc 0 1 0 0 0 0; ...
    1 r  0 yc yc+r 0 1 0 yc r r; ...
    1 0  -r yc+r yc 0 1 0 yc r r]';

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% diverging/converging nozzle

L = 1;
h = 0.2;
g = 0.1;
if (g <= h)
    d = (h-g)/2;
    r = ((L/2)^2 + d^2)/(2*d);
    yc = sqrt(r*r-(L/2)^2) + h/2;
    pdeGeom = [2 -L/2 -L/2 h/2 -h/2 1 0 0 0 0 0 ; ...
        1 L/2 -L/2 -h/2 -h/2 0 1 0 -yc r r; ...
        2 L/2 L/2 -h/2 h/2 1 0 0 0 0 0; ...
        1 -L/2 L/2 h/2 h/2 0 1 0 yc r r]';
else
    d = (g-h)/2;
    r = ((L/2)^2 + d^2)/(2*d);
    yc = sqrt(r*r-(L/2)^2)-h/2;
    pdeGeom = [2 -L/2 -L/2 h/2 -h/2 1 0 0 0 0 0 ; ...
        1 -L/2 L/2 -h/2 -h/2 1 0 0 yc r r; ...
        2 L/2 L/2 -h/2 h/2 1 0 0 0 0 0; ...
        1 L/2 -L/2 h/2 h/2 1 0 0 -yc r r]';

end

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% T-Joint

L = 0.2;
H1 = 0.1;
H2 = 0.02;
xy = [0 0; 2*L 0; 2*L H1; L+H2/2 H1; L+H2/2 L; L-H2/2 L; L-H2/2 H1; 0 H1];
pdeGeom = geomDataFromPolygon(xy);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% U Channel

L1 = 1;
t1 = 0.2;
L2 = 1;
t2 = 0.2;
t = 0.05;
h = 0.5;
xy = [0 -h; L1 -h; L1 -t; (L1+L2) -t; (L1+L2) t; L1 t; ...
    L1 h; 0 h; 0 (h-t2); (L1-t) (h-t2); (L1-t) -(h-t1); 0 -(h-t1)];
pdeGeom = geomDataFromPolygon(xy);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% Bow-tie

L = 1;
t = 0.5;
g = 0.1;
xy = [-L/2 -t/2; 0 -g/2; L/2 -t/2; L/2 t/2; 0 g/2; -L/2 t/2];
pdeGeom = geomDataFromPolygon(xy);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% plate with circular hole

L = 1;
H = 0.1;
R = H/100;
xyRect = [-L/2 -H/2; L/2 -H/2; L/2 H/2; -L/2 H/2];
pdeGeom = [geomDataFromPolygon(xyRect) geomDataOfCircularHoles([0 0 R])];


figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% square plate with many square holes

L = 1;
nHolesX = 2;
nHolesY = 2;
aX = L/(2+nHolesX+(nHolesX-1));
aY = L/(2+nHolesY+(nHolesY-1));
xyRect = [-L/2 -L/2; L/2 -L/2; L/2 L/2; -L/2 L/2];
pdeGeom = geomDataFromPolygon(xyRect);
xC = -L/2 + aX;
for i = 1:nHolesX
    yC = -L/2 + aY;
    for j = 1:nHolesY
        xyHole = [xC yC; xC+aX yC; xC+aX yC+aY; xC yC+aY];
        pdeGeom = [pdeGeom geomDataFromPolygon(xyHole,1)];
        yC = yC + aY + aY;
    end
    xC = xC+aX + aX;
end

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% square plate with many circular holes

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

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% traffic circle

L = 1; % half length
h = 0.1; % thickness
R1 = 0.4; % outer circle
R2 = 0.2; % inner circle

w = sqrt(R1*R1-h*h);
pdeGeom = [2 -L -w -h -h 1 0 0 0 0 0 0; ...
    1 -w 0 -h -R1 1 0 0 0 R1 R1 0 ; ...
    1 0 w -R1 -h 1 0 0 0 R1 R1 0 ; ...
    2 w L -h -h 1 0 0 0 0 0 0 ; ...
    2 L L -h h 1 0 0 0 0 0 0 ; ...
    2 L w h h 1 0 0 0 0 0 0; ...
    1 w 0 h R1 1 0 0 0 R1 R1 0 ; ...
    1 0 -w R1 h 1 0 0 0 R1 R1 0 ; ...
    2 -w -L h h 1 0 0 0 0 0 0 ; ...
    2 -L -L h -h 1 0 0 0 0 0 0; ...
    1 0 -R2 R2 0 0 1 0 0 R2 R2 0 ; ...
    1 -R2 0 0 -R2 0 1 0 0 R2 R2 0 ; ...
    1 0 R2 -R2 0 0 1 0 0 R2 R2 0 ; ...
    1 R2 0 0 R2 0 1 0 0 R2 R2 0 ; ...
    ]';


figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% stepped

[pdeGeom] = constructStep(1,1,0.2,0.1,0.02);

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% high order bisector

L = 1.0;
H = 2.0;
R = 3;
Yc = sqrt(R*R - L*L) - H;
pdeGeom = [2 -L 0 -H H 1 0 0 0 0 0; ...
    2 0 L  H -H 1 0 0 0 0 0; ...
    2 L L -H H 1 0 0 0 0 0; ...
    1 L -L H H 1 0 0 -Yc R R; ...
    2 -L -L H -H 1 0 0 0 0 0]';

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% N-gon

N = 10;
theta = 2*pi*[0:N]/N;
xy = [cos(theta);sin(theta)]';
[pdeGeom] = geomDataFromPolygon(xy);



figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% split

A = [2 -0.4 1 -0.05 -0.05 1 0 0 0 0 0;
    2 1 1 -0.05 0.05 1 0 0 0 0 0;
    2 1 0.45 0.05 0.05 1 0 0 0 0 0;
    2 0.45 0.9 0.05 0.25 1 0 0 0 0 0;
    2 0.9 0.85 0.25 0.35 1 0 0 0 0 0;
    2 0.85 0.25 0.35 0.05 1 0 0 0 0 0;
    2 0.25 -0.4 0.05 0.05 1 0 0 0 0 0;
    2 -0.4 -0.4 0.05 -0.05 1 0 0 0 0 0];

theta0 = atan2(0.25-0.05,0.90-0.45) + pi/2;
t0 = (0.05+0.02+0.02*sin(theta0)-0.05)/(0.25-0.05);
x0 = 0.45+t0*(0.90-0.45)-0.02*cos(theta0);

A(3,3) = x0;
A(3,5) = 0.05;
A(4,2) = x0+0.02*cos(theta0);
A(4,4) = 0.05+0.02+0.02*sin(theta0);

theta1 = atan2(0.35-0.05,0.85-0.25) - pi/2;
t1 = (0.05+0.2+0.2*sin(theta1)-0.05)/(0.35-0.05);
x1 = 0.25+t1*(0.85-0.25)-0.2*cos(theta1);

A(6,3) = x1+0.2*cos(theta1);
A(6,5) = 0.05+0.2+0.2*sin(theta1);
A(7,2) = x1;
A(7,4) = 0.05;

A = [A(1:3,:);[1 A(4,2) A(3,3) A(4,4) A(3,5) 0 1 x0 0.05+0.02 0.02 0.02]; ...
    A(4:6,:);[1 A(7,2) A(6,3) A(7,4) A(6,5) 0 1 x1 0.05+0.2 0.2 0.2];A(7:end,:)];

pdeGeom = A';

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);

%% H-Cell

pdeGeom = H_Cell;

figure,
pdegplot(pdeGeom); axis('equal'); hold on;
[medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom);
plotMedialCurves(medialCurves);


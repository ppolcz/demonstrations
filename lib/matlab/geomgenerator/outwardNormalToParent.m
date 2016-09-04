function [n] = outwardNormalToParent(pdeGeomPadded,pt,parent)

global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;

if (pdeGeomPadded(1,parent) == -1) % concave vertex
    n = outwardAvgNormalToCorner(pdeGeomPadded,parent);
elseif (pdeGeomPadded(1,parent) == 2) % line parent
    [n] = outwardNormalToLine(pdeGeomPadded,pt,parent);
elseif (pdeGeomPadded(1,parent) == 1) % arc parent
    [n] = outwardNormalToArc(pdeGeomPadded,pt,parent);
else
    error('Invalid pdeGeomPadded Data in findOutwardNormalAtPt');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [avgNormal, success] = outwardAvgNormalToCorner(pdeGeomPadded,parent)

adjacentEdges = pdeGeomPadded(4:5,parent);
avgNormal = zeros(1,2);
pt = pdeGeomPadded(2:3,parent)';
for i = 1:2
    p = adjacentEdges(i);
    if (pdeGeomPadded(1,p) == 2)
        [n] = outwardNormalToLine(pdeGeomPadded,pt,p);
    elseif (pdeGeomPadded(1,p) == 1)
        [n] = outwardNormalToArc(pdeGeomPadded,pt,p);
    else
        error('Invalid type in outwardAvgNormalToCorner');
    end
    avgNormal = avgNormal + n/2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lineNormal] = outwardNormalToLine(pdeGeomPadded,pt,parent)
startPt = [pdeGeomPadded(2,parent) pdeGeomPadded(4,parent)];
endPt = [pdeGeomPadded(3,parent) pdeGeomPadded(5,parent)];    
L = norm(endPt - startPt);
lineTangent = (endPt-startPt)/L;
lineNormal = [lineTangent(2) -lineTangent(1)];
if (pdeGeomPadded(6,parent) == 0)
    lineNormal = -lineNormal;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [normalToArc, success] = outwardNormalToArc(pdeGeom,pt,parent )
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
startPt = [pdeGeom(2,parent) pdeGeom(4,parent)];
endPt = [pdeGeom(3,parent) pdeGeom(5,parent)];
center = [pdeGeom(8,parent) pdeGeom(9,parent)];
radius = pdeGeom(10,parent);

% it is assumed that the pt lies on the arc
centerToPt = pt - center;
if (abs(norm(centerToPt) - radius) > MMA_ABS_TOL)
    error('Point does not lie on arc in outwardNormalToArc');
end
normalToArc = centerToPt/radius;
orientation = pdeGeom(6,parent);
if (orientation == 0)
    normalToArc  = -normalToArc;
end
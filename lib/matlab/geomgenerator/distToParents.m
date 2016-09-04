function [distToparents] = distToParents(pdeGeomPadded,pt,parents)
% Given a pde geom parents consisting of lines and arcs, find the distance
% to boundary parents from a given pt
% The pdeGeomPadded is described by a matrix.

if (nargin == 2)
    parents = 1:size(pdeGeomPadded,2);
end
for i = 1:length(parents)
    parent = parents(i);
    if (pdeGeomPadded(1,parent) == -1) % concave vertex
        concavePt = [pdeGeomPadded(2,parent) pdeGeomPadded(3,parent)];
        dist = sqrt((concavePt(1) - pt(1))^2 + (concavePt(2) - pt(2))^2);
    elseif (pdeGeomPadded(1,parent) == 2) % line parent
        startPt = [pdeGeomPadded(2,parent) pdeGeomPadded(4,parent)];
        endPt = [pdeGeomPadded(3,parent) pdeGeomPadded(5,parent)];
        [dist] = distanceToLine(startPt,endPt, pt );
    else % arc parent
        startPt = [pdeGeomPadded(2,parent) pdeGeomPadded(4,parent)];
        endPt = [pdeGeomPadded(3,parent) pdeGeomPadded(5,parent)];
        center = [pdeGeomPadded(8,parent) pdeGeomPadded(9,parent)];
        radius = pdeGeomPadded(10,parent);
        [dist]= distanceToArc(startPt,endPt,center,radius, pt );
    end
    distToparents(i) = dist;
end
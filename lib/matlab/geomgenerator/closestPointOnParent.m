function [closestPt, distToParent] = closestPointOnParent(pdeGeom,pt,parent)
% Find the closest point on  a pde geom parent 
% The pdeGeom is described by a matrix.

global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;

if (pdeGeom(1,parent) == -1) % concave vertex
    closestPt = [pdeGeom(2,parent) pdeGeom(3,parent)];
elseif (pdeGeom(1,parent) == 2) % line parent
    [closestPt] = closestPtOnLine(pdeGeom,parent,pt );
else % arc parent
    [closestPt] = closestPtOnArc(pdeGeom,parent,pt );
end
distToParent = norm(closestPt - pt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [closestPt] = closestPtOnLine(pdeGeomPadded,parent, pt )
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
startPt = [pdeGeomPadded(2,parent) pdeGeomPadded(4,parent)];
endPt = [pdeGeomPadded(3,parent) pdeGeomPadded(5,parent)];    
L = norm(endPt - startPt);
if (L < MMA_ABS_TOL)
    closestPt = startPt;
    return;
end
lineTangent = (endPt-startPt)/L;
u = (pt-startPt)*lineTangent'/L;
if (u < 0)
    closestPt = startPt;
elseif (u > 1)
    closestPt = endPt;
else
    closestPt = (1-u)*startPt + u*endPt;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [closestPt] = closestPtOnArc(pdeGeom,parent,pt )
startPt = [pdeGeom(2,parent) pdeGeom(4,parent)];
endPt = [pdeGeom(3,parent) pdeGeom(5,parent)];
center = [pdeGeom(8,parent) pdeGeom(9,parent)];
radius = pdeGeom(10,parent);

startAngle = atan2(startPt(2)-center(2),startPt(1)-center(1));
endAngle = atan2(endPt(2)-center(2),endPt(1)-center(1));
angle = atan2(pt(2)-center(2),pt(1)-center(1));
if (startAngle >= 0) & (endAngle < 0)
    endAngle = endAngle + 2*pi;
    if (angle < 0)
        angle = angle + 2*pi;
    end
end

diffAngle = (angle-startAngle)*(angle-endAngle);   
if (diffAngle < 0) % pt lies inbetween
    distToCenter = sqrt((center(1) - pt(1))^2 + (center(2) - pt(2))^2);
    closestPt = center + radius*[cos(angle) sin(angle)];
else % find the shorter of two distances
    distToStart = sqrt((startPt(1) - pt(1))^2 + (startPt(2) - pt(2))^2);
    distToEnd =sqrt((endPt(1) - pt(1))^2 + (endPt(2) - pt(2))^2);
    if (distToStart <= distToEnd)
        closestPt = startPt;
    else
        closestPt = endPt;
    end
end

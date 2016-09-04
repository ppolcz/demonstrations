function [trueOrFalse, newParents] = isThisAMedialPoint(pdeGeomPadded,parents,pt)
% Three conditions must be satisfied for a point to be a medialPoint (in
% increasing order of computational complexity)
% 1. For each parent, if the parent is an edge node, then the shortest 
%    vector from pt to edge node must be along the edge normal
% 2. The distances to all parents must be almost equal
% 3. This distance must be less than all other distances (expensive test)
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;

trueOrFalse = 1; % default
newParents = integerSet([]);
if (length(parents) ~= 3)
    parents
    error('Invalid input in isThisAMedialPoint');
end
% first test
dist = zeros(length(parents),1);
for n = 1:length(parents)
    parent = parents(n);
    [closestPt, distToParent] = closestPointOnParent(pdeGeomPadded,pt,parent);
    dist(n) = distToParent;
    if ((pdeGeomPadded(1,parent) == 1) || (pdeGeomPadded(1,parent) == 2))
        [n] = outwardNormalToParent(pdeGeomPadded,closestPt,parent);
        if (distToParent > eps)
            tempVec = (closestPt-pt)/distToParent;
            dotProd = tempVec*n';
            if (abs(dotProd-1) > MMA_REL_TOL)
                trueOrFalse = 0;
                return;
            end
        end
    end
end

% Test 2
value = (dist(1) - dist(2))^2 + (dist(1) - dist(3))^2  + (dist(2) - dist(3))^2;
if (value > 3*(MMA_ABS_TOL^2))
    trueOrFalse = 0;
    return;
end

% Test 3
minDist = min(dist);
[allDist] = distToParents(pdeGeomPadded,pt);
if (min(allDist) < minDist - 10*MMA_ABS_TOL)
    trueOrFalse = 0;
    return;
end


% check if any new parents exist
for p = 1:length(allDist)
    if (abs(allDist(p)-minDist) < MMA_ABS_TOL)
        if (pdeGeomPadded(1,p) ==-1)
            newParents = insert(newParents,p);
        else
            [closestPt,distToParent] = closestPointOnParent(pdeGeomPadded,pt,p);
            [n] = outwardNormalToParent(pdeGeomPadded,closestPt,p);
            tempVec = (closestPt-pt)/distToParent;
            dotProd = tempVec*n';
            if (abs(dotProd-1) < MMA_REL_TOL)
                newParents = insert(newParents,p);
            end
        end
    end
end

trueOrFalse = 1;
return;


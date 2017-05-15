function [trueOrFalse] = isThisALocalMedialPoint(pdeGeomPadded,parents,pt)

global debug;
global MMA_ABS_TOL;
global MMA_REL_TOL;

trueOrFalse = 1; % default
newParents = integerSet([]);
if (length(parents) ~= 3)
    parents
    error('Invalid input in isThisALocalMedialPoint');
end
for n = 1:length(parents)
    parent = parents(n);
    [closestPt, distToParent] = closestPointOnParent(pdeGeomPadded,pt,parent);
    if ((pdeGeomPadded(1,parent) == 1) || (pdeGeomPadded(1,parent) == 2))
        [n] = outwardNormalToParent(pdeGeomPadded,closestPt,parent);
        if (distToParent > MMA_ABS_TOL)
            tempVec = (closestPt-pt)/distToParent;
            dotProd = tempVec*n';
            if (abs(dotProd-1) > MMA_REL_TOL)
                trueOrFalse = 0;
                return;
            end
        end
    end
end
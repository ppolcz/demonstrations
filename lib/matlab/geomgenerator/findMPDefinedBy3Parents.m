function [medialPt,success] = findMPDefinedBy3Parents(pdeGeomPadded,tryParents, initialPt,box)
%   Given 3 parent segments in tryParents find the corresponding mp if
%   it exists.
%
% 	We create two new sets of parents called boundaryConstrainingParents and
% 	medialConstrainingParents. The first set contains parents that constrain
% 	boundary points associated with the medial points we are seeking
% 	The second set directly constrain the medial point.
%
% 	All edges belong to boundaryConstrainingParents
%
%   A concave vertex belongs to boundaryConstrainingParents if
%   none of its adjacent edges appear in  the tryParents set.
%
% 	If a concave vertex and only one adjacent edge appears in the
% 	tryParents then the medial point must lie on the  line passing
% 	through the vertex and perpendicular to the edge. The concave vertex 
%   is therefore viewed as a medialConstrainingParent
%
% 	If a concave vertex and both adjacent edges appear in tryParents, then
% 	such a situation will result in a contradiction, and is therefore
% 	rejected.

global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;

boundaryConstrainingParents = [];
medialConstrainingParents = [];
newMP = [];
success = 0;
medialPt = initialPt;
for parent = tryParents
    if ((pdeGeomPadded(1,parent) == 2)  || (pdeGeomPadded(1,parent) == 1))% edge
        boundaryConstrainingParents = [boundaryConstrainingParents parent];
    else % concave vertex
        common = intersect( pdeGeomPadded(4:5,parent), tryParents);
        if (length(common) == 0)
            boundaryConstrainingParents = [boundaryConstrainingParents parent];
        elseif (length(common) == 1)
            medialConstrainingParents = [medialConstrainingParents parent];
            adjacentEdge = common;
        else % (length(common) == 2)
            success = 0;
            return;
        end 
    end
end

previousPt = initialPt;
iter = 0;
iterMax = 50;
P = zeros(3,2);
N = zeros(3,2);
BP = zeros(3,2);
BN = zeros(3,2);
while (1) % forever
    for i = 1:length(boundaryConstrainingParents)
        parent = boundaryConstrainingParents(i);
        [P(i,:), dist] = closestPointOnParent(pdeGeomPadded,previousPt,parent );
        [N(i,:)] = outwardNormalToParent(pdeGeomPadded,P(i,:),parent);
        if ((dist > MMA_ABS_TOL) & (pdeGeomPadded(1,parent) == -1))
            cnvPt = pdeGeomPadded(2:3,parent)';
            N(i,:) = (cnvPt - previousPt)/dist;
        end
    end
    for i = 1:length(medialConstrainingParents)
        parent = medialConstrainingParents(i);
        if (pdeGeomPadded(1,parent) == -1) % concave corner
             BP(i,:) = pdeGeomPadded(2:3,parent); % closest pt is the concave corner
             [edgeNormal] = outwardNormalToParent(pdeGeomPadded,BP(i,:),adjacentEdge);
             BN(i,:) = [edgeNormal(2) -edgeNormal(1)];
        else
            error('Cannot be here in findMPDefinedBy3Parents');
        end
    end
    mpSetSize = length(medialConstrainingParents);

    if (mpSetSize == 0)
        [medialPt, success] = medialPoint3Lines(P(1,:),N(1,:),P(2,:),N(2,:),P(3,:),N(3,:));
    elseif (mpSetSize == 1)
        [medialPt, success] = medialPoint2Lines1Bisector(P(1,:),N(1,:),P(2,:),N(2,:),BP(1,:),BN(1,:));
    elseif (mpSetSize == 2)
        disp('Case 2 not yet implemented in findMPDefinedBy3Parents'); 
        success = 0;
        return;
    else
        disp('Case 3 not yet implemented in findMPDefinedBy3Parents'); 
    end
    
    err = norm(medialPt - previousPt);
    iter = iter + 1;
    
    if (MMA_DEBUG)
        
        medialPt
        err
    end
    
    if (iter > iterMax)
        success = 0;
        return;
    end
    if (err < MMA_ABS_TOL)
        success = 1;
        return;
    end
    previousPt = medialPt;
    
    
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pt,n] = bisectorOf2Lines(pt1,n1,pt2,n2)
% given 2 lines (pt and normals) find the bisector line (pt and normal)

[pt, success] = intersect2Lines(pt1,n1,pt2,n2);
if (~success) % if parallel
    pt = (pt1+pt2)/2;
    n = n1;
else
    n = (n1-n2)/2; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [medialPt, success] = medialPoint3Lines(pt1,n1,pt2,n2,pt3,n3)
% find the medial point defined by 3 lines

[B12pt,B12n] = bisectorOf2Lines(pt1,n1,pt2,n2);
[B13pt,B13n] = bisectorOf2Lines(pt1,n1,pt3,n3);

[medialPt, success] = intersect2Lines(B12pt,B12n,B13pt,B13n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [pt, success] = intersect2Lines(pt1,n1,pt2,n2)
% given 2 lines (defined by pt and normal) find the intersection pt
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
c(1,1) = -pt1*n1';
c(2,1) = -pt2*n2';
% the two st lines are: 
% nx1*X + ny1*Y + c1 = 0;
% nx2*X + ny2*Y + c2 = 0;
A = [n1; n2];
if (abs(det(A)) < MMA_REL_TOL)
    pt = [0 0];
    success = 0;
else
    pt = -(A\c)';
    success = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [medialPt, success] = medialPoint2Lines1Bisector(pt1,n1,pt2,n2,Bpt1,Bn1)
% find the medial point defined by 2 lines and a bisector
[B12pt,B12n] = bisectorOf2Lines(pt1,n1,pt2,n2);
[medialPt, success] = intersect2Lines(B12pt,B12n,Bpt1,Bn1);

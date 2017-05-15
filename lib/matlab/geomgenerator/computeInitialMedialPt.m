function initialPt = computeInitialMedialPt(pdeGeomPadded,currentMP,parents)

initialPt = currentMP;
for iter = 1:4
    newPt = zeros(1,2);
    for i = 1:length(parents)
        p = parents(i);
        [closestPt] = closestPointOnParent(pdeGeomPadded,initialPt,p);
        newPt = newPt + closestPt;
    end
    initialPt = newPt/length(parents);
end

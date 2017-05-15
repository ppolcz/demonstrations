function  [medialCurves,pdeGeomPadded,box] = computeMedialAxis(pdeGeom)
% Compute the medial axis of a geometry consisting of line segments and
% circular arcs. The geometry is the decomposed geometry matrix from MATLAB's
% pdetool. 
srepsEnums;
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
medialCurves = [];
pdeGeomPadded = pdeGeom;
if (MMA_DEBUG) 
    pdegplot(pdeGeom); hold on; axis('equal');
    markParents(pdeGeom); pause
end
%% Step 1: Rearrange the order of edges so that they form a continuous sequence and find bounding box 
% The directions are unchanged since MATLAB requires that all circular
% edges be counter clockwise. 
[pdeGeom,startEndLoopSegments, box, scale] = reorderGeomSegments(pdeGeom);
% two medial points will be collapsed if they are within a certain tolerance
MMA_ABS_TOL = MMA_REL_TOL*scale; 
if (MMA_DEBUG) 
    clf;
    pdegplot(pdeGeom); hold on; axis(box); axis('equal');

    markParents(pdeGeom); pause
end

%% Step 2: Identify all convex, flat and concave pts on boundary.
% Create a pdeGeomPadded that will be used for distance calculations
% pdeGeomPadded is similar  to pdeGeom but
% 1. One additional column is created for each concave vertex. The
%    distances to concave vertices plays a critical role in medial axis
%    computation.
[pdeGeomPadded,vertices,vertexType,vertexAdjacentEdges] = ...
    classifyVertices(pdeGeom,startEndLoopSegments);

%% Step 3: Assign all convex corners as medial points
nBoundaryVertices = size(vertices,1);
nMedialPoints = 0;
toProcess = [];
for vertex = 1:nBoundaryVertices
    if (vertexType(vertex) == 1) % convex
        nMedialPoints =nMedialPoints +1;
        medialPoints(nMedialPoints,:) = vertices(vertex,:);
        medialPointParents{nMedialPoints} = integerSet(vertexAdjacentEdges(vertex,:));
        if (MMA_DEBUG)
            plot(medialPoints(nMedialPoints,1),medialPoints(nMedialPoints,2),'or')
            text(medialPoints(nMedialPoints,1),medialPoints(nMedialPoints,2),num2str(elementsOf(medialPointParents{nMedialPoints})),...
                'edgecolor','b','BackgroundColor',[.4 .5 .9],'fontsize',8);
        end
        toProcess = [toProcess nMedialPoints];
    end
end
for i =1:nMedialPoints
    neighbors{i} = integerSet([]);
end

% Determine neighbors
for m1 = 1:nMedialPoints
    p1 = medialPointParents{m1};
    for m2 = m1+1:nMedialPoints
        p2 = medialPointParents{m2};
        common = p1*p2;
        if (~isempty(common))
            neighbors{m1}= insert(neighbors{m1},m2);
            neighbors{m2} = insert(neighbors{m2},m1);
        end
    end
end
    
if (MMA_DEBUG) 
    markParents(pdeGeomPadded); pause;
end

%% If no medial points have been detected so far
if (nMedialPoints == 0)
    
end

%% Step 4: Find all other medial points
while (~isempty(toProcess))
    currentMP = toProcess(1);
    currentParents = elementsOf(medialPointParents{currentMP});
    
    currentMpt = medialPoints(currentMP,:);

    if (MMA_DEBUG)
        disp('**************************************************')
        currentParents
        plot(medialPoints(currentMP,1),medialPoints(currentMP,2),'or')
        text(medialPoints(currentMP,1),medialPoints(currentMP,2),num2str(elementsOf(medialPointParents{currentMP})),...
            'edgecolor','r','BackgroundColor',[.9 .5 .4],'fontsize',8);
    end
    
    [distToSegments] = distToParents(pdeGeomPadded,currentMpt);
    [distSorted,nearestSegments] = sort(distToSegments);
    
    parentsCombination = generateParentsCombination(pdeGeomPadded,currentParents,...
                        neighbors, medialPointParents, currentMP);

    for select = 1:size(parentsCombination,1)
        medialEdgeParents = integerSet(parentsCombination(select,:));
        for otherParent = nearestSegments    
            if (find(medialEdgeParents,otherParent)) % we need a new 3rd parent
                continue;
            end

            tryParents = insert(medialEdgeParents,otherParent);
            if(contains(tryParents,medialPointParents{currentMP}))
                continue;
            end
            initialPt = computeInitialMedialPt(pdeGeomPadded,currentMpt,elementsOf(tryParents));

            if (MMA_DEBUG)
                disp('---------------')
                initialPt
                parentsSearched = elementsOf(tryParents)
            end
            [newMP,success] = findMPDefinedBy3Parents(pdeGeomPadded,elementsOf(tryParents),initialPt,box);

            if (success)
                % Check if it is a duplicate 
                [isLocalMP] = isThisALocalMedialPoint(pdeGeomPadded,elementsOf(tryParents),newMP);
                if (~isLocalMP)
                    continue
                end
                existingMP = isMedialPointDuplicate(medialPoints,newMP);
                if (existingMP)

                    neighbors{existingMP} = insert(neighbors{existingMP},currentMP);
                    neighbors{currentMP} = insert(neighbors{currentMP},existingMP);
                    tempSet = medialPointParents{existingMP} + tryParents;
                    if (length(tempSet) > length(medialPointParents{existingMP}))
                        medialPointParents{existingMP} = tempSet;
                        toProcess = [toProcess existingMP];
                    end
                    if (MMA_DEBUG)
                        disp('OLD Medial point')
                        newMP
                        pt1 = medialPoints(existingMP,:);
                        pt2 = medialPoints(currentMP,:);
                        plot([pt1(1) pt2(1)],[pt1(2) pt2(2)],'k:');
                    end
                    break;
                end
               
                % check if this indeed a MP
                [isNewMP,newParents] = isThisAMedialPoint(pdeGeomPadded,elementsOf(tryParents),newMP);
                
                if (isNewMP)
                    nMedialPoints =nMedialPoints +1;
                    
                    toProcess = [toProcess nMedialPoints];
                    neighbors{nMedialPoints}  = integerSet([]);
                    neighbors{nMedialPoints} = insert(neighbors{nMedialPoints},currentMP);
                    neighbors{currentMP} = insert(neighbors{currentMP},nMedialPoints);

                    % Add to the list of medial points
                    medialPoints(nMedialPoints,:) = newMP;
                    medialPointParents{nMedialPoints} = tryParents + newParents;

                    if (MMA_DEBUG)
                        disp('NEW Medial Point')
                        newMP
                        plot(medialPoints(nMedialPoints,1),medialPoints(nMedialPoints,2),'or')
                        text(medialPoints(nMedialPoints,1),medialPoints(nMedialPoints,2),num2str(elementsOf(medialPointParents{nMedialPoints})),...
                            'edgecolor','b','BackgroundColor',[.4 .5 .9],'fontsize',8);                 
                        pt1 = medialPoints(nMedialPoints,:);
                        pt2 = medialPoints(currentMP,:);
                        plot([pt1(1) pt2(1)],[pt1(2) pt2(2)],'k:');
                    end
                    break;
                end
            end
        end
    end
    toProcess = toProcess(2:end); % done with the current medial point
    if (MMA_DEBUG)
        pause;
    end
end

%% Step 5: Construct the medial branches as rational Bezier curves
options = optimset('gradobj','off','maxiter',20,'display','off','tolfun',1e-6,'tolx',1e-6,'LargeScale','off');
nMedialCurves = 0;
for m1 = 1:nMedialPoints
    parents1 =  medialPointParents{m1};
    neighborsOfm1 = neighbors{m1};
    for kk = 1:size(neighborsOfm1);
        m2 = neighborsOfm1(kk);
        if (m2 < m1)
            continue;
        end
        parents2 =  medialPointParents{m2};
        commonParents = elementsOf(parents1*parents2);
        optimize = false;
        if (length(commonParents) == 2) 
            switchDirection = false; % may be needed for parabolic branches
            aMat(1:2,1) = medialPoints(m1,:)';
            aMat(1:2,2) = medialPoints(m2,:)';
            aMat(1:2,3) = pdeGeomPadded([2 4],commonParents(1));
            aMat(3,:) = 1;
            nMedialCurves = nMedialCurves +1;
            if (pdeGeomPadded(1,commonParents(1)) == 2) & (pdeGeomPadded(1,commonParents(2)) == 2) % line segments
                medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m1,:);
                medialCurves(nMedialCurves).controlPoints(2,:) = medialPoints(m2,:);
                medialCurves(nMedialCurves).weights = [1,1];
                medialCurves(nMedialCurves).type = LL;
                if (det(aMat) < 0)
                    commonParents =fliplr(commonParents);
                end
            elseif (pdeGeomPadded(1,commonParents(1)) == 1) & (pdeGeomPadded(1,commonParents(2)) == 2) %
                medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m2,:);
                medialCurves(nMedialCurves).controlPoints(2,:) = (medialPoints(m1,:)+medialPoints(m2,:))/2;
                medialCurves(nMedialCurves).controlPoints(3,:) = medialPoints(m1,:);
                medialCurves(nMedialCurves).weights = [1 1 1];
                medialCurves(nMedialCurves).type = LL;
                if (det(aMat) < 0)
                    commonParents =fliplr(commonParents);
                end
                optimize = true;
                
            elseif (pdeGeomPadded(1,commonParents(1)) == 2) & (pdeGeomPadded(1,commonParents(2)) == 1) %
                medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m2,:);
                medialCurves(nMedialCurves).controlPoints(2,:) = (medialPoints(m1,:)+medialPoints(m2,:))/2;
                medialCurves(nMedialCurves).controlPoints(3,:) = medialPoints(m1,:);
                medialCurves(nMedialCurves).weights = [1 1 1];
                medialCurves(nMedialCurves).type = LL;
                if (det(aMat) < 0)
                    commonParents =fliplr(commonParents);
                end
                optimize = true;
            elseif (pdeGeomPadded(1,commonParents(1)) == -1) & (pdeGeomPadded(1,commonParents(2)) == -1) % line segments
                medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m1,:);
                medialCurves(nMedialCurves).controlPoints(2,:) = medialPoints(m2,:);
                medialCurves(nMedialCurves).weights = [1,1];
                medialCurves(nMedialCurves).type = PP;
                if (det(aMat) < 0)
                    commonParents =fliplr(commonParents);
                end
            else 
                switchDirection = false;
                if (pdeGeomPadded(1,commonParents(1)) < 0) & (pdeGeomPadded(1,commonParents(2)) > 0)
                    % one concave parent
                    % need to ensure that the concave pt is to the left         
                    % find the signed area of the triangle
                    if (det(aMat) < 0)
                        switchDirection = true;
                    end
                    medialCurves(nMedialCurves).type = PL;
                elseif (pdeGeomPadded(1,commonParents(1)) > 0) & (pdeGeomPadded(1,commonParents(2)) < 0)
                    % one concave parent
                    % need to ensure that the concave pt is to the left
                    aMat(1:2,1) = medialPoints(m1,:)';
                    aMat(1:2,2) = medialPoints(m2,:)';
                    aMat(1:2,3) = pdeGeomPadded([2 4],commonParents(2));
                    aMat(3,:) = 1;
                    if (det(aMat) < 0)
                        switchDirection = true;
                    end
                    commonParents =fliplr(commonParents);
                    medialCurves(nMedialCurves).type = PL;
                else
                    if (det(aMat) < 0)
                        commonParents =fliplr(commonParents);
                    end
                    medialCurves(nMedialCurves).type = LL;
                end
               
                if (switchDirection)
                    medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m2,:);
                    medialCurves(nMedialCurves).controlPoints(2,:) = (medialPoints(m1,:)+medialPoints(m2,:))/2;
                    medialCurves(nMedialCurves).controlPoints(3,:) = medialPoints(m1,:);
                    medialCurves(nMedialCurves).weights = [1 1 1];
                else
                    medialCurves(nMedialCurves).controlPoints(1,:) = medialPoints(m1,:);
                    medialCurves(nMedialCurves).controlPoints(2,:) = (medialPoints(m1,:)+medialPoints(m2,:))/2;
                    medialCurves(nMedialCurves).controlPoints(3,:) = medialPoints(m2,:);
                    medialCurves(nMedialCurves).weights = [1 1 1];
                end
                optimize = true;
            end
            medialCurves(nMedialCurves).parents = commonParents;
            if(optimize)
                [T0] = FindApproximateTangentToMedialAxis(pdeGeomPadded,medialCurves,nMedialCurves,0);
                [T1] = FindApproximateTangentToMedialAxis(pdeGeomPadded,medialCurves,nMedialCurves,1);
                A = [T0(1:2)',-T1(1:2)'];
                if abs(det(A)) > 1e-6
                    b = [medialCurves(nMedialCurves).controlPoints(end,1)-medialCurves(nMedialCurves).controlPoints(1,1); ...
                        medialCurves(nMedialCurves).controlPoints(end,2)-medialCurves(nMedialCurves).controlPoints(1,2)];
                    IntersectCoeffs = A\b;
                    xBar0 = [[medialCurves(nMedialCurves).controlPoints(1,1),medialCurves(nMedialCurves).controlPoints(1,2)] + IntersectCoeffs(1)*T0(1:2),1];
                else
                    xBar0 = [medialCurves(nMedialCurves).controlPoints(2,1:2)  1]';
                end
                A = []; B = []; Aeq = []; Beq = [];
                LB(1:2) = [box(1) box(3)];
                LB(3) = 0; % weights
                UB(1:2) = [box(2) box(4)];;
                UB(3) = 1; % weights
                [xBar,err,flag,output] = fmincon(@(xBar)objBezier(xBar,medialCurves(nMedialCurves),pdeGeomPadded,commonParents),...
                    xBar0,A,B,Aeq,Beq,LB,UB,@(xBar)BezierNonLCon(xBar),options); 
                medialCurves(nMedialCurves).controlPoints(2,1:2) = xBar(1:2);
                medialCurves(nMedialCurves).weights(2) = xBar(3);
            end
            
            if (nargout == 0)
                plotBezier(medialCurves(nMedialCurves),'r')
            end
            if (MMA_DEBUG)
                xy(1) =  mean(medialCurves(nMedialCurves).controlPoints(:,1));
                xy(2) =  mean(medialCurves(nMedialCurves).controlPoints(:,2));
                text(xy(1),xy(2),num2str(commonParents),'edgecolor','b','BackgroundColor',[.3 .7 .2],'fontsize',8);
                plotMedialCurves(medialCurves(nMedialCurves));
                pause
            end
        elseif (length(commonParents) > 2)
            %disp('commonParents > 2 not handled in computeMedialAxis'); 
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [diff,grad] = medialPointObj(p,pdeGeom,segmentsToConsider)
[dist, gradMatrix] = distToGeomSegments(pdeGeom,segmentsToConsider,p');
diff = (dist(1)-dist(2))^2 + (dist(1)-dist(3))^2 +(dist(2)-dist(3))^2;
grad = 2*(dist(1)-dist(2))*(gradMatrix(:,1)-gradMatrix(:,2));
grad = grad + 2*(dist(1)-dist(3))*(gradMatrix(:,1)-gradMatrix(:,3));
grad = grad + 2*(dist(2)-dist(3))*(gradMatrix(:,2)-gradMatrix(:,3));
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [diff] = objBezier(xBar,BezierBase,pdeGeom,commonParents)
% reconstruct the Bezier object
BezierBase.controlPoints(2,1:2) = xBar(1:2);
BezierBase.weights(2) = xBar(3)';
N = 10;
t = [1:(N-1)]'/N;
ptsOnBezier = sampleBezier(BezierBase,t);

%plotBezier(BezierBase,'g');  pause
diff = 0;
for i = 1:N-1
    dist = distToParents(pdeGeom,ptsOnBezier(i,:),commonParents);
    diff = diff + (dist(1)-dist(2))^2;
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c,ceq] = BezierNonLCon(xBar)
%There are no nonlinear constraints
c = []; ceq = [];
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function markParents(pdeGeom)
for segment = 1:size(pdeGeom,2)
    if (pdeGeom(1,segment) == -1) % concave vertex
        concavePt = [pdeGeom(2,segment) pdeGeom(3,segment)];
        text(concavePt(1),concavePt(2),num2str(segment),'edgecolor','b','BackgroundColor',[.7 .9 .7],'fontsize',8);
    else
        startPt = [pdeGeom(2,segment) pdeGeom(4,segment)];
        endPt = [pdeGeom(3,segment) pdeGeom(5,segment)];
        midPt = (startPt + endPt)/2;
        text(midPt(1),midPt(2),num2str(segment),'edgecolor','b','BackgroundColor',[.7 .9 .7],'fontsize',8);
    end
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [existingMP] = isMedialPointDuplicate(medialPoints,mp)
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
existingMP = 0;
for n =1:size(medialPoints,1)
    dist = norm(medialPoints(n,:) - mp);
    if (dist < MMA_ABS_TOL)
        existingMP = n;
        return;
    end
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T] = FindApproximateTangentToMedialAxis(pdeGeomPadded,medialCurves,nMedialCurves,s)
if s == 0
    Index_controlPoints = 1;
elseif s == 1
    Index_controlPoints = size(medialCurves(nMedialCurves).controlPoints,1);
else
    error('s must be either 0 or 1');
end
[closestPt1] = closestPointOnParent(pdeGeomPadded,medialCurves(nMedialCurves).controlPoints(Index_controlPoints,:),medialCurves(nMedialCurves).parents(1));
[n1] = outwardNormalToParent(pdeGeomPadded,closestPt1,medialCurves(nMedialCurves).parents(1));
[closestPt2] = closestPointOnParent(pdeGeomPadded,medialCurves(nMedialCurves).controlPoints(Index_controlPoints,:),medialCurves(nMedialCurves).parents(2));
[n2] = outwardNormalToParent(pdeGeomPadded,closestPt2,medialCurves(nMedialCurves).parents(2));
T1 = cross([0,0,-1],[n1,0]);
T2 = cross([0,0,1],[n2,0]);
T = 0.5*(T1+T2);



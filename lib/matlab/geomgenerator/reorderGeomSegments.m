function [pdeGeomNew,startEndLoopSegments, box, scale] = reorderGeomSegments(pdeGeom)
% Rearrange the order of edges so that they form a continuous sequence

global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;

startEndLoopSegments = [];
% find an edge on the outer loop
% The first edge in pdeGeom need not be an outer edge!!
startPts = pdeGeom([2 4],:);
endPts = pdeGeom([3 5],:);
allPts = [startPts; endPts];
xMin = min(allPts(1,:));xMax = max(allPts(1,:));
yMin = min(allPts(2,:));yMax = max(allPts(2,:));
box = [xMin xMax yMin yMax];
scale = max(xMax-xMin,yMax-yMin);
box = box + scale*[-.05 0.05 -0.05 0.05]; % slightly larger box
MMA_ABS_TOL = MMA_REL_TOL*scale;
centerPt = mean([startPts endPts],2);
distanceSqrStartToCenter =(startPts(1,:)-centerPt(1)).^2+(startPts(2,:)-centerPt(2)).^2;
[maxDist,firstEdge] = max(distanceSqrStartToCenter); % find an edge on outer loop
pdeGeomNew(:,1) = pdeGeom(:,firstEdge);

if (pdeGeomNew(6,1) == 1) % domain to the left of edge
    previousEndPt = pdeGeomNew([3 5],1); % true end pt
else
    previousEndPt = pdeGeomNew([2 4],1); %
end

pdeGeom = pdeGeom(:,[ 1:firstEdge-1 firstEdge+1:end]); % eliminate first edge column
segment = 0;
loop = 1;
newSegment = 1;
startEndLoopSegments(1,1) = 1; % start
startEndLoopSegments(2,1) = 1; % end
while (~(isempty(pdeGeom))) % while not empty
    segment = segment + 1;
    % check if the start pt matches
    startPt = pdeGeom([2 4],segment);
    diff = norm(startPt - previousEndPt);
    if (diff < MMA_ABS_TOL)
        newSegment = newSegment+1;
        pdeGeomNew(:,newSegment) = pdeGeom(:,segment);
        pdeGeom = pdeGeom(:,[1:segment-1 segment+1:end]); % eliminate this segment
        previousEndPt = pdeGeomNew([3 5],newSegment);
        segment = 0; % start afresh from the new list
        startEndLoopSegments(2,loop) =startEndLoopSegments(2,loop) +1;
        continue;
    end
    
    % check if the end pt matches
    endPt = pdeGeom([3 5],segment);
    diff = norm(endPt - previousEndPt);
    if (diff < MMA_ABS_TOL)
        newSegment = newSegment+1;
        pdeGeomNew(:,newSegment) = pdeGeom(:,segment);
        pdeGeom = pdeGeom(:,[1:segment-1 segment+1:end]); % eliminate this segment
        previousEndPt = pdeGeomNew([2 4],newSegment);
        segment = 0; % start search afresh 
        startEndLoopSegments(2,loop) =startEndLoopSegments(2,loop) +1;
        continue;
    end
    if (segment == size(pdeGeom,2)) % implies we are on a new inner loop   
        newSegment = newSegment+1;
        pdeGeomNew(:,newSegment) = pdeGeom(:,segment);
        pdeGeom = pdeGeom(:,[1:segment-1 segment+1:end]); % eliminate this segment
        if (pdeGeomNew(6,newSegment) == 1) % domain to the left of edge
            previousEndPt = pdeGeomNew([3 5],newSegment);
        else
            previousEndPt = pdeGeomNew([2 4],newSegment);
        end
        segment = 0; % start afresh from the new list
        loop = loop +1;
        startEndLoopSegments(1,loop) =startEndLoopSegments(2,loop-1)+1;
        startEndLoopSegments(2,loop) =startEndLoopSegments(1,loop);
    end
end

for segment = 1:size(pdeGeomNew,2)
    if ((pdeGeomNew(1,segment) == 2) | (pdeGeomNew(1,segment) == 3))
        pdeGeomNew(1,segment) = 2; % line segments are always 2
    elseif (pdeGeomNew(1,segment) == 1)
        pdeGeomNew(1,segment) = 1; % arc segments are 1
    elseif (pdeGeomNew(1,segment) == 4)
        if (pdeGeomNew(11,segment) < MMA_ABS_TOL) | ...
                (abs(pdeGeomNew(10,segment)-pdeGeomNew(11,segment)) < MMA_ABS_TOL)
            pdeGeomNew(1,segment) = 1; % arc segments are 1
        else
            error('Cannot handle elliptic segments');
        end
    else
        error('Unknown type in pdegeom');
    end
end
if (length(startEndLoopSegments) ==1)
    return
end
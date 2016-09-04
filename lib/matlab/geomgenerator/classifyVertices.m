function [pdeGeomPadded,vertices,vertexType,vertexAdjacentEdges] = ...
    classifyVertices(pdeGeom,nLoopSegments)

global debug;
global MMA_ABS_TOL;
global MMA_REL_TOL;
global MMA_FLAT_VERTEX_ON;

nSegments = size(pdeGeom,2);
pdeGeomPadded = pdeGeom;
nLoops = size(nLoopSegments,2);
vertexNum = 1;
for loop = 1:nLoops
    startSegment = nLoopSegments(1,loop);
    endSegment = nLoopSegments(2,loop);
    firstSegmentInLoop = true;
    allSegments = [endSegment startSegment:endSegment];
    for seg = 1:length(allSegments)
        segment = allSegments(seg);
        if (pdeGeom(6,segment) == 1)
            startPt = pdeGeom([2 4],segment);
            endPt = pdeGeom([3 5],segment);
            sign = 1; %use for arcs
        else
            startPt = pdeGeom([3 5],segment);
            endPt = pdeGeom([2 4],segment);
            sign = -1;
        end
        if (pdeGeom(1,segment) == 2) % line segments are always marked 2
            startTangent = (endPt-startPt)/norm(endPt-startPt);
            endTangent = startTangent;
        elseif (pdeGeom(1,segment) == 1) % arc segments are always marked 1
            center = pdeGeom([8 9],segment);
            startRadiusVector = (startPt-center)/norm(startPt-center);
            startTangent = sign*[-startRadiusVector(2) startRadiusVector(1)]';
            endRadiusVector = (endPt-center)/norm(endPt-center);
            endTangent = sign*[-endRadiusVector(2) endRadiusVector(1)]';
        end
        
        if (firstSegmentInLoop)
            startTangentFirst = startTangent; % store for final vertex
            endTangentPrevious = endTangent;
            firstSegmentInLoop = false;
            continue; % nothing else to do for first segment of loop
        else
            crossProd = endTangentPrevious(1)*startTangent(2)-endTangentPrevious(2)*startTangent(1);
            dotProd = endTangentPrevious(1)*startTangent(1)+endTangentPrevious(2)*startTangent(2);
            endTangentPrevious = endTangent;
        end
            
        vertices(vertexNum,:) = startPt;
        vertexAdjacentEdges(vertexNum,1:2) = allSegments([seg-1 seg]);
        if (~MMA_FLAT_VERTEX_ON) % don't count flat vertex as a parent
            if ((abs(crossProd) < MMA_REL_TOL) & (dotProd > MMA_REL_TOL)) % flat
                vertexType(vertexNum) = 0;
            elseif (crossProd > MMA_REL_TOL) % convex
                vertexType(vertexNum) = 1;
            else % concave
                vertexType(vertexNum) = -1;
                % pad with concave vertex info
                % Row is -1 denoting concave vertex
                % rows 2 and 3 specify the vertex location
                % rows 4 and 5 specify the two edges that meet at the concave
                % vertex
                nCurrentSegments =size(pdeGeomPadded,2);
                pdeGeomPadded(1:5,nCurrentSegments+1) = [-1 startPt'  allSegments([seg-1 seg])]';
            end
        else
            if (crossProd > MMA_REL_TOL) % convex
                vertexType(vertexNum) = 1;
            else % concave
                vertexType(vertexNum) = -1;
                % pad with concave vertex info
                % Row is -1 denoting concave vertex
                % rows 2 and 3 specify the vertex location
                % rows 4 and 5 specify the two edges that meet at the concave
                % vertex
                nCurrentSegments =size(pdeGeomPadded,2);
                pdeGeomPadded(1:5,nCurrentSegments+1) = [-1 startPt'  allSegments([seg-1 seg])]';
            end
        end
        vertexNum = vertexNum + 1;
    end 
end
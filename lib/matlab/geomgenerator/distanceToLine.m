function [distToLineSeg] = distanceToLineSegment(startPt,endPt, pt )
L = sqrt((endPt(1) - startPt(1))^2 + (endPt(2) - startPt(2))^2);
global MMA_DEBUG;
global MMA_ABS_TOL;
global MMA_REL_TOL;
if (L < MMA_ABS_TOL)
    distToLineSeg = sqrt((startPt(1) - pt(1))^2 + (startPt(2) - pt(2))^2);
    return;
end
% else
lineTangent = (endPt-startPt)/L;
u = (pt-startPt)*lineTangent'/L;
if (u < 0-MMA_REL_TOL)
    distToLineSeg = sqrt((startPt(1) - pt(1))^2 + (startPt(2) - pt(2))^2);
elseif (u > 1+MMA_REL_TOL)
    distToLineSeg = sqrt((endPt(1) - pt(1))^2 + (endPt(2) - pt(2))^2);
else
    lineNormal = [-lineTangent(2) lineTangent(1)];
    temp = ((pt-startPt)*lineNormal');
    if (temp > 0)
        distToLineSeg = temp;
    else
       distToLineSeg = -temp; 
    end
end

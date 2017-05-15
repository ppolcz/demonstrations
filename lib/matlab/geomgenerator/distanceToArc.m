function [distToArc] = distanceToArc(startPt,endPt,center,radius, pt )
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
    if (distToCenter >= radius) 
        distToArc = distToCenter - radius;
    else
        distToArc = radius-distToCenter;
    end
else % find the shorter of two distances
    distToStart = sqrt((startPt(1) - pt(1))^2 + (startPt(2) - pt(2))^2);
    distToEnd =sqrt((endPt(1) - pt(1))^2 + (endPt(2) - pt(2))^2);
    if (distToStart <= distToEnd)
        distToArc = distToStart;
    else
        distToArc = distToEnd;
    end
end

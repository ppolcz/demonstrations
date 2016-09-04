function plotMedialCurves(medialCurves)
srepsEnums;
nCurves = length(medialCurves);
for i = 1:nCurves
    curve = medialCurves(i);
    controlPts = curve.controlPoints;
    wts = curve.weights;
    type = curve.type;
    if (size(controlPts,1) == 2)
        plot(controlPts(1:2,1),controlPts(1:2,2),'r:');
    else
        t = 0:0.1:1;
        pts = sampleBezier(curve,t);
        plot(pts(:,1),pts(:,2),'r:');
    end
end
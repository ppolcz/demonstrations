function [geomData] = geomDataOfCircularHoles(holes)
% holes are described by xc, yc and r

nHoles = size(holes,1);
geomData = zeros(12,4*nHoles); % each hole has 4 segments

geomData(1,:) = 1; % circle
geomData(6,:) = 0; % holes have domain to the right as we move clock wise
geomData(7,:) = 1;

xy = zeros(4*nHoles,2);
counter = 1;
for i = 1:nHoles
    for j = 0:3
        thetaStart = pi/2*j;
        thetaEnd = pi/2*mod(j+1,4);
        xStart = holes(i,1) + holes(i,3)*cos(thetaStart);
        yStart = holes(i,2) + holes(i,3)*sin(thetaStart);
        xEnd = holes(i,1) + holes(i,3)*cos(thetaEnd);
        yEnd = holes(i,2) + holes(i,3)*sin(thetaEnd);
        
        geomData(2:5,counter) = [xStart xEnd yStart yEnd]';
        geomData(8:9,counter) = holes(i,1:2)'; % center
        geomData(10:11,counter) = holes(i,3); %radius
        counter = counter + 1;
    end
end
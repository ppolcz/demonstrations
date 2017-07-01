function geomData = geomDataFromPolygon(xy,reverse)
% given a series of xy points that define a simple polygon
% construct a geomData for pde

if (nargin == 1)
    reverse = 0;
end
nLines = length(xy);
geomData = zeros(12,nLines);

geomData(1,:) = 2;
if (reverse)
    geomData(6,:) = 0;
    geomData(7,:) = 1;
else
    geomData(6,:) = 1;
    geomData(7,:) = 0;
end
for i = 1:nLines-1
    geomData(2:3,i) = [xy(i,1) xy(i+1,1)]';
    geomData(4:5,i) = [xy(i,2) xy(i+1,2)]';
end
geomData(2:3,nLines) = [xy(nLines,1) xy(1,1)]';
geomData(4:5,nLines) = [xy(nLines,2) xy(1,2)]';
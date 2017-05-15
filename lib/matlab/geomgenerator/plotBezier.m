function plotBezier(Bezier,clr)

if (nargin == 1)
    clr = 'b';
end
nSamples = 50;
t = [0:(nSamples-1)]'/(nSamples-1);
controlPoints = Bezier.controlPoints;
weights = Bezier.weights;
nControlPoints = size(controlPoints,1);
n = nControlPoints-1;
B = zeros(nSamples,1);
xBez = zeros(nSamples,1);
yBez = zeros(nSamples,1);
wBez = zeros(nSamples,1);
for i = 0:n
    B = nchoosek(n,i).*(t.^i).*((1-t).^(n-i));
    xBez = xBez + controlPoints(i+1,1)*B;
    yBez = yBez + controlPoints(i+1,2)*B;
    wBez = wBez + weights(i+1)*B;
end
xBez = xBez./wBez;
yBez = yBez./wBez;
plot(xBez,yBez,[clr ':']);
hold on; axis('equal');
plot(controlPoints(:,1),controlPoints(:,2),clr,controlPoints(:,1),controlPoints(:,2),[clr '*']);



%% 
%  
%  file:   ciklois.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.09. Friday, 11:23:31
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Ciklois

t = linspace(0,5*pi,1000);
a = 1;

g = [
    a*(t - sin(t))
    a*(1 - cos(t))
    ]';

    

t1 = 2;
theta = linspace(0,2*pi,100);
c = [
    a*cos(theta) + t1
    a*(1 + sin(theta))
    ]';

figure, hold on
plot(...
    g(:,1),g(:,2), ...
    c(:,1),c(:,2), ...
    a*(t1 - sin(t1)), a*(1 - cos(t1)), '.', ...
    [a*(t1 - sin(t1)) t1], [a*(1 - cos(t1)) a], '-')
axis equal tight

%% Deltoid

% https://en.wikipedia.org/wiki/Cycloid
% https://en.wikipedia.org/wiki/Epicycloid
% https://en.wikipedia.org/wiki/Epitrochoid
% https://en.wikipedia.org/wiki/Hypocycloid
% https://en.wikipedia.org/wiki/Spirograph
% https://en.wikipedia.org/wiki/Hypotrochoid
% https://en.wikipedia.org/wiki/Tautochrone_curve
% https://en.wikipedia.org/wiki/Brachistochrone_curve

t = linspace(0,5*pi,1000);
a = 1;

R = 3;
r = 1;

g = [
    (R-r)*cos(t) + r*cos((R-r)/r*t)
    (R-r)*sin(t) - r*sin((R-r)/r*t)
    ]';

theta = linspace(0,2*pi,100);
C = [
    R*cos(theta)
    R*sin(theta)
    ]';

theta = linspace(0,2*pi,100);

figure
% for t1 = linspace(0,10*pi, 200)
for t1 = 1.5
    c = [
        r*cos(theta) + (R-r)*cos(t1)
        r*sin(theta) + (R-r)*sin(t1)
        ]';
    plot(...
        g(:,1),g(:,2), ...
        C(:,1),C(:,2), ...
        c(:,1),c(:,2), ...
        (R-r)*cos(t1)+r*cos((R-r)/r*t1), (R-r)*sin(t1) - r*sin((R-r)/r*t1), '.', ...
        [(R-r)*cos(t1)+r*cos((R-r)/r*t1) (R-r)*cos(t1)], [(R-r)*sin(t1) - r*sin((R-r)/r*t1) (R-r)*sin(t1)], '-')
    axis equal tight
    pause(0.05)
end


%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
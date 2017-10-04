%% Cycloid és a Deltoid
%  file:   anal3_ciklois_deltoid.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.09. Friday, 11:23:31
%  Reviewed on 2017. October 04. [Published fancily]
%
%%
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%% Cycloid

t = linspace(0,5*pi,1000);
a = 1;

g = [
    a*(t - sin(t))
    a*(1 - cos(t))
    ]';

theta = linspace(0,2*pi,100);

tsim = 1:0.1:4.6*pi;

fig = figure('Position', [ 680 857 668 121 ], 'Color', [1 1 1]);
clear frames
for i = 1:numel(tsim)
    ti = tsim(i);
    c = [
        a*cos(theta) + ti
        a*(1 + sin(theta))
        ]';

    P1 = plot(g(:,1),g(:,2)); hold on
    plot(c(:,1),c(:,2))
    plot(a*(ti - sin(ti)), a*(1 - cos(ti)), '.', 'MarkerSize', 20, 'Color', P1.Color)
    plot([a*(ti - sin(ti)) ti], [a*(1 - cos(ti)) a], '-'); hold off
    axis equal tight

    xticks(a*[0 pi 2*pi 3*pi 4*pi 5*pi])
    xticklabels({'0','a\pi','2a\pi','3a\pi','4a\pi','5a\pi','6a\pi'})
    yticks([0 a 2*a])
    yticklabels({'0','a','2a'})
    grid on

    drawnow

    frames(i) = getframe(fig);
end

delete(fig)
persist.pub_vid_write(frames)

%% Deltoid
% Egyéb érdekes paraméteres görbéb: <https://en.wikipedia.org/wiki/Cycloid
% Cycloid>, <https://en.wikipedia.org/wiki/Epicycloid Epicycloid>,
% <https://en.wikipedia.org/wiki/Epitrochoid Epitrochoid>,
% <https://en.wikipedia.org/wiki/Hypocycloid Hypocycloid>,
% <https://en.wikipedia.org/wiki/Spirograph Spirograph>,
% <https://en.wikipedia.org/wiki/Hypotrochoid Hypotrochoid>,
% <https://en.wikipedia.org/wiki/Tautochrone_curve Tautochrone_curve>,
% <https://en.wikipedia.org/wiki/Brachistochrone_curve
% Brachistochrone_curve>.

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

tsim = 1:0.05:3*pi;

fig = figure;
clear frames
for i = 1:numel(tsim)
    ti = tsim(i);
    c = [
        r*cos(theta) + (R-r)*cos(ti)
        r*sin(theta) + (R-r)*sin(ti)
        ]';
    Deltoid = plot(g(:,1),g(:,2)); hold on
    plot(C(:,1),C(:,2))
    plot(c(:,1),c(:,2))
    plot((R-r)*cos(ti)+r*cos((R-r)/r*ti), (R-r)*sin(ti) - r*sin((R-r)/r*ti), '.', 'Color', Deltoid.Color, 'MarkerSize', 20)
    plot([(R-r)*cos(ti)+r*cos((R-r)/r*ti) (R-r)*cos(ti)], [(R-r)*sin(ti) - r*sin((R-r)/r*ti) (R-r)*sin(ti)], '-');
    hold off
    axis equal tight

    frames(i) = getframe(fig);
end

delete(fig)
persist.pub_vid_write(frames)

%%
%
%  file:   anal3_ciklois_deltoid.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.09. Friday, 11:23:31
%  Reviewed on 2017. October 04. [Published fancily]
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
persist.runID
%persist.backup();

%% Ciklois

t = linspace(0,5*pi,1000);
a = 1;

g = [
    a*(t - sin(t))
    a*(1 - cos(t))
    ]';

theta = linspace(0,2*pi,100);

tsim = 1:0.1:4.6*pi;

fig = figure;
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

    if t == 0.3
        persist.pub_vid_poster('1D_hullamegyenlet_sin_kezdeti_sebesseggel')
    end

    frames(i) = getframe(fig);
end

delete(fig)
persist.pub_vid_write(frames)

return 

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
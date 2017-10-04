%% Script segedszamitasok_2017_09_25_gyak4
%
%  file:   segedszamitasok_2017_09_25_gyak4.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017. October 04.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c;
persist.backup();
%clear persist

%%

t = linspace(0,2*pi+0.01,1000);
R = 1;

[u,v] = meshgrid(linspace(0,R,20),t);

x = R*cos(t);
y = R*sin(t);
z = -x-y;

dx = -y;
dy = x;
dz = y-x;

figure('Position', [ 676 339 597 640 ], 'Color', [1 1 1]), hold on
Gamma = plot3(x,y,z);
Gamma.LineWidth = 2;
Kor = plot3(x,y,z*0);

CO = repmat(shiftdim(Kor.Color*2,-1),size(u));
KorLap = surf(u.*cos(v),u.*sin(v),u*0,CO);
KorLap.FaceAlpha = 0.5;
shading interp

CO = repmat(shiftdim(Gamma.Color,-1),size(u));
KorLap = surf(u.*cos(v),u.*sin(v),-u.*cos(v)-u.*sin(v),CO);
KorLap.FaceAlpha = 0.2;
shading interp

text(0.7,0.4,0.1,'$D$',persist.font.latex18{:})
text(0,-0.8,1.6,'$\partial M$',persist.font.latex18{:})
text(0,-0.8,1,'$M$',persist.font.latex18{:})

axis equal
view([ 63.2 , 10.8 ])
grid on

axis([-1 1 -1 1 -2 2])

ax = gca;
ax.FontName = 'TeX Gyre Schola Math';
ax.FontSize = 18;

t1 = [1.4,2.5,5,6];
% t2 = t1+0.01;
% Vector = quiver3(interp1(t,x,t1),interp1(t,y,t1),interp1(t,z,t1),...
%     interp1(t,dx,t2),interp1(t,dy,t2),interp1(t,dz,t2));
% 
% % Vector = quiver3(...
% %     [0 interp1(t,x,t1)],[0 interp1(t,y,t1)],[0 interp1(t,z,t1)],...
% %     [1 interp1(t,dx,t2)],[1 interp1(t,dy,t2)],[1 interp1(t,dz,t2)]);
% 
% Vector.Color = Gamma.Color;
% % Vector.ShowArrowHead = 'off';
% % Vector.LineStyle = 'none';
% Vector.MaxHeadSize = 5;
% Vector.AutoScale = 'on';
% Vector.AutoScaleFactor = 0.2;
% % Vector.AlignVertexCenters = 'on';
% % Vector.MarkerSize = 10;
% % Vector.Marker = '<';

for tt = t1
    p1 = interp1(t',[x;y;z]',tt)';
    p2 = interp1(t',[x;y;z]',tt+0.07)';

    h = mArrow3(p1,p2);
    h.FaceColor = Gamma.Color;

%     [p1x,p1y,d1] = ds2fig(interp1(t,x,t1(i)), interp1(t,y,t1(i)), interp1(t,z,t1(i)))
%     [p2x,p2y,d2] = ds2fig(interp1(t,dx,t1(i)), interp1(t,dy,t1(i)), interp1(t,dz,t1(i)))
%
%     pcz_arrow(p1x,p1y,p2x,p2y)
end

h = mArrow3([0,0,0],[1,1,1]/2);
h.FaceColor = Gamma.Color;

print 'anal3_vekanal3_Stokes' -dpng -r400

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
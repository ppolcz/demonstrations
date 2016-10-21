%% 
%  
%  file:   arc.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.10.19. Wednesday, 19:30:56
%

P1=[150,300]; P2=[500,600];
P=P2-P1;
[ThC,C]=cart2pol(P(1),P(2));
f=inline('2*L*sin(Th/2)-C*Th','Th','L','C');
options=optimset('Display','off');
for inc=50:100:950
   L=C+inc;
   Th=fzero(f,sqrt(24*(1-C/L)),options,L,C);
   R=C/(2*sin(Th/2));
   [x,y]=pol2cart(ThC+(pi-Th)/2,R);
   CC=P1+[x,y];
   P=P1-CC;
   ThP1=cart2pol(P(1),P(2));
   [x,y]=pol2cart(linspace(ThP1,ThP1+Th),R);
   plot(x+CC(1),y+CC(2)); hold on
end
daspect([1,1,1]); grid; hold off


%% 



% some data
     xyoff=[2,1];
     ba=-30; % degrees
     ea=-90;
     r=10;
     res=1; % resolution
% the engine
     be=sort(mod([ba,ea],360));
     v=be(1):res:be(2);
     line(xyoff(1)+r*cosd(v),xyoff(2)+r*sind(v),...
          'marker','.',...
          'markersize',10,...
          'color',[1,0,0]);
% ...embedded
     line(xyoff(1)+r*cosd(1:360),xyoff(2)+r*sind(1:360),...
          'marker','none',...
          'color',[0,0,0]);
     set(gca,'xlim',[-20,20]);
     axis equal;
     
     %%
     
     
% Pick 2 arbitrary points in the plane.
A = [0 1]; A = rand(1,2);
B = [2 2]; B = rand(1,2);

% The distance between A and B is...
norm(A-B)
% ans =
% 2.2361
% or sqrt(5) if you prefer.

% Choose a radius of 2 for our circle
R = 2; R = 1;

% the angle theta (in radians)
theta = acos(1-(norm(A-B)^2/2/R^2))
% theta =
% 1.1864

% in degrees...
theta*180/pi
% ans =
% 67.976

% Now, find C. There are two solutions.
% Surprise! N is a normal vector to the
% line AB.
N = (A-B)*[0 -1;1 0];
N = N/norm(N);

% one of them is
C1 = (A+B)/2 + N*R*cos(theta/2)
% C1 =
% 0.25838 2.9832

% convince ourselves that C1 is a solution.
norm(C1-B)
% ans =
% 2
norm(C1-A)
% ans =
% 2

% the other colution is
C2 = (A+B)/2 - N*R*cos(theta/2)

% Draw the circular arcs now, one for
% each center.
n = 200;
t = linspace(0,theta,n)';

phi1 = atan2(A(2)-C1(2), A(1)-C1(1));
xy1 = repmat(C1,n,1)+R*[cos(t+phi1),sin(t+phi1)];

phi2 = atan2(A(2)-C2(2), A(1)-C2(1));
xy2 = repmat(C2,n,1)+R*[cos(-t+phi2),sin(-t+phi2)];

% and plot the whole mess.
plot([A(1),B(1)],[A(2),B(2)],'r-o')
hold on
plot(C1(1),C1(2),'g+',C2(1),C2(2),'b+')
axis equal

plot(xy1(:,1),xy1(:,2),'g-',xy2(:,1),xy2(:,2),'b-')
plot([A(1),C1(1)],[A(2),C1(2)],'g-')
plot([B(1),C1(1)],[B(2),C1(2)],'g-')
plot([A(1),C2(1)],[A(2),C2(2)],'b-')
plot([B(1),C2(1)],[B(2),C2(2)],'b-')

hold off
grid on
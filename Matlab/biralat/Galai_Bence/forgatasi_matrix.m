%% Script forgatasi_matrix
%
%  file:   forgatasi_matrix.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.05.30. Tuesday, 13:39:20
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

N1 = 1000;
P1 = [ rand(N1,2) * 2 - 1 zeros(N1,1)];
R1 = rotx(30) * diag([1,4,2]) * roty(40);
P1 = P1 * R1';

N2 = N1;
P2 = [ rand(N2,2) * 2 - 1 zeros(N2,1)];
R2 = rotx(80) * diag([2,1,5]) * roty(-50);
P2 = P2 * R2';

plot3(P1(:,1),P1(:,2),P1(:,3),'.'), hold on
plot3(P2(:,1),P2(:,2),P2(:,3),'.')
axis equal

centroid1 = sum(P1,1) / N1;
centroid2 = sum(P2,1) / N2;

S = (P1 - centroid1(ones(N1,1),:))' * (P2 - centroid2(ones(N2,1),:));
% S = S / (N1-1);

[U,Sigma,V] = svd(S);

P1_ = (V * U' * P1')';
plot3(P1_(:,1),P1_(:,2),P1_(:,3),'.');

%% A norma szerint probalok forgatni
% Mukodik is, de sajnos nem a pontokat forgatja, hanem az abrat

N1 = 1000;
P1 = [ rand(N1,2) * 2 - 1 zeros(N1,1)];
R1 = rotz(50) * roty(10) * diag([4,1,2]);
P1 = P1 * R1';

N2 = N1;
P2 = [ rand(N2,2) * 2 - 1 zeros(N2,1)];
R2 = rotz(-10) * roty(10) * diag([4,1,2]);
P2 = P2 * R2';

[S1,D1] = eig(cov(P1));
n1 = S1(:,1);

[S2,D2] = eig(cov(P2));
n2 = S2(:,1);

rd = cross(n1,n2);
angle = acos(dot(n1,n2)) * 180 / pi;

figure, hold on, axis equal, rotate3d on
h1 = plot3(P1(:,1),P1(:,2),P1(:,3),'.');
% return
h2 = plot3(P2(:,1),P2(:,2),P2(:,3),'.');
% axis equal

rotate(h1,rd,angle)
rotate(h1,[0,0,1],-50)

% view([110,-10])
% view([90,10])
view([10,10])

quiver3(0,0,0,n1(1),n1(2),n1(3),2,'LineWidth',5)
quiver3(0,0,0,n2(1),n2(2),n2(3),2,'LineWidth',5)
quiver3(0,0,0,rd(1),rd(2),rd(3),2,'LineWidth',5)

%% A norma szerint forgatok (nem pont ugy mint ahogy Bence csinalja)

N1 = 1000;
P1 = [ rand(N1,2) * 2 - 1 zeros(N1,1)];
R1 = rotz(50) * roty(20) * diag([4,1,2]);
P1 = P1 * R1';

N2 = N1;
P2 = [ rand(N2,2) * 2 - 1 zeros(N2,1)];
R2 = rotz(-30) * roty(20) * diag([4,1,2]);
P2 = P2 * R2';

[S1,D1] = eig(cov(P1));
n1 = S1(:,1);

[S2,D2] = eig(cov(P2));
n2 = S2(:,1);

R1 = [n1 orth(null(n1'))];
R2 = [n2 orth(null(n2'))];

P1 = (R2 * (R1 \ P1'))';

%%
indices = 1:5:N1;

figure,
subplot(221), hold on, axis equal, rotate3d on
% plot3(P1(:,1),P1(:,2),P1(:,3),'.');
% plot3(P2(:,1),P2(:,2),P2(:,3),'.');
plot3([P1(indices,1) ; P2(indices,1)], [P1(indices,2) ; P2(indices,2)], [P1(indices,3) ; P2(indices,3)],'.')

subplot(222), hold on, axis equal, rotate3d on
% plot3(P1(:,1),P1(:,2),P1(:,3),'.');
% plot3(P2(:,1),P2(:,2),P2(:,3),'.');
plot3([P1(indices,1) ; P2(indices,1)], [P1(indices,2) ; P2(indices,2)], [P1(indices,3) ; P2(indices,3)],'.')
view(30,-10)


% Most pedig z iranyban forgatok

P1r = P1 * rotz(-77)';
subplot(223), hold on, axis equal, rotate3d on
% plot3(P1r(:,1),P1r(:,2),P1r(:,3),'.');
% plot3(P2(:,1),P2(:,2),P2(:,3),'.');
plot3([P1r(indices,1) ; P2(indices,1)], [P1r(indices,2) ; P2(indices,2)], [P1r(indices,3) ; P2(indices,3)],'.')

subplot(224), hold on, axis equal, rotate3d on
% plot3(P1r(:,1),P1r(:,2),P1r(:,3),'.');
% plot3(P2(:,1),P2(:,2),P2(:,3),'.');
plot3([P1r(indices,1) ; P2(indices,1)], [P1r(indices,2) ; P2(indices,2)], [P1r(indices,3) ; P2(indices,3)],'.')
view([10,-20])

%%



figure, hold on, axis equal
% plot3(P1(:,1),P1(:,2),P1(:,3),'.'),
% return
plot3(P2(:,1),P2(:,2),P2(:,3),'.')
axis equal

centroid1 = sum(P1,1) / N1;
centroid2 = sum(P2,1) / N2;

S = (P1 - centroid1(ones(N1,1),:))' * (P2 - centroid2(ones(N2,1),:));
% S = S / (N1-1);

[U,Sigma,V] = svd(S);

P1_ = (V * U' * P1')';
plot3(P1_(:,1),P1_(:,2),P1_(:,3),'.');

%%

(P1 - centroid1(ones(N2,1),:))' * (P1 - centroid1(ones(N1,1),:)) / (N1-1)
R = cov(P1)

[S,D] = eig(R)
Z = zeros(3,1)'

P1_ = (S' * P1')';

plot3(P1_(:,1),P1_(:,2),P1_(:,3),'.'), hold on
% quiver3(Z,Z,Z,S(1,:),S(2,:),S(3,:),'LineWidth',5)
axis equal

%%

N = 30;
P_max = 10;
[d,a] = meshgrid(linspace(0,P_max,N));

F_BG = 1 - 1 ./ (1 + exp(d - a));
F_FG = 1 - 1 ./ (1 + exp(a - d));

figure('Position', [ 491 300 991 338 ], 'Color', [1 1 1])
subplot(121), surf(d,a,F_BG),
plabel x $d$, plabel y $a$,
ptitle '$f_{BG}(d,a) = 1 - \\frac{1}{1 + e^{d-a}}$',
xlim([0,P_max]),
ylim([0,P_max]),
subplot(122), surf(d,a,F_FG),
plabel x $d$, plabel y $a$,
ptitle '$f_{FG}(d,a) = 1 - \\frac{1}{1 + e^{a-d}}$'
xlim([0,P_max]),
ylim([0,P_max]),

ptikz
%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
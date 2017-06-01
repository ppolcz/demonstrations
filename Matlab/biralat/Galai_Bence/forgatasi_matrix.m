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
R2 = rotx(80) * diag([2,1,5]) * roty(-20);
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
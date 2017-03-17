%% Script Mityanak_anyag
%  
%  file:   Mityanak_anyag.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.17. Friday, 16:51:40
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_qLzDQcOKbFimsFUlbIkC = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

B = 3;
A = [1 1 1];

H = tf(B,A);

subplot(221), impulse(H)
subplot(222), step(H)

t = linspace(0,10,1000);
u = sin(t) .* cos(10*t) + 0.01*rand;

subplot(223), lsim(H,u,t)

figure,
bopts = bodeoptions;
bopts.FreqScale = 'linear';
bopts.MagUnits = 'abs';
bopts.XLim = [0.1 10];
bodeplot(H,bopts)

%%

B = [1 0 0];
A = conv([1 1 1],[1 1]);

H = tf(B,A);

subplot(121), impulse(H)
subplot(122), step(H)


%%
% End of the script.
pcz_dispFunctionEnd(TMP_qLzDQcOKbFimsFUlbIkC);
clear TMP_qLzDQcOKbFimsFUlbIkC
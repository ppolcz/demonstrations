%% Script ccs_hf1_2017fall
%  
%  file:   ccs_hf1_2017fall.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 18.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_uwIfmjsxiPeclXdAlMRG = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

A = [
	-2 -3 -8
	-0 -3 -6
	-0 1 -3
	];
B = [ 3 ; 1 ; -1 ];
C = [ 1 , 1 , 1 ];
rank(ctrb(A,B))
eig(A)

f = @(t,x) A*x;
[t,x] = ode45(f, [0,10], randn(3,1));
plot3(x(:,1),x(:,2),x(:,3),'.-'), hold on
axis vis3d

f = @(t,x) A*x + B*sin(t);
[t,x] = ode45(f, [0,20], randn(3,1)*4);
figure(2), plot3(x(:,1),x(:,2),x(:,3),'.-'), hold on
axis vis3d

figure(1), 
subplot(131), plot(t,x(:,1)), xlabel 't'; ylabel 'x1';
subplot(132), plot(t,x(:,2)), xlabel 't'; ylabel 'x2';
subplot(133), plot(t,x(:,3)), xlabel 't'; ylabel 'x3';

impulse(ss(A,B,C,0))


%%
% End of the script.
pcz_dispFunctionEnd(TMP_uwIfmjsxiPeclXdAlMRG);
clear TMP_uwIfmjsxiPeclXdAlMRG
%% Script demo_1
%  
%  file:   demo_1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.13. Tuesday, 19:40:48
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

url = 'http://www.models.life.ku.dk/go-engine?filename=amino.mat';
urlwrite(url,'amino.mat'); % Download amino.mat in this directory.
load amino X;
figure(1); voxel3(X);
figure(2); surf3(X);
figure(3); slice3(X);

%%

R = 4; degree = 3;
sz = [10 15 20 25];
for n = 1:4
    % Use struct_poly to generate polynomial factor vectors
    U{n} = struct_poly(rand(R,degree+1), [], 1:sz(n));
end
T = cpdgen(U);

visualize(T)

%% 3D function visualization

[x,y,z] = ndgrid(-pi:0.2:pi);

f = sin(x.*y) ./ exp(x.^2 + y.^2 + z.^2);

slice3(f), colormap


%%

T = randn(3,5,7);
n = 2;
M = tens2mat(T,n)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
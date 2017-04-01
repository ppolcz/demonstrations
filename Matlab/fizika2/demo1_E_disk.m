%% Script demo1_E_disk
%  
%  file:   demo1_E_disk.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.04.01. Saturday, 20:26:03
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

%% Elso megkozelites

syms x y z u v real 
r = [x;y;z];

N = 10;
[X,Y,Z] = meshgrid(linspace(-2,2,N));

clear Integrand
r_ = [ 
    u.*cos(v)
    u.*sin(v)
    0 
    ];
I = (r - r_) / sum((r-r_).^2)^(3/2) * u;
I_fh = cellfun(@(i) {matlabFunction(I(i),'vars',{u,v,r})},{1;2;3});

lims = {0,1,0,2*pi};

E1 = zeros(size(X));
E2 = zeros(size(Y));
E3 = zeros(size(Z));

for i = 1:numel(X)
    ri = [X(i);Y(i);Z(i)];
    E = cellfun(@(fh) {integral2(@(u,v) fh(u,v,ri),lims{:})},I_fh);
    [E1(i), E2(i), E3(i)] = deal(E{:});        
end

figure, hold on
quiver3(X,Y,Z,E1,E2,E3), drawnow
[U,V] = meshgrid(linspace(lims{1:2},10), linspace(lims{3:4},20));
surf(U.*cos(V), U.*sin(V),U*0);

axis vis3d
view([18, 20])

%% Erovonalak

E = matlabFunction(I,'vars',{u,v,r});
f = @(t,ri) cellfun(@(fh) integral2(@(u,v) fh(u,v,ri),lims{:}),I_fh);

figure, hold
for i = 1:numel(X)
    ri = [X(i);Y(i);Z(i)];
    [t_ode,x_ode] = ode45(f,[0,1],ri);
    plot3(x_ode(1,1),x_ode(1,2),x_ode(1,3),'.b')
    plot3(x_ode(:,1),x_ode(:,2),x_ode(:,3),'b')
    drawnow
end


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
%% 
%  
%  file:   vectorfield_Coulombs_law.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.06. Tuesday, 10:56:21
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Pozitív és negatív ponttöltések töltések elektromos tere (normalizálva)

% Coulomb's constant
ke = 8.99e9;

e = -1.6e-19;

q = 10000 * e;
Q = [ -1 1 -0.1 0.1];

Q_pos = [
    -5 0
    5 0
    0 9
    -2 -9
    ]'

[x,y] = meshgrid(linspace(-10,10,50));
Fx = zeros(size(x));
Fy = Fx;

for i = 1:size(Q_pos,2)
    square_distance = (x-Q_pos(1,i)).^2 + (y-Q_pos(2,i)).^2;
    Fx = Fx + ke * Q(i) * q * (x - Q_pos(1,i)) ./ (square_distance.^(3/2));
    Fy = Fy + ke * Q(i) * q * (y - Q_pos(2,i)) ./ (square_distance.^(3/2));
end
    
Fr = (Fx.^2 + Fy.^2).^(1/2);

fig = figure('Units','normalized', 'Position', [0.3474 0.3611 0.4359 0.5389]);
% quiver(x,y,Fx,Fy);
quiver(x,y,Fx./Fr,Fy./Fr), hold on;
for i = 1:size(Q_pos,2)
    if Q(i) < 0
        h1 = plot(Q_pos(1,i), Q_pos(2,i), '.r', 'linewidth', 10, 'markersize', 20);
    else
        h2 = plot(Q_pos(1,i), Q_pos(2,i), '.b', 'linewidth', 10, 'markersize', 20);
    end
end
axis equal tight
title 'Normalized vector field between some electric point charge' interpreter latex
legend([h1 h2], {'negative','positive'},'Position',[0.85,0.8,0.1,0.1])

%% Ponttöltések elektromos tere véletlenszerű pontokban (normalizálva)

% Coulomb's constant
ke = 8.99e9;

e = -1.6e-19;

Nr = 5;

q = 10000 * e;
Q = randn(1,Nr);

Q_pos = (rand(2,Nr)-0.5)*20;

[x,y] = meshgrid(linspace(min(min(min(Q_pos)),-10),max(max(max(Q_pos)),10),30));
Fx = zeros(size(x));
Fy = Fx;

for i = 1:size(Q_pos,2)
    square_distance = (x-Q_pos(1,i)).^2 + (y-Q_pos(2,i)).^2;
    Fx = Fx + ke * Q(i) * q * (x - Q_pos(1,i)) ./ (square_distance.^(3/2));
    Fy = Fy + ke * Q(i) * q * (y - Q_pos(2,i)) ./ (square_distance.^(3/2));
end
    
Fr = (Fx.^2 + Fy.^2).^(1/2);

fig = figure('Units','normalized', 'Position', [0.3474 0.3611 0.4359 0.5389]);
% quiver(x,y,Fx,Fy);
quiver(x,y,Fx./Fr,Fy./Fr, 0.5), hold on;
for i = 1:size(Q_pos,2)
    if Q(i) < 0
        h1 = plot(Q_pos(1,i), Q_pos(2,i), '.r', 'linewidth', 10, 'markersize', 20);
    else
        h2 = plot(Q_pos(1,i), Q_pos(2,i), '.b', 'linewidth', 10, 'markersize', 20);
    end
end
axis equal tight
title 'Normalized vector field between some electric point charge' interpreter latex
legend([h1 h2], {'negative','positive'},'Position',[0.85,0.8,0.1,0.1])

%% Anod és katód elektromos tere (ponttöltésekkel közelítve)

% Coulomb's constant
ke = 8.99e9;

e = -1.6e-19;

q = 10000 * e;

Nr_anode = 100;
Nr_cathode = 70;

Q = [ 0.01*ones(1,Nr_anode) -0.01*ones(1,Nr_cathode) ];

Q_pos = [
    linspace(-7,7,Nr_anode) linspace(-3,3,Nr_cathode)
    5*ones(1,Nr_anode) -5*ones(1,Nr_cathode)
    ];

[x,y] = meshgrid(linspace(-10,10,20));
Fx = zeros(size(x));
Fy = Fx;

for i = 1:size(Q_pos,2)
    square_distance = (x-Q_pos(1,i)).^2 + (y-Q_pos(2,i)).^2;
    Fx = Fx + ke * Q(i) * q * (x - Q_pos(1,i)) ./ (square_distance.^(3/2));
    Fy = Fy + ke * Q(i) * q * (y - Q_pos(2,i)) ./ (square_distance.^(3/2));
end
    
Fr = (Fx.^2 + Fy.^2).^(1/2);

fig = figure('Units','normalized', 'Position', [0.3474 0.3611 0.4359 0.5389]);
% quiver(x,y,Fx,Fy);
quiver(x,y,Fx./Fr,Fy./Fr, 0.5), hold on;
for i = 1:size(Q_pos,2)
    if Q(i) < 0
        h1 = plot(Q_pos(1,i), Q_pos(2,i), '.r', 'linewidth', 10, 'markersize', 20);
    else
        h2 = plot(Q_pos(1,i), Q_pos(2,i), '.b', 'linewidth', 10, 'markersize', 20);
    end
end
axis equal tight
title 'Normalized electric field between two electrically charged nodes' interpreter latex
legend([h1 h2], {'negative','positive'},'Position',[0.85,0.8,0.1,0.1])

text(7.2,5,['Q1 = -' num2str(Nr_anode/100) 'C'])
text(3.2,-5,['Q2 = +' num2str(Nr_cathode/100) 'C'])

%% Komplex számos megközelítés - NAGYON SZÉP ('Bruno' megoldása)

n = 5; % number of charges
% locations
x = rand(n,1)-0.5;
y = rand(n,1)-0.5;
% charge
q = rand(n,1);
q = q - mean(q);

% Coulumb's number
ke = 8.9875517873681764e9;

xi = linspace(-1,1,33);
yi = linspace(-1,1,33);
[XI YI] = meshgrid(xi,yi);
zi = complex(XI,YI);
z = complex(x,y);

[ZI Z]=ndgrid(zi(:),z(:));

dZ = ZI-Z;
Zn = abs(dZ);

% http://en.wikipedia.org/wiki/Electric_field
E = (dZ./Zn.^3)*(q(:)*e*ke);
E = reshape(E, size(XI));
En = abs(E);
Ex = real(E);
Ey = imag(E);

figure
quiver(XI,YI,Ex./En,Ey./En);
hold on
plot(x, y, 'or')
axis equal 

%% Próba: divergenciája az r/|r|^3 fuggvenynek

syms x y z t real
r = [x;y];

E = r / norm(r)^(3)

divE = trace(jacobian(E));
divE_fh = matlabFunction(divE, 'vars', {x,y});

[xx,yy] = meshgrid(linspace(-1,1,31));
divE_num = divE_fh(xx,yy)
surf(xx,yy,divE_num)

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
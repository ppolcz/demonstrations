%% 
%  
%  file:   Bobe_palyakovetes.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.28. Monday, 12:08:13
%

%% Kettős integrátor

A = [
    0 1
    0 0 
    ];

B = [
    0
    1
    ];

C = eye(2);

sys = ss(A,B,C,0);

K = place(A,B, [-1 -2])
% sys_cls = feedback(sys,K);
% 
% figure, 
% subplot(221), pzmap(sys_cls)
% subplot(222), impulse(sys_cls)
% subplot(223), step(sys_cls)
% 
% sys_all = series([-K 1], sys_cls);

%% Szimulacio diszkret idoben
figure, 

Ts = 0.1;
sysD = c2d(sys,Ts,'zoh');

T = 20;
tref = 0:Ts:T+2*Ts;
x1ref = sin(tref);
x2ref = diff(x1ref)/Ts;
x3ref = diff(x2ref)/Ts;

tref = tref(1:end-2);
x1ref = x1ref(1:end-2);
x2ref = x2ref(1:end-1);

subplot(121), plot(tref, [x1ref ; x2ref ; x3ref]),
title('Referenciajelek')

xref = [x1ref ; x2ref];
x = zeros(2,numel(tref));
e = zeros(2,numel(tref));
u = zeros(1,numel(tref));
for i = 1:numel(tref)-1
   e(:,i) = x(:,i) - xref(:,i);
   u(:,i) = x3ref(:,i) - K*e(:,i);
   
   x(:,i+1) = sysD.a * x(:,i) + sysD.b * u(:,i);
end

subplot(122), plot(tref,x')
title('Szimulacio diszkret idoben')

%% Szimulacio folytonos idoben

A = [
    0 1
    0 0 
    ];

B = [
    0
    1
    ];

u_fh = @(t,x) interp1(tref,x3ref,t) ...
    - K(1)*(x(1) - interp1(tref,x1ref,t)) ...
    - K(2)*(x(2) - interp1(tref,x2ref,t));

f_fh = @(t,x) A*x + B*u_fh(t,x);

ode45(f_fh, [0 T], [0;0]), hold on

plot(tref, xref)

%% Szimulacio folytonos idoben

A = [
    0 1
    0 0 
    ];

B = [
    0
    1
    ];

% Bemenet csak a referencia gyorsulas
u_fh = @(t,x) interp1(tref,x3ref,t);

f_fh = @(t,x) A*x + B*u_fh(t,x);

% Kezdeti értékeket nézzük:
ode45(f_fh, [0 T], [0;0]), hold on

plot(tref, xref)

%% Szimulacio folytonos idoben

A = [
    0 1
    0 0 
    ];

B = [
    0
    1
    ];

% Bemenet csak a referencia gyorsulas
u_fh = @(t,x) interp1(tref,x3ref,t);

f_fh = @(t,x) A*x + B*u_fh(t,x);

% Kezdeti értékeket nézzük:
ode45(f_fh, [0 T], [0;1]), hold on

plot(tref, xref)


%% Robotika beadando

terkep_szaturacio = 0.52;
alpha = 0.9;
szomszedsag = 1;

veges_bemeneti_feszultseg = true;
maximalis_bemeneti_feszultseg = 1000;

%% (1) terkep generalas

% ha itt atallitod a a terkep meretet, akkor kerlek allitsd at a
% simulink modell ket XY-Graph nyelo kirajzolasi tartomanyat is. Ezt
% sajnos csak ilyen primitiv modon tudtam megvalositani
height = 300;
width = 300;

% random generalok teljesen fuggetlen szamokat
map = rand(height,width)*10;

% egy kicsit elsimitom a dolgokat
h  = fspecial('gaussian', 30, 6);
h2 = fspecial('gaussian', 15, 3);
map = conv2(map,h,'same');

% threashold
map(map < 5) = -1;
map(map > 0) = 1;

% megegyszer ugyanezt
map = conv2(map,h,'same');
map(map < (1-terkep_szaturacio)) = -1;
map(map > 0) = 1;

% megszelesitem a falakat hogy elferjen a cuccos
map_rob = conv2(map,h2,'same');

map_rob(map_rob > -1) = 1;
map_rob(map_rob < 1) = -1;

[row, col] = find(map_rob == -1);
i = round(rand * size(row,1));
j = round(rand * size(row,1));

x0 = [row(i);col(i)];
x1 = [row(j);col(j)];

% ezert hozok be meg egy valtozot, mert ezek biztos, hogy mar nem
% lesznek felulirva
INNEN_INDULOK = x0;
IDE_MEGYEK = x1;

%% (2) A* algorithm

map_before = map_rob;

% temp : [pozicio_x;           ez a tomb arra szolgal, hogy berakja azokat
%         pozicio_y;           helyeket amiket mar erintoleges bejart
%         heurisztika;
%         eddig_megtett_ut;
%         honnan_x;
%         honnan_y]
temp = zeros(6,width*height); % jo sok a memoria, lehet pocsekolni
temp(:,1) = [x0; norm(x1-x0); 0; 0; 0];
temp_p = 1;

% route : [pozicio_x;           - ide rakom be azokat amelyen pontokat mar
%          pozicio_y;          kijelolt mint potencialis uthoz tartozo resz
%          honnan_x;            - ebbol fogom visszafejteni a tenyleges
%          honnan_y]           utat
route(1:4,1) = [x0; 0; 0];
route_p = 1;

% itt megadjuk a 8 szomszed relativ koordinatait es tavolsagat az aktualis
% ponttol, ha 'szomsedsag = 0', akkor csak kettessevel veszi, azaz akkor
% csak 4 szomszedot fog vizsgalni, ha nagyon elvetemult lettem volna, akkor
% ilyen alapon berakhattam volna a 2 tavolsagra levo szomszedokat is, de
% akkor az algoritmuson is kell egy kicsit optimalizalni
neig = 8;
dx = [ 0 -1 -1 -1 0 1 1  1;
      -1 -1  0  1 1 1 0 -1];
dr = [1 1.41 1 1.41 1 1.41 1 1.41];   -40;
    l2 = -41;

% az itt maga az A* O(N^2) iteracio, az utkereses
indicator = 1;
while sum(x0 ~= x1) && (temp_p > 0)
    [Y, I] = sort(temp(3,1:temp_p),2,'descend');
    temp(:,1:temp_p) = temp(:,I);

    dist_taken = temp(4,temp_p);
    x0 = temp(1:2, temp_p);

    route(:,route_p) = temp([1 2 5 6],temp_p);
    route_p = route_p + 1;
    temp_p = temp_p - 1;
    for k = 1:(2-szomszedsag):neig
        ujx = x0 + dx(:,k);

        if map_rob(ujx(1), ujx(2)) < 0
            temp_p = temp_p + 1;
            temp(:,temp_p) = [ujx;
                              norm(x1-ujx)*(1-alpha) + (dist_taken + dr(k))*alpha;
                              dist_taken + dr(k);
                              x0];
            map_rob(ujx(1), ujx(2)) = 0;
        end
    end
end
route_p = route_p - 1; % itt talalhato a vegpont (ha sikerult eljutni)


% realroute : [pozicio_x;   --> a tenyleges ut visszafele
%              pozicio_y;
% preallokalva a memoriaban a hely.
% FIGYELEM! HA AZ UT NAGYON EROSEN KACSKARINGOS, AKKOR SZEGFAULT LESZ A
% VEGE!
realroute = zeros(2,width*10+height*10);
realroute_p = 1;

% visszafejtem az utkereso altal kidobott 'route' tombbol a tenyleges utat,
% ugyanis ebben a tombben azok az utkiserletek is elofordulnak amerre
% megprobalt elmenni, de beleutkozott valamibe, vagy rajott, hogy vannak
% jobb utak is.
while route_p > 1
    map_rob(route(1,route_p), route(2,route_p)) = -0.5;
    realroute(:,realroute_p) = route([2 1], route_p);
    realroute_p = realroute_p + 1;
    pfrom = route([3 4], route_p);
    while sum(route([1 2], route_p) ~= pfrom)
        route_p = route_p - 1;
    end
end

% kirajzolom az utkereso altal modositott terkepet. Fel lesznek tuntetve a
% bejart pontok, es a tenyelges ut pontjai
figure(10101), subplot(122), surf(-map_rob);
size(map_rob);
axis tight;
axis equal;
xlabel('x');
view(0,90);
shading interp;

%% (3) Controll
dim = 4;

% a kettos integrator dinamikai modellje a kovetkezo:
A = [0 1 0 0;
     0 0 0 0;
     0 0 0 1;
     0 0 0 0];

% az u(1), u(2) bemenetek matrixa:
B = [0 0;
     1 0;
     0 0;
     0 1];

% az rendszer allapotanak minden egyes parameterere kivancsiak vagyunk
C = eye(4);

% D = 0
D = zeros(4,2);

% Average velocity [pixel/second]
v = 10;


n = realroute_p-1;    % Total number of samples (in refference route)
fs = 100;             % Sampling frequency [sample/seconds] - discretization
Ts = 1/fs;            % Sampling period [seconds/sample] - discretization
T = 40;               % Total period of dynamic system[seconds] - simulink
t0 = 0;               % Initial time of dynamic system [seconds]
tref = linspace(t0,T,n); % Erre a t-re a simulinkes modell miatt van szuksegem

disp(['Az ut hossza: ' num2str(n)])

% Generating discrete state space model
sys = ss(A,B,C,D);
sys = c2d(sys, Ts, 'foh');
[Ad, Bd, Cd, Dd] = ssdata(sys);

% Desired route
x1ref = realroute(1,n:-1:1);
x2ref = realroute(2,n:-1:1);

% The derivatives
v1ref = diff(x1ref); v1ref = [v1ref(1), v1ref];
a1ref = [0 diff(v1ref)];
v2ref = diff(x2ref); v2ref = [v2ref(1), v2ref];
a2ref = [0 diff(v2ref)];

% Set up the input signal, initial conditions
x0 = [x1ref(1);0;x2ref(1);0];
u = [a1ref; a2ref];

% Set up the eigen values to provide the convergence of error dynamics
l1 = -40;
l2 = -41;
disp(['A szabalyzo sajatertekei: ' num2str(l1) '  ' num2str(l2)])
% Visszacsatolasi erosites kiszamitasa (FIGYELEM, minusz elojel)
k = -place([0 1 ; 0 0], [0 ; 1], [l1 l2]);

% Szimulacio
x = zeros(dim,n);
x(:,1) = x0;
for i = 1:n-1
    u(1,i) = u(1,i) + k(1)*(x(1,i)-x1ref(i)) + k(2)*(x(2,i)-v1ref(i));
    u(2,i) = u(2,i) + k(1)*(x(3,i)-x2ref(i)) + k(2)*(x(4,i)-v2ref(i));
    x(:,i+1) = Ad*x(:,i) + Bd*u(:,i);
end

%%% MASSZIV PLOTTOLAS

% dimensions of the box:
box=[1 1 -1 -1 1;
    -3 3 3 -3 -3];
L = box(4)-box(2);
disp(['A kisauto szelessege: ' num2str(L)])

figure, subplot(211), plot(u(1,:)), title('u1');
subplot(212), plot(u(2,:)), title('u2');

figure('DoubleBuffer','on') ;
for i=2:size(x,2)
    clf;
    hold on, grid on;
    angle = atan((x(3,i-1)-x(3,i))/(x(1,i-1)-x(1,i)));
    
    transform_matrix = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    box2 = transform_matrix*box;
    
    plot(x(1,:),x(3,:), 'r-');
    plot(box2(1,:)+x(1,i),box2(2,:)+x(3,i), 'b-')
        
    axis ([0 width 0 height]);
    pause(0.01)
end


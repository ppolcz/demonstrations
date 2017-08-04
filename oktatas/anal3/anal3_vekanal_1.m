%% Analízis III (2017) - I. Vektoranalízis
%  file:   anal3_vekanal_1.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2017.08.04. Friday, 15:15:13
%
%% 
% Az elkövetkezendőkben a Matlab Symbolic Math Toolbox (SMT) által
% kínált vektoranalízis
% (<https://www.mathworks.com/help/symbolic/vector-analysis-1.html
% MathWorks>) függvényeit használjuk: |curl|, |divergence|,
% |gradient|, |jacobian|, |hessian|, |laplacian|, stb...
% 
% További általan definiált vektoranalízishez kapcsolódó
% segédfüggvények (|vekanal_|) megtalálható a
% <https://github.com/ppolcz/demonstrations/tree/master/lib/matlab
% demonstrations GitHub repository>-ban, a |lib/matlab| mappában:

% SMT examples
web(fullfile(docroot, 'symbolic/examples.html'))

% SMT vector analysis
web(fullfile(docroot, 'symbolic/vector-analysis.html'))

%% Divergencia
% Egy vektormező divergenciájának kiszámítása és ábrázolása
syms x y real
r = [x;y];

%%
% 2D vektormező
F = [
    sin(x)
    cos(y)
    ];
pcz_pretty('F(x,y)', F)

%%
% Divergencia szimbolikus kiszámítása
divF = divergence(F,r);
pcz_pretty('div F(x,y)', divF)

%%
% 
% <html><h3>Szimbolikus skalárfüggvény numerizálása és ábrázolása</h3></html>
% 
% Mindenekelőtt létrehozok egy gridet, amelynek pontjait egyesével be
% kell helyettesíteni a szimbolikus függvénybe. 
[xx,yy] = ndgrid(linspace(-4,4,30));

%%
% A behelyettesítés megoldható a |subs| paranccsal, ami viszont igen lassú.
% Ehelyett a szimbolikus függvényt anoním függvénnyé (function
% handle-vé) alakítom.
divF_fh = matlabFunction(divF)

%%
% Majd az anoním függvénybe behelyettesítem az értékeket. Ez
% lényegesen gyorsabb. A objektumok dimenzióira azonban nagyon
% vigyázni kell: |xx| és |yy| változók két dimenziós tömbbök. Érdemes
% őket 1 dimenziós tömbökké alakítani (jelen esetben 2D tömbökként is
% működne, de ha vektormezővel akarom ezt megtenni akkor a 2D tömbbök
% nagyon bekavarnak).
xx_1D = xx(:);
yy_1D = yy(:);

%%%
% Most fog megtörténni a behelyettesítés:
divF_num_1D = divF_fh(xx_1D, yy_1D);

%%%
% Visszaalakítás 2D-be
divF_num = reshape(divF_num_1D, size(xx));

%%%
% Ennek egyszerűsítése végett létrehoztam egy |vekanal_subsmesh|
% függvényt, mely pontosan ezt a műveletet végzi el. Így kellene
% meghívni: 
% 
%   divF_num = vekanal_subsmesh(divF, r, {xx,yy});

figure('Position', [ 672 550 1149 430 ])
subplot(121), mesh(xx,yy,divF_num), hold on
title(sprintf('$F = %s, ~~ \\nabla F = %s$', latex(F'), latex(divF)), ...
    'interpreter', 'latex')
subplot(122), surf(xx,yy,divF_num, 'facealpha', 0.5)
view(0,90), axis equal, axis tight, hold on
drawnow

%%
% Most ábrázoljuk a vektormezőt (majdnem ugyanaz a procedúra, egy kicsit nehezebb).
[F1,F2] = vekanal_subsmesh(F, r, {xx,yy});

subplot(121), quiver3(xx,yy,divF_num,F1,F2,F2*0,1.5)
subplot(122), quiver3(xx,yy,divF_num,F1,F2,F2*0,1.5), colorbar
drawnow

%% Divergencia, rotáció számítása

syms x y z real
r = [x;y;z];

% 2. feladat függvénye
F = [
    y/z
    z/x
    x/y
    ];

% 3. feladat függvénye
F = [
    x^2*y
    y*z
    x*y*z^2
    ];

pcz_display('F(x,y)', F)
pcz_display('div F(x,y)', divergence(F,r))
pcz_display('curl F(x,y)', curl(F,r))

%% Paraméteres felület, dS számítása

syms u v real

S = [
    sin(u)*cos(v)
    sin(u)*sin(v)
    cos(u)
    ];

dSu = jacobian(S,u)
dSv = jacobian(S,v)
dS_vec = simplify(cross(dSu, dSv))
dS_norm = simplify(norm(dS_vec))

%% Vektoranalízis deriválási szabályainak ellenőrzése (bonyolultabb)
% Először deklaráljuk a szimbólikus objektumokat
syms x y z real
r = [x;y;z];

f = sym('f(x,y,z)');
g = sym('g(x,y,z)');

F = [
    sym('F1(x,y,z)')
    sym('F2(x,y,z)')
    sym('F3(x,y,z)')
    ];

G = [
    sym('G1(x,y,z)')
    sym('G2(x,y,z)')
    sym('G3(x,y,z)')
    ];

% Feltételezzük, hogy minden szimbólikus objektum valós (nem komplex)
assume([F,G,f,g,r],'real')

% Gradiens, divergencia, rotáció, vektoriális szorzat műveletek
grad = @(f) jacobian(f,r);
trans = @(F) reshape(F,[1 3]);

% grad: sorvektor
% gradient: oszlopvektor
% cross: olyan lesz a vegeredmeny mint amilyen az elso

% Végül a szabályok ellenőrzése, nullát kell kapjunk minden esetben
pcz_symeq(grad(f*g), f*grad(g) + g*grad(f), '∇(f g) = f ∇g + g ∇f')
pcz_symeq(divergence(f*F,r), grad(f)*F + f*divergence(F,r), '∇(f F) = ⟨∇f,F⟩ + ⟨f,∇F⟩')
pcz_symeq(curl(f*F), cross(gradient(f),F) + f*curl(F), '∇×(f F) = ∇f×F + f ∇×F')
pcz_symeq(divergence(cross(F,G),r), G'*curl(F) - F'*curl(G), '∇(F×G) = ⟨G,∇×F⟩ - ⟨F,∇×G⟩')
pcz_symeq(grad(F'*G), F'*grad(G) + G'*grad(F), '∇⟨F,G⟩ = ⟨F,∇G⟩ + ⟨G,∇F⟩')

%% Vonalintegrál kiszámítása szimbolikus határozatlan integrálás segítségével
% Integráljuk $F(x,y)$-t $\Gamma$ mentén.

syms t x y a b real
r = [x;y];

%%%
% F(x,y) = F(r) kétdimenziós vektormező
F = [
    x^2
    y^2
    ];

%%%
% $\Gamma$ origó középpontú negyed ellepszis. Tengelyeinek hossza $2a$
% és $2b$. Kezdőpont $A(a,0)$, végpont $B(0,b)$.
g = [
    a*cos(t)
    b*sin(t)
    ];

% Integrálási tartomány:
t1 = 0;
t2 = pi/2;

%%%
% $$\Big<F\big(\gamma(t)\big),\dot{\gamma}(t)\Big>$$
Integrand = subs(F,r,g)' * diff(g, t);
pcz_pretty('Integrálandó függvény', Integrand)

%% 
% Szimbolikus határozatlan integrálás
Integral = int(Integrand, t)

%%
% Határok behelyettesítése
I = subs(Integral,t,t2) - subs(Integral,t,t1)

%%
% Matlabos ügyeskedéssel így is lehet. FIGYELEM: |Integral(t)| nem egy
% anoním függvény. Integral(t1) esetén implicite meghívódik a |subs|
% parancs.
Integral(t) = int(Integrand, t)
I = Integral(t2) - Integral(t1)


%% Vonalintegrál kiszámítása szimbolikus határozott ill. numerikus módszer segítségével

syms t x y z real
r = [x;y;z];

%%%
% F(x,y,z) = F(r) háromdimenziós vektormező
F = [
    3*x^2*y^2*z
    2*x^3*y*z
    x^3*y^2
    ];

%%%
% $\Gamma$: Az origót az (1,2,3) ponttal összekötő szakasz.
g = t * [1;2;3];

% Integrálási tartomány:
t1 = 0;
t2 = 1;

%%%
% $$\Big<F\big(\gamma(t)\big),\dot{\gamma}(t)\Big>$$
Integrand = subs(F,r,g)' * diff(g, t)

%% 
% Szimbolikus határozatlan integrálás
Integral = int(Integrand, t)

%%
% Szimbolikus határozott integrálás
Integral = int(Integrand, t, t1, t2)

%%
% Polinomközelítéses numerikus eljárással (először anoním függvénnyé kell alakítani)
Integrand_fh = matlabFunction(Integrand);
Integral = integral(Integrand_fh, t1, t2)

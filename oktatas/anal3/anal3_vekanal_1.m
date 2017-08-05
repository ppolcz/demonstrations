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

%%
% <html><h1>Divergencia, rotáció, gradiens, Jacobi mátrix számítása</h1></html>

%% Egy vektormező divergenciájának kiszámítása és ábrázolása
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

%% Szimbolikus skalárfüggvény numerizálása és ábrázolása
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
subplot(122), surf(xx,yy,divF_num, 'facealpha', 0.5), shading interp, grid off
view(0,90), axis equal, axis tight, hold on, colorbar
drawnow

%% Szimbolikus vektormező numerizálása és ábrázolása
% Most ábrázoljuk a vektormezőt (majdnem ugyanaz a procedúra, egy kicsit nehezebb).
[F1,F2] = vekanal_subsmesh(F, r, {xx,yy});

subplot(121), quiver3(xx,yy,divF_num,F1,F2,F2*0,1.5)
subplot(122), quiver3(xx,yy,divF_num,F1,F2,F2*0,1.5)
drawnow

%% Deriváltak számítása

syms x y z real
r = [x;y;z];

% Vektormező
F = [
    x^2*y
    y*z
    x*y*z^2
    ];

% Skalármező
f = sin(x)*cos(y)*z^2;

pcz_display('F(x,y)', F)
pcz_display('div F(x,y)', divergence(F,r))
pcz_display('curl F(x,y)', curl(F,r))
pcz_display('jacobian F(x,y)', jacobian(F,r))

pcz_display('jacobian f(x,y) = `grad f(x,y)` [row-vector]', jacobian(f,r))
pcz_display('gradient f(x,y) [column-vector]', gradient(f,r))

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

%%
% <html><h1>Numerikus integrálás</h1></html>

%% Az |ode45| függvény
%
% <html>Az <a
% href="http://www.mathworks.com/help/matlab/ref/ode45.html"><tt>ode45</tt></a>
% egy numerikus solver, mely a $\frac{\mathrm{d} x}{\mathrm{d} t} =
% f(t,x)$ közönséges nemlineáris differenciál egyenletet oldja meg
% negyed- vagy ötödrendű <a
% href="https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods">Runge-Kutta
% módszerrel</a>, változó időbeni $T_s$ lépésközzel. A differenciál
% egyenletben az ismeretlen egy $x: \mathbb{R} \mapsto \mathbb{R}^n$
% időtől függő vektor értékű függvény.</html>
%
% <html> Ezt a megoldót numerikus primitívfüggvény keresésére is
% használhatjuk. Legyen $F:\mathbb{R} \mapsto \mathbb{R}^n$ az
% ismeretlen vektor értékű $x$-ben változó függvény. Ismerjük $F$
% függvény deriváltját: $F'(x) = f(x)$ és $F$ értékét $x_0$ pontban.
% Ekkor $F(x) = \int_{x_0}^{x}f(s)\mathrm{d}s$. </html>

f = @(x,~) 2*x; % ez lehetne valami extémebb függvény is
x0 = 0; x_max = 5; F0 = -1;
[x,F] = ode45(f,[x0 x_max],F0);
figure, plot(x,F)

%%
% Az |ode45| által visszaadott $m\times n$ méretű |F| tömb az
% $F(x)$ primitív függvény értékeit fogja tartalmazni az $x_i$,
% $i\in\{1,...,m\}$ pontokban, az $m\times 1$ méretű |x| tömb
% pedig az $x_i$ értékeket.

%% Az |integral| függvény
%
% <html>Az <tt><a
% href="http://www.mathworks.com/help/matlab/ref/integral.html">integral</a>(fun,a,b)</tt>
% függvény kiszámítja egy |fun| anonim függvénnyel adott egyváltozós
% függvény határozott integrálját $D = [a,b]$ intervallumon. Számoljuk
% ki a következő integrált: $$\int\limits_0^{\frac{\pi}{2}}
% 4\cos(x)\sin(x)^2 - \cos(x)^2\sin(x) ~\mathrm{d}x$$ </html>

f = @(x) 4*cos(x).*sin(x).^2 - cos(x).^2.*sin(x);
a = 0;
b = pi/2;
I = integral(f, a,b)

%%
% <html><h1>Vonalintegrál felületintegrál</h1></html>
%
% <html><blockquote class="danger"> Matlabban számítsuk ki numerikusan
% mekkora munkát gyakorol egy $\boldsymbol F(\boldsymbol r)$ erőtér
% egy anyagi pontra, miközben az anyagi pont a $\Gamma$ által leírt
% görbe mentén halad. Magyarán szólva, integráld az $\boldsymbol
% F(\boldsymbol r)$ vektormezőt $\Gamma$ görbe mentén. $\boldsymbol
% F(\boldsymbol r)$ és $\Gamma$ tetszőlegesen megválasztható,
% támpontként szolgálhat az 1. gyakorlat 5-7. feladata. Ugyanazokat a
% függvényeket is lehet használni. </blockquote> <h5>Támpont</h5> <ol>
%     <li>Definiáljunk egy $x$ és $y$-tól függő <tt>F</tt>, majd egy $t$-től függő <tt>gamma</tt> szimbolikus függvényt.</li>
%     <li>$\gamma(t)$ deriváltjának kiszámításához használjuk a <tt><a href="http://www.mathworks.com/help/matlab/ref/diff.html">diff</a></tt> parancsot.</li>
%     <li>A <a href="matlab_segedlet#subs"><tt>subs</tt></a> parancs segítségével helyettesítsük be <tt>[x;y]</tt> helyébe a <tt>gamma</tt>-t, hogy megkapjuk $\boldsymbol F(\boldsymbol \gamma(t))$-t.</li>
%     <li>A szimbolikus <tt>t</tt> változótól függő integrandust alakítsuk anoním függvénnyé a <a href="matlab_segedlet#matlabFunction"><tt>matlabFunction</tt></a> segítségével. Nevezzük el (pl.) <tt>Integrand_fh</tt>-nek</li>
%     <li>Végül hívjuk meg az <tt>integral</tt> parancsot numerikus integrálás végett: <br><tt>I = integral(Integrand_fh,t0,t1)</tt></li>
% </ol>
% </html>
%
% <html> <blockquote class="danger"> Matlabban számítsuk ki
% numerikusan mekkora a <i>hozama</i> egy $\boldsymbol F(\boldsymbol
% r)$ vektormező által leírt áramlásnak egy $\boldsymbol S(u,v)$
% paraméteresen megadott felületen keresztül. <br> Vagyis:
% \begin{align}
%     \int_S \boldsymbol F(\boldsymbol{r}) \mathrm{d}\boldsymbol{S} =
%     \int_S F(\boldsymbol{r}) \boldsymbol{n}\mathrm{d} S = ?
% \end{align} </blockquote> <h5>Támpont</h5> <p>Az eljárás majdnem
% ugyanaz mint vonalintegrál esetén, kettős integrál kiszámításához
% pedig használjátok az <tt><a
% href="http://www.mathworks.com/help/matlab/ref/integral2.html">integral2</a></tt>
% függvényt.</p> </html>

%% Vonalintegrál kiszámítása szimbolikus határozatlan integrálás segítségével
% Integráljuk $\boldsymbol F(x,y)$-t $\Gamma$ mentén.

syms t x y a b real
r = [x;y];

%%%
% $\boldsymbol F(x,y) = \boldsymbol F(\boldsymbol r)$ kétdimenziós vektormező
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
% Integrálandó függvény: $\left<\boldsymbol F\big(\boldsymbol \gamma(t)\big),\dot{\boldsymbol \gamma}(t)\right>$
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
% $\boldsymbol F(x,y,z) = \boldsymbol F(\boldsymbol r)$ háromdimenziós vektormező
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
% Integrálandó függvény: $\left<\boldsymbol F\big(\boldsymbol \gamma(t)\big),\dot{\boldsymbol \gamma}(t)\right>$
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

%% Felületintegrál számítása

syms u v real
syms x y z real
r = [x;y;z];

%%%
% Vektormező
F = [
    x^2*sin(z)
    x*y
    z^2*x
    ];

%%%
% Felület paraméteres megadása
S = [
    sin(u)*cos(v)
    sin(u)*sin(v)
    cos(u)
    ];

%%%
% $\mathrm{d}\boldsymbol{S} = \left(\boldsymbol S'_u \times \boldsymbol S'_v \right) \mathrm{d}(u,v)$  számítása
dSu = jacobian(S,u)
dSv = jacobian(S,v)
dS = simplify(cross(dSu, dSv))

%%
% $\boldsymbol F(\boldsymbol r)$-be helyettesítjük $\boldsymbol S(u,v)$-t.
FSuv = subs(F,r,S)

%%
% Itegrálandó: $\left<\boldsymbol F\big(\boldsymbol S(u,v)\big), \boldsymbol S'_u \times \boldsymbol S'_v\right>$
Integrand = FSuv' * dS

%%
% Anoním függvénnyé alakítás
Integrand_fh = matlabFunction(Integrand,'vars',{u v})

%%
% Integrálás $u = \left[\frac{\pi}{6},\frac{\pi}{3}\right]$,
% $v = \left[\frac{\pi}{4},\frac{\pi}{2}\right]$ tartományon.
integral2(Integrand_fh,pi/6,pi/3,pi/4,pi/2)


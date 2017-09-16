%% CCS 1. gyakorlat
%  
%  file:   d2017_09_14_gyak1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 16.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Szimbolikus számítások
% Szimbolikus valtozok letrehozasa
syms t s real

%%
% Szimbolikus kifejezesek szorzatainak felbontasa
expand((t+1)^2)

%%
% Szimbolikus fuggveny letrehozasa
f(t) = sin(3*t) + 2 + 3*s;

%%
% Szimbolikus kifejezes letrehozasa
g = 4*cos(3*t) + 2 + s^2;

%%
% Szimbolikus fuggveny kiertekelese adott pontban
f(1) % t <-- 1

%%
% Szimbolikus kifejezes kiertekelese adott pontban
subs(g,t,1)

%%
% Szimbolikus fuggveny/kifejezes derivalasa
diff(f)

%%
% Szimulikus kifejezes hatarozatlan integralja egy valtozo szerint
int(f,t)

%%
% Szimulikus kifejezes hatarozott integralja egy valtozo szerint. Pl.
% $\int_0^1 f(t,s) \mathrm{d}t$.
int(f,t,0,1)

%%
% Szimbolikus fuggveny/kifejezes derivalasa s szerint
diff(f,s)
diff(g,s)

%% Szimbolikus Laplace transzformáció és inverze
% Paraméter
syms a real

f = sin(3*t) + 2 + exp(-4*t) + exp(-a*t)*sin(t);
F = laplace(f,t,s);
pretty(F)

%%
% Inverz transzformáció
syms R C real
H(s) = s/(s*R + 1/C)
h(t) = ilaplace(H,s,t)
pretty(h)

%% Parciális törtekre bontás szimbolikusan
% Egy nagyon elvetemült függvény
H = (s^2 + 5*s + 7) / (s^7 + s^2 + 2*s + 1);
pretty(H)
help sym/partfrac
H_partfrac = partfrac(H,s,'factormode','complex')
H_vpa = vpa(H_partfrac,2)
disp('H(s) = ')
pretty(H_vpa)

%%
% Egy szép függvény parciális törtekre bontása
H1 = 1 / (s^2 + 3*s + 2);
H2 = partfrac(H1,s);
pretty(H1 == H2)

%%
% Komplex parciális törtekre bontás
H1 = 1 / (s^2 + 2*s + 2);
H2 = partfrac(H1,s,'factormode','complex');
pretty(H1 == H2)

%% Szimbolikus parciális törtekre bontás - összehasonlítás
% Factormode: rational [default]
H1 = (s^2 + 1) / expand((s^2 + 3*s + 2) * (s+4) * (s^2 + 2*s + 2));
H2 = partfrac(H1,s,'factormode','rational');
pretty(H1 == H2)

%% 
% Factormode: complex
H2 = sym(partfrac(H1,s,'factormode','complex'));
pretty(H1 == H2)

%%
% Factormode: full
H2 = sym(partfrac(H1,s,'factormode','full'));
pretty(H1 == H2)

%% Numerikus parciális törtekre bontás
% Alakítsuk át a szimbolikus kifejezést numerikussá. Számláló nevező
% szétválasztása:
[num,den] = numden(H1)

%%
% Polinomok nimerikus reprezentációja.
% 
% $$\frac{B(s)}{A(s)} = \frac{r_1}{s - p_1} + \frac{r_2}{s - p_2} +
% ... + \frac{r_n}{s - p_n} + K(s) $$
B = sym2poly(num)
A = sym2poly(den)

%%
% Numerikus parciális törtekre bontás:
[r,p,k] = residue(B,A)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb
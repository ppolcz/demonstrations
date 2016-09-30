%%
%
%  file:   sym_vektoranalizis.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.09.07. Wednesday, 13:25:02
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%% Szorzat deriválási szabályok

% Először deklaráljuk a szimbólikus objektumokat
syms x y z
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

r = [x;y;z];

% Feltételezzük, hogy minden szimbólikus objektum valós (nem komplex)
assume([F,G,f,g,r],'real')

% Gradiens, divergencia, rotáció, vektoriális szorzat műveletek
grad = @jacobian;
div = @(F) diff(F(1),x) + diff(F(2),y) + diff(F(3),z);
rot = @(F) -[
    diff(F(2),z) - diff(F(3),y)
    diff(F(3),x) - diff(F(1),z)
    diff(F(1),y) - diff(F(2),x)
    ];
cross = @(F,G) [
     F(2)*G(3) - F(3)*G(2)
     F(3)*G(1) - F(1)*G(3)
     F(1)*G(2) - F(2)*G(1)
     ];

% Végül a szabályok ellenőrzése, nullát kell kapjunk minden esetben
simplify(grad(f*g) - (f*grad(g) + g*grad(f)))
simplify(div(f*F) - (grad(f)*F + f*div(F)))
simplify(rot(f*F) - (cross(grad(f),F) + f*rot(F)))
simplify(div(cross(F,G)) - (G'*rot(F) - F'*rot(G)))

%%

F = [
    x^2*y
    y*z
    x*y*z^2
    ];

disp('div(F) = '), pretty(div(F))
disp('rot(F) = '), pretty(rot(F))

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
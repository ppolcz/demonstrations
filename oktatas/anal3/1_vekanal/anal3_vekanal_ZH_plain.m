%% ZH-ra gyakorló feladatok megoldásaikkal együtt
% File: anal3_vekanal_ZH.mlx
% 
% Author: Peter Polcz <ppolcz@gmail.com> 
% 
% Created on 2017. October 23.
%% F2 - <http://users.itk.ppke.hu/~polpe//files/targyak/anal3/szorgalmi/anal3_zh1_gyakorlo_17.pdf Feladat itt olvasható>

syms u v real
syms x y z real
r = [x;y;z];
%% 
% Vektormező

F = [
    0
    0
    z
    ];

dviF = divergence(F,r)
%% 
% Tehát, használva a G-O tételt, csupán az 1-et kell integrálni a kúp belsejében. 
% Eredményképpen a kúp térfogatát kell kapjuk.
% 
% Első módszer: $J = \displaystyle \int_{-1}^{1} \int^{\sqrt{1 - x^2}}_{-\sqrt{1 
% - x^2}} \int_{\sqrt{x^2+y^2}}^{1} ~1 ~ \mathrm{d} z \mathrm{d} y \mathrm{d} 
% x$

I3_xyz = integral3(@(x,y,z) ones(size(x)), ...
    -1, 1, ...
    @(x) -sqrt(1 - x.^2), @(x) sqrt(1 - x.^2), ...
    @(x,y) sqrt(x.^2 + y.^2), 1)
%% 
% Második módszer: $J = \displaystyle \int_{0}^{1} \int^{2\pi}_{0} \int_{r}^{1} 
% ~r ~ \mathrm{d} z  \mathrm{d} \theta \mathrm{d} r$, azaz, áttértünk hengerkoordinátákra.

I3_rtz = integral3(@(r,t,z) r, ...
    0, 1, ...
    0, 2*pi, ...
    @(r,t) r, 1)
%% 
% Kúp térfogata: $J = \frac{\pi R^2 \cdot h}{3}$, ahol $R=1$(az alapterület 
% sugara) és $h=1$ (a kúp magassága).

R = 1;
h = 1;
V_kup = pi*R^2 * h / 3
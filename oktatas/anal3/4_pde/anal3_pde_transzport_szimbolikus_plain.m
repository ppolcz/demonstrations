%% Transzport egyenlet
%% Házi feladat (2017, 11. házi) $\left\lbrack {\mathrm{HF}}_1 \right\rbrack$
% $u'_t + 2 u'_x = x^2 + 4 t x$, $u\left(x,0\right)=0$

syms a s x t real
syms u(x,t)

b = 2;

f(x,t) = x^2 + 4*t*x
dz(s) = collect(f(x + b*s, t + s),s)
u(x,t) = int(dz,s,-t,0)
%% Házi feladat (2017, 11. házi) $\left\lbrack {\text{HF}}_2 \right\rbrack$
% $u'_t - 2 u'_x = 0$, $u\left(x,0\right)=\mathrm{sin}\left(x\right)$.
% 
% _Megoldás:_
% 
% Legyen $z\left(s\right)=u\left(x-2s,t+s\right)$, ezért $z^{\prime } \left(s\right)=u_t^{\prime 
% } -{2u}_x^{\prime } =0$.
% 
% Tehát 
% 
% $$u\left(x,t\right)=z\left(0\right)=z\left(-t\right)=u\left(x+2t,0\right)=\mathrm{sin}\left(x+2t\right)\ldotp$$
% 
% Vagyis $u\left(x,t\right)=\mathrm{sin}\left(x+2t\right)$.
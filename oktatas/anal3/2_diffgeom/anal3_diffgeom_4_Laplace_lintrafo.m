%% Script anal3_diffgeom_4_Laplace_lintrafo
%  
%  File:   anal3_diffgeom_4_Laplace_lintrafo.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. November 29.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH VERBOSE 
SCOPE_DEPTH = 0;
VERBOSE = 1;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Lineáris transzformáció

syms x y u v real

Z = [ x ; y ];
Zp = [ u ; v ];

syms a b c d real

R = [
    a*x + b*y
    c*x + d*y
    ];

%%
% Kovariáns $\vec Z_i$ bázisvektorok (oszloposan)
Z_i = jacobian(R,Z)

%%
% Kovariáns $Z_{ij}$ metrika tenzor 
Z_ij = simplify(Z_i'*Z_i)

%%
% Kontravariáns $Z_{ij}$ metrika tenzor 
Zij = inv(Z_ij)

%%
% Kontravariáns $\vec Z^i$ bázisvektorok (sorosan)
% Zi = Z_ij * Z_i

%%
% Christoffel symbol $\Gamma_{ij}^k$

n = numel(Z);
Gamma = sym(zeros(n,n,n));

for k = 1:n % delta spans the variable labels over which symbols will be calculated
  for j = 1:n
    for i = 1:n
      for m = 1:n
        Gamma(i,j,k) = Gamma(i,j,k) + 0.5 * Zij(k,m) * ( ...
          diff(Z_ij(m,i), Z(j)) + diff(Z_ij(m,j), Z(i)) - diff(Z_ij(i,j), Z(m)) ...
          );
      end
    end
  end
end
Gamma

%% Divergencia az új koordinátákban
% Először: kovariáns derivált számolása $\nabla_j V^i$, ahol $\vec V =
% V^1 \vec Z_r + V^2 \vec Z_\t$, továbbá: $V^i =
% \begin{pmatrix} 1 \\ 0 \end{pmatrix}$, ezért $\vec V =
% \vec Z_r$

Vi = [
    str2sym('V1(u,v)')
    str2sym('V2(u,v)')
    ];

Nabla_jVi = jacobian(Vi,Zp);

for j = 1:n
    for i = 1:n
        for m = 1:n
            Nabla_jVi(i,j) = Nabla_jVi(i,j) + ...
                Gamma(j,m,i)*Vi(m);
        end
    end
end

Nabla_jVi

div_Vi = trace(Nabla_jVi)

%% Laplace az új koordinátákban
% Először kiszámítjuk a második kontravariáns deriváltat:

F = sym('F(u,v)');

Nabla_iNabla_jF = sym(zeros(n,n));
for i = 1:n
    for j = 1:n
        Nabla_iNabla_jF(i,j) = diff(F,Zp(i),Zp(j));
        for k = 1:n
            Nabla_iNabla_jF(i,j) = Nabla_iNabla_jF(i,j) - Gamma(i,j,k) * diff(F,Z(k));
        end
    end
end

LaplaceF = sym(0);
for i = 1:n
    for j = 1:n
        LaplaceF = LaplaceF + Zij(i,j) * Nabla_iNabla_jF(i,j);
    end
end

LaplaceF = expand(LaplaceF)
latex(ans)

b = 0;
c = 0;
subs(LaplaceF)


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
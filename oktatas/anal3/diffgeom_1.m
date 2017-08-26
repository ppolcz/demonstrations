%% Descartes to polar (anal3_diffgeom_1)
%  
%  file:   anal3_diffgeom_1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.07. Monday, 09:52:56
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

%% Áttérés Descartes koordináta rendszerből polárkoordinátákra

syms x y r t real

Z = [ x ; y ];
Zp = [ r ; t ];

Mapping = [
    r*cos(t)
    r*sin(t)
    ];

Jip = jacobian(Mapping, Zp);
pcz_latex(Jip, {'t' '\\\\t'})

assume(in(r,'real') & r > 0 & x > 0 & y > 0)

Zp_sol = solve(Mapping - Z, Zp)

Mappingp(r,t) = simplify([
    Zp_sol.r(1)
    Zp_sol.t(1)
    ])

Mappingp2(r,t) = [
    (x^2 + y^2)^(1/2);
    atan2(y,x)
    ];

Jpi = simplify(jacobian(Mappingp2, Z))
pcz_latex(Jpi,2)

%% Polárkoordináta rendszer bázisvektorai 
% Geometriai módszer - legáltalánosabb

toDescartes = matlabFunction(Mapping, 'vars', {Zp});

h = 0.0001;

R = [3 ; -pi/6];
Rr = R + [h ; 0];
Rt = R + [0 ; h];

R_ = toDescartes(R);
Rr_ = toDescartes(Rr);
Rt_ = toDescartes(Rt);

Zr_ = (Rr_ - R_) / h;
Zt_ = (Rt_ - R_) / h;

figure
polar(0,5), hold on, title(['h = ' num2str(h)])
polar(R(2),R(1),'.')
p1 = polar([R(2) Rr(2)],[R(1) Rr(1)]);
p1.LineWidth = 4;
p2 = polar([R(2) Rt(2)],[R(1) Rt(1)]);
p2.LineWidth = 4;

quiver(R_(1),R_(2),Zr_(1),Zr_(2), 'Color', p1.Color / 2)
quiver(R_(1),R_(2),Zt_(1),Zt_(2), 'Color', p2.Color / 2)

print(['h' num2str(h) '.png'],'-dpng')

%% Polárkoordináta rendszer bázisvektorai 
% A polárkoordináták mögé odaképzeljuk a Descartes coordinátákat.

% r: sugar
% t: theta
% p: phi
syms x y z r t p real
Z = [ r ; t ];
Z = [ r ; t ; p];

%%%
% 
R = [
    r*cos(t)
    r*sin(t)
    ];

R = [
    r*cos(t)*sin(p)
    r*sin(t)*sin(p)
    r*cos(p)
    ];

%%
% $\vec Z_i$ bázisvektorok külön-külön számolva
Zr = diff(R,r)
Zt = diff(R,t)
Zp = diff(R,p)

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

%% 
% Covariáns derivált számolása $\nabla_j V^i$, ahol $\vec V =
% V^1 \vec Z_r + V^2 \vec Z_\t$, továbbá: $V^i =
% \begin{pmatrix} 1 \\ 0 \end{pmatrix}$, ezért $\vec V =
% \vec Z_r$

Vi = [
    1
    0
%     0
    ];

Nabla_jVi = jacobian(Vi,Z);

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

%%
% Kiszámoljuk a divergenciáját Descartes koordináta rendszerben is!

syms x y z real
Zp = [x ; y];
% Zp = [x ; y ; z];

Vi = [
    x
    y
%     z
    ] / sqrt(x^2 + y^2);

div_Vi = simplify(divergence(Vi,Zp))

%% Divergencia polárkoordinátákban
% Először: kovariáns derivált számolása $\nabla_j V^i$, ahol $\vec V =
% V^1 \vec Z_r + V^2 \vec Z_\t$, továbbá: $V^i =
% \begin{pmatrix} 1 \\ 0 \end{pmatrix}$, ezért $\vec V =
% \vec Z_r$

syms r t p real
Z = [r ; t];
% Z = [r ; t ; p];
n = numel(Z);

Vi = [
    sym('V1(r,t)')
    sym('V2(r,t)')
    ];

% Vi = [
%     sym('V1(r,t,p)')
%     sym('V2(r,t,p)')
%     sym('V3(r,t,p)')
%     ];

diff(Vi,t)

Nabla_jVi = jacobian(Vi,Z);

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

%% Laplace polárkoordinátákban
% Először kiszámítjuk a második kontravariáns deriváltat:

F = sym('F(r,t)');
% F = sym('F(r,t,p)');

Nabla_iNabla_jF = sym(zeros(n,n));
for i = 1:n
    for j = 1:n
        Nabla_iNabla_jF(i,j) = diff(F,Z(i),Z(j));
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

expand(LaplaceF)
latex(ans)

%%
% Kiszámoljuk a divergenciáját Descartes koordináta rendszerben is!

syms x y real
Z = [x ; y];

Vi = [
    x
    y
    ] / sqrt(x^2 + y^2);

div_Vi = simplify(divergence(Vi,Z))

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
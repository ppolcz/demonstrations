%% 
%  
%  file:   anal3_8het.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:57:51
%

%% Thomas - Garrity 6.1.1 Tetel konstruktiv bizonyitasa
% Az $n$ dimenzios terben veszek $k$ darab vektort A tetel szerint a
% $k$ dimenzios paralelogramma terfogata: 
% $V = \sqrt{\mathrm{det}(A^TA)}$
% 
% Bizonyitas: letezik olyan $R$ $n\times n$-es
% transzformacios matrix amelynek segitsegevel a $v_1,...,v_k$
% vektorok ugy forgathatok (jeloljuk ezeket $w_i$-kel), hogy a $w_1$
% parhuzamos legyen $e_1$-el, a $w_2$ az $(e_1,e_2)$ sikjaban legyen,
% $w_3$ az $(e_1,e_2,e_3)$ alterben legyen, stb..., vagyis a $w_i$
% elforgatott vektor minden koordinata erteke legyen nulla $i+1$-tol
% $n$-ig.

n = 5;
k = 3;

fprintf('k darab n dimenzios vektor: ')
v = rand(n,k)

HyperVolume1 = sqrt(det(v'*v))

fprintf('Transzformacios matrix (ezt meg ortonormalni kell, \nhogy ne valtoztassa meg a szogeket es a hosszusagokat)\n')
fprintf('A transzformacios matrix elso k eleme a v_1, ..., v_k, \na tobbi n-k elem az utolso n-k db egysegvektor')
T = [ v [ zeros(k,n-k) ; eye(n-k) ] ]

fprintf('Ortonormalt transzformacios matrix (QR decomposition segitsegevel)')
[Q,~] = qr(T)

fprintf('Ugyanaz a k darab n dimenzios vektor, \ncsak egy kicsit elforgatva T = Q^{-1} -el, \nvegyuk eszre, hogy milyen nagyon szepek ezek a vektorok!')
w = Q\v

fprintf('Ellonorizzuk le, hogy az sqrt(det(w''*w)) itt is ugyanazt az eredmenyt adja-e?')
HyperVolume2 = sqrt(det(w'*w))'

fprintf('A kapott w vektorok utolso nemnulla eleimeinek szorzata, \namibol geometriailag jol latszik, hogy ez tenyleg a terfogatot adja:')
HyperVolume3_elojeles = prod(diag(w))
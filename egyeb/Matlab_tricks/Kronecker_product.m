%%
%  File: Kronecker_product.m
%  Directory: 2_demonstrations/egyeb/Matlab_tricks
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2020. June 16. (2019b)
%

[He,O,I] = he;

%% (v ⊗ In) w = (Im ⊗ w) v
% De altalaban NEM igaz, hogy (A ⊗ B) C = (B ⊗ C) A

n = round(rand*10 + 3);
m = round(rand*10 + 3);

v = randn(n,1);
w = randn(m,1); 

ZERO = kron(v,I(m)) * w - kron(I(n),w) * v;
pcz_symzero_report(ZERO)

%% (v ⊗ I) S = (v ⊗ I) (1 ⊗ S) = v ⊗ S
% Altalaban:
% (A ⊗ In) (Im ⊗ B) = A ⊗ B (mixed multiplication property)

n = round(rand*10 + 5);
m1 = round(rand*10 + 5);
m2 = round(rand*10 + 5);
b = 1;

S = randn(m1,m2);
v = randn(n,b);

ZERO = kron(v,I(m1)) * S - kron(v,S);
pcz_symzero_report(ZERO)

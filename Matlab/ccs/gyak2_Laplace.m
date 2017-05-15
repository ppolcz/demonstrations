%% 
%  
%  file:   gyak2_Laplace.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.23. Thursday, 13:46:44
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Kezdetiérték feladat megoldása sajátérték felbontással
% Lineáris differenciálegyenlet rendszer: $\dot{x} = A x, ~~~ x(0) =
% x_0$ Megoldás: $x(t) = e^{A t} = S e^{D t} S^{-1}$, ahol $e^{Dt} =
% \mathrm{diag}(e^{\lambda_i t})$

syms t real

A = [2 3 ; 2 1];
x0 = [0;1];

[S,D] = eig(A);

% Kezzel kiszámolt:
S1 = [
    3/2   1
    1    -1
    ];

SDS_A_iszero = S * D / S - A
SDS_A_iszero = S1 * D / S1 - A

exp_Dt = diag(exp(diag(D)*t));
fprintf('\nexp(Dt) = \n\n')
pretty(exp_Dt)

exp_At = expand(S * exp_Dt / S);
fprintf('\n[Matlabbal szamolt sajatvektorok] \nexp(At) = \n\n'), pretty(exp_At)

exp_At = expand(S1 * exp_Dt / S1);
fprintf('\n[Kezzel szamolt sajatvektorok eseten] \nexp(At) = \n\n'), pretty(exp_At)

xt = exp_At * x0;
fprintf('\nA differencialegyenlet megoldasa: x(t) = \n\n')
pretty(expand(xt))

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
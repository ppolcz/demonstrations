%% Script segedszamitasok_2017_09_13_gyak1
%  
%  file:   segedszamitasok_2017_09_13_gyak1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 13.
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_wtNPjzxHKNoJIigzXrEl = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Vonalintegrál kiszámítása - ellipszis mentén

syms a b x y t real
r = [x;y];

F = [
    x^2
    y^2
    ];

gamma = [
    a*cos(t)
    b*sin(t)
    ];

Dgamma = diff(gamma,t);

Dgamma = subs(F,r,gamma);

Integrand = Dgamma' * Dgamma;

Vonalintegral_erteke = int(Integrand, t, 0, pi/2)

%% Vonalintegrál kiszámítása - egyenes mentén

syms x y z t real
r = [x;y;z];

F = [
    3*x^2*y^2*z
    2*x^3*y*z
    x^3*y^2
    ];

A = [0;0;0];
B = [1;2;3];
gamma(t) = (B-A)*t + A;

Dgamma = diff(gamma,t);

Fgamma = subs(F,r,gamma);

Integrand = Fgamma' * Dgamma;

Vonalintegral_erteke = int(Integrand, t, 0, 1)

f = potential(F,r)

Vonalintegral_erteke_potenciallal = subs(f,r,B) - subs(f,r,A)

%% Vonalintegrál kiszámítása - egyenes mentén

syms x y z t real
r = [x;y;z];

F = [
    y*z
    x*z
    x*y
    ];

A = [-1;2;0];
B = [5;5;9];
gamma(t) = (B-A)*t + A;
gamma(t) = [
    2*t^2
    3*t-5
    t
    ];

A = gamma(0);
B = gamma(3);


Dgamma = diff(gamma,t);

Fgamma = subs(F,r,gamma);

Integrand = Fgamma' * Dgamma;

Vonalintegral_erteke = int(Integrand, t, 0, 3)

f = potential(F,r)

Vonalintegral_erteke_potenciallal = subs(f,r,B) - subs(f,r,A)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_wtNPjzxHKNoJIigzXrEl);
clear TMP_wtNPjzxHKNoJIigzXrEl
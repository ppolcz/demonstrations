function [ret] = gyak2
%% 
%  
%  file:   gyak2.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.19. Monday, 14:57:10
%

%% 6. feladat (epszilon, kuszobindex)

a = @(n) (4*n+3)./(5*n-1);
A = 4/5;
e = 1e-3;

lower = A-e;
upper = A+e;

lower < a(0:10)
a(759:770) < upper

(19 - 5e-3) / 20e-3

syms n integer

([a(n) , A + e] * (5*n-1) - 4*n + A + e) / 5 / e

3801/5

(19 + 5e-3)/25e-3


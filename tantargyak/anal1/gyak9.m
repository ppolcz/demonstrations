%% 
%  
%  file:   gyak9.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.21. Monday, 19:25:01
%
%% 10. feladat

syms x real
ezplot(sin(x), [-3*pi/2 3*pi/2])
hold on
ezplot(x - x^3/6 + x^5/120,[-3*pi/2 3*pi/2])

L = legend('$f(x) = \sin(x)$', '$T_5(x) = x - \frac{x^3}{6} + \frac{x^5}{120}$');
L.Interpreter = 'latex';

title('$f(x) = \sin(x)$,  $T_5(x) = x - \frac{x^3}{6} + \frac{x^5}{120}$', 'Interpreter', 'latex')

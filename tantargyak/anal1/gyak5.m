%% 
%  
%  file:   gyak5.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.10.10. Monday, 22:28:55
%

%% 9. feladat

x1 = -1:0.01:0;
x2 = 0:0.01:1;
x3 = 1:0.01:2;
plot([x1 x2 x3], [ x1+2 (x2-1).^2 log(x3) ])

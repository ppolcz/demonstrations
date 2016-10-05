%% 
%  
%  file:   gyak4.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.10.03. Monday, 14:52:31
%

%% Vegtelen sorosszeg: reszosszegek zart alakja alapjan
% $s_n = \sum_{k=1}^n \frac{1}{k (k + 2)} \rightarrow \frac{3}{4}$

a = @(n) 1 ./ n ./ (n+2);
sum(a(1:100000))

%% 

a = @(n) 5 ./ (4.^n);
sum(a(1:100000))
% A = 5/3 = 1.(6)

%% 

a = @(n) (4/9).^n + (5/9).^n;
sum(a(1:1000))
% A = 9/5 + 9/4 = 81/20 = 2.05

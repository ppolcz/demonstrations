function [poly] = polyadd(poly1,poly2)
%% 
%  
%  file:   polyadd.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.06. Friday, 12:56:38
%

if length(poly1) < length(poly2) 
    short = poly1; 
    long = poly2; 
else 
    short = poly2; 
    long = poly1; 
end 
mz = length(long)-length(short); 
if mz > 0 
    poly = [zeros(1,mz),short] + long; 
else 
    poly = long + short; 
end 

end
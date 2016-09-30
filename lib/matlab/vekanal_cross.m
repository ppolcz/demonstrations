function [ret] = vekanal_cross(F, G)
%% 
%  
%  file:   vekanal_cross.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:00:16
%

ret = [
    F(2)*G(3) - F(3)*G(2)
    F(3)*G(1) - F(1)*G(3)
    F(1)*G(2) - F(2)*G(1)
    ];

end
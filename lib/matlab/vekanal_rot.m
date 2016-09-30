function [ret] = vekanal_rot(F, r)
%% 
%  
%  file:   vekanal_rot.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:47:37
%

if nargin < 2
    r = symvar(F);
    
    if numel(r) ~= 3
        r = sym('[x;y;z]', 'real');
    end
end

if numel(F) ~= 3 || numel(r) ~= 3
    error('number of coordinates of vector field F and the number of variables in r must be 3');
end

x = r(1);
y = r(2);
z = r(3);

ret = -[
    diff(F(2),z) - diff(F(3),y)
    diff(F(3),x) - diff(F(1),z)
    diff(F(1),y) - diff(F(2),x)
    ];


end
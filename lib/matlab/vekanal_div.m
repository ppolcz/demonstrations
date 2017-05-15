function [ret] = vekanal_div(F, r)
%% 
%  
%  file:   vekanal_div.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:38:50
%

if nargin < 2
    r = symvar(F);
end

if numel(F) ~= numel(r)
    error('number of coordinates of vector field F and the number of variables in r must be the same');
end

ret = trace(jacobian(F,r));

end
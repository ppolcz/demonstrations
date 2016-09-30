function [ret,fh] = vekanal_subsmesh(symbolic, r_sym, r_num)
%% 
%  
%  file:   vekanal_subsmesh.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:57:13
%

if numel(r_sym) ~= numel(r_num)
    error(['A szimbolikus valtozok szama [r_sym: %d], '...
        'meg kell egyezzen a numerikus helyettesitesi valtozok szamaval [r_num: %d]'],...
        numel(r_sym), numel(r_num))
end
t = sym('t','real');
fh = matlabFunction(symbolic + t, 'vars', [num2cell(r_sym); t]);
ret = fh(r_num{:}, r_num{1}*0);


end
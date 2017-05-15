function [ret,fh] = vekanal_subsmesh(symbolic, r_sym, r_num)
%% 
%  
%  file:   vekanal_subsmesh.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:57:13
%

if ~iscell(r_num)
    assert(numel(r_sym) == 1, ...
        'r_num csak akkor lehet tomb, ha a fuggveny csak egy valtozos')
    r_num = {r_num};
else
    r_sym = r_sym(:);
    for i = 2:numel(r_num)
        assert(all(size(r_num{1}) == size(r_num{i})),...
            ['Az egyes valtozok numerikus reprezentaciojaban a numerikus matrixok merete meg kell egyezzen.\n'...
            'HIBA: r_num{%d}.size = [%d,%d], mig: r_num{%d}.size = [%d,%d]'], ...
            1, size(r_num{1}), i, size(r_num{i}))
    end
end

if numel(r_sym) ~= numel(r_num)
    error(['A szimbolikus valtozok szama [r_sym: %d], '...
        'meg kell egyezzen a numerikus helyettesitesi valtozok szamaval [r_num: %d]'],...
        numel(r_sym), numel(r_num))
end

t = sym('ZIGOTA_VIGYAZZ','real');
fh = matlabFunction(symbolic + t, 'vars', [num2cell(r_sym); t]);
ret = fh(r_num{:}, r_num{1}*0);


end
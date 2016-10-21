function [A_sym,difference_if0] = nonlin_factor(f_sym,v)
%% 
%  
%  file:   nonlin_factor.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.10.19. Wednesday, 17:40:58
%

n = numel(f_sym);
m = numel(v);
[num,den] = numden(f_sym);
f_tmp = f_sym;

% assert(numel(x)==numel(f_sym), ...
%     ['Number of elements in x and f(x) should be equal.\n' ...
%     'Numel(x)=%d, numel(f(x))=%d'], ...
%     numel(x),numel(f_sym));

A_sym = sym(zeros(n,m));
for ii = 1:n
    for jj = 1:m
        % disp(['b(' num2str(ii) ') = ' char(b(ii)) ' via ' ...
        %     char(x(jj)) ' --> ' ...
        %    'generating A(' num2str(ii), ',', num2str(jj) ') = ' char(A(ii,jj))])

        % [C,T] = coeffs(P,X)
        % returns the coefficients of the polynomial P with respect to X,
        % and an expression sequence of the terms of P
        %
        % syms a b c
        % [c,t] = coeffs(a*b^2 + a*c*b + 2*b + b^3 + a*c + 1, b)
        %
        % c = [ 1, a, a*c + 2, a*c + 1]
        % t = [ b^3, b^2, b, 1]

        [c,t] = coeffs(num(ii), v(jj));

        % which elements of t contains some power of x(jj)
        %  - subs(t, x(jj), 0) where x(jj) exists they will be 0
        %  - sign(abs(...)) where nonzero will be 1
        check = 1 - sign(abs(subs(t, v(jj), 0)));

        % add those elements to A(ii,jj) where check is true, divided by x(jj)
        A_sym(ii,jj) = sum(check .* c .* (t/v(jj))) / den(ii);

        % remove these elements from f and b
        f_tmp(ii) = simplify(f_tmp(ii) - A_sym(ii,jj)*v(jj));
        num(ii) = simplify(num(ii) - A_sym(ii,jj)*den(ii)*v(jj));
    end
end
difference = simplify(A_sym * v - f_sym);
difference_if0 = double(subs(difference,symvar(difference),...
    symvar(difference)*0));

A_sym = simplify(A_sym);
% pvpa(A_sym)

end
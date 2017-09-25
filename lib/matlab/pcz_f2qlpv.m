function A_sym = pcz_f2qlpv(f_sym, x)
%% Script pcz_f2qlpv
%  
%  file:   pcz_f2qlpv.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 25.
%
%%

n = numel(x);

[b_sym,a_sym] = numden(f_sym);
fxo = f_sym;

A_sym = sym(zeros(n,n));
for ii = 1:n
    for jj = 1:n

        [coefficients,bases] = coeffs(b_sym(ii), x(jj));

        % which elements of coefficients contains some power of x(jj)
        %  - subs(t, x(jj), 0) where x(jj) exists they will be 0
        %  - sign(abs(...)) where nonzero will be 1
        tmp = 1 - sign(abs(subs(bases, x(jj), 0)));

        % add those elements to A(ii,jj) where check is true, divided by x(jj)
        A_sym(ii,jj) = sum(tmp .* coefficients .* (bases/x(jj))) / a_sym(ii);

        % remove these elements from f and b
        f_sym(ii) = simplify(f_sym(ii) - A_sym(ii,jj)*x(jj));
        b_sym(ii) = simplify(b_sym(ii) - A_sym(ii,jj)*a_sym(ii)*x(jj));
    end
end

f_sym = fxo;

pvpa('A(x)x - f(x)', simplify(A_sym * x - f_sym))
% pcz_display(A_sym)


end
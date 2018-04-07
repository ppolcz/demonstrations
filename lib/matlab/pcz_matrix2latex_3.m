function [ret] = pcz_matrix2latex_3(A, prec)
%% 
%  
%  file:   pcz_matrix2latex_3.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.03.31. Thursday, 19:50:52
%

assert(isnumeric(A))

min = 0.1;
max = 10^(prec+1);

non_exponential = '%g';
exponential = sprintf('%%.%dd', prec);

mag = @(x) ceil(log10(abs(x)));           % 10^(mag-1) < x <= 10^mag
mul = @(x) 10.^(prec+1-mag(x));           % multiplier in the round
dround = @(x) round(x.*mul(x)) ./ mul(x); % round to 

if isscalar(1)

end

[q,p] = size(A);

A = num2cell(A);
A = cellfun(@toString, A, 'uniformOutput', 0);

separator = [ repmat({'&'}, [q, p-1]), repmat({'\\'}, [q, 1]) ];

I = reshape([1:p ; (1:p)+p], [1, 2*p]);
A = [A separator];
A = A(:,I)';
A = A(1:end-1);

if size(A,1) > size(A,2), A = A'; end

ret = [ sprintf('\\begin{array}{%s} ', repmat('c', [1,p])) ...
    strjoin(A, ' ') ...
    ' \end{array}'
    ];

ret = regexprep(ret, 'e([+-]*[0-9]+)', '\\f{$1}');
ret = regexprep(ret, '(\\f\{)\+', '$1');
ret = regexprep(ret, '(\\f\{)0+', '$1');
ret = regexprep(ret, '(\\f\{\-)0+', '$1');

% szedjik ki a nemkivanatos nullakat
ret = regexprep(ret, '(\.[1-9]*)0+ ', '$1');
ret = regexprep(ret, '(\.[1-9]*)0+(\\f)', '$1$2');
ret = regexprep(ret, '\\f\{\}', '');
ret = regexprep(ret, '([^0-9\.])0+([^0-9\.])', '$10$2');

%%
    function str = toString(num)
        if min < abs(num) && abs(num) < max
            str = sprintf(non_exponential, dround(num));
        else
            str = sprintf(exponential, num);
        end
    end

end

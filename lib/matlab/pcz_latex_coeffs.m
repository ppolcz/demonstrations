function [ret] = pcz_latex_coeffs(A, varargin)
%% 
%  
%  file:   pcz_latex_coeffs.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.05.25. Wednesday, 11:27:13
%

vars = pargin(varargin, 2, []);
[c1,t1,c2,t2] = pcoeffs(A,vars);

[n,m] = size(c1);

sed = [
    sed_platex_from_latex
    sed_platex_from_sym
    ];

STR = cell(size(A));

for i = 1:n
    for j = 1:m
        Nr = numel(c1{i,j});
        
        num = sprintf('%s %s', cstr(double(c1{i,j}(1)),1), latex(t1{i,j}(1)));
        for k = 2:Nr
            c = double(c1{i,j}(k));
            
            num = sprintf('%s %s %s', num, cstr(c), latex(t1{i,j}(k)));
        end
        
        num = sed_apply(num, sed);
        
        % ---------------------
        
        if numel(c2{i,j}) == 1 && isempty(symvar(c2{i,j}))
            STR{i,j} = num;
            continue
        end
        
        Nr = numel(c2{i,j});
        
        den = sprintf('%s %s', cstr(double(c2{i,j}(1)),1), latex(t2{i,j}(1)));
        for k = 2:Nr
            c = double(c2{i,j}(k));
            
            den = sprintf('%s %s %s', den, cstr(c), latex(t2{i,j}(k)));
        end
        
        den = sed_apply(den, sed);
        
        STR{i,j} = sprintf('\\frac{%s}{%s}', num, den);
        
    end
end

ret = STR

del1 = ' & ';
del2 = sprintf(' \\\\\n');

delimiters = reshape([repmat({del1}, [m-1,n]) ; repmat({del2}, [1,n])], [1 numel(A)])

ret = [ strjoin(reshape(STR, [1, numel(STR)]), delimiters(1:end-1)) ]


    function ret = cstr(c,varargin)
        if nargin > 1
            ret = '';
            separator = '';
        else
            if c < 0, ret = '-'; else ret = '+'; end
            separator = ' ';
        end
        
        c = abs(c);
        disp([c, c < 1-1e-10, 1+1e-10 < c ,  c < 1-1e-5 && 1+1e-5 < c])
        if xor(c < 1-1e-5 , 1+1e-5 < c)
            ret = sprintf('%s%s%g', ret, separator, c);
        else
            ret = '';
        end
    end

end
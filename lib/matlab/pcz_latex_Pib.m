function [ret] = pcz_latex_Pib(Pib)
%% 
%  
%  file:   pcz_latex_Pib.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.04.02. Saturday, 09:21:32
%

sed = [
    sed_platex_from_sym 
    sed_platex_from_latex 
    {
        '\s*\({0,1}([^\)\(]*)\){0,1}\/\(([^\)\(]*)\)' '    \\\\frac\{\1\}\{\2\}'
        '\s\s+([a-zA-Z0-9])' '    \1'
        '(.*)' '\1 \\\\\\\\'
        '\*' ' '
        'd_' '\\\\delta_'
        }
    ];
sed_apply(evalc('pvpa(Pib,4)'), sed)

end
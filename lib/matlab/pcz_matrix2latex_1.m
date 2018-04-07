function ret = pcz_matrix2latex_1(varargin)
%%
%
%  file:   pcz_matrix2latex_1.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on Fri Feb 20 23:23:07 CET 2015
%

%%

% fname: full path of the actual file
eval(pcz_cmd_fname('fname'));
persist = pdirs(fname);

out_file = [ persist.tmp '/' persist.file.bname '.out' ];

for i=1:nargin
    var = varargin{i};
    
    if isscalar(var)
        value = num2str(var);
    else
        matrix2latex(var, out_file, 'alignment', 'c');
        value = fileread(out_file)
    end
    
    value = regexprep(value, 'e([+-]*[0-9]+)', '\\e{$1}')
    
    if nargout > 0
        ret = value;
    else
        disp(value)
    end
end



end

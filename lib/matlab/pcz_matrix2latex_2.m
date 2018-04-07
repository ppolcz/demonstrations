function ret = pcz_matrix2latex_2(varargin)
%% 
%  
%  file:   pcz_matrix2latex_2.m
%  author: Polcz Péter <ppolcz@gmail.com> 
% 
%  Created on Sun Nov 08 15:28:56 CET 2015
%
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
        s = num2str(var);
    else
        newline = sprintf('\n');
        tabular = sprintf('\t');
        
        matrix2latex(var, out_file, 'alignment', 'c');
        s = fileread(out_file);
        
        s = strrep(s, '\begin{bmatrix} ', ['\begin{bmatrix}' newline tabular]);
        s = strrep(s,' \end{bmatrix}',[' \\' newline '\end{bmatrix}']);
        s = strrep(s,' \\ ',[' \\' newline tabular]);
    end
    
    s = regexprep(s, 'e([+-]*[0-9]+)', '\\e{$1}');

    if nargout > 0
        ret = s;
    else
        disp(s)
    end
end

end
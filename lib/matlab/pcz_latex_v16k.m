function [ret] = pcz_latex_v16k(A, varargin)
%% 
%  
%  file:   pcz_latex_v16k.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.11.20. Sunday, 16:34:03
%
%% FROM
%
%  file:   pcz_latex.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.01.30. Saturday, 18:25:07
%  Reviewed on 2016.02.17. Wednesday, 10:42:50
%
%  This function uses the build-in latex function (for symbolic variables
%  and my own pcz_matrix2latex_1 function (for double arrays). In fact this
%  function does a refactoring and formatting on the output given by these
%  two functions.
%  
%  disp_mode = 0  in one line
%              1  in multiple lines each array rows in new line
%              2  like 1 but the & characters are aligned
%              3  each element of `in a new line
% 
%  Usage:
%  [ret = ] pcz_latex(A)

opt.prec = 4;
opt.sed_user = {};
opt.disp_mode = 0;
opt.varname = inputname(1);
opt = parsepropval(opt,varargin{:});

%%

indent = '    ';
newline = sprintf('\n');

pcz_struct_split(opt)

if iscell(disp_mode)
    sed_user = disp_mode;
    disp_mode = 0;
end

assert(isscalar(disp_mode), 'Arguments are wrong: display mode should be scalar')

sed = [
    sed_platex_from_latex
    sed_platex_from_sym
    ];

if disp_mode >= 1
    sed = [ sed ; {
        
        % newline+indent after \begin{..} or \begin{..}{..}, 
        % after \\, before \end{..}
        '(\\\\begin\{[^\}]*\}(\{[^\}]*\})*)\\s*' ['\1\n' indent]
        '(\\\\\\\\)' ['\1\n' indent]
        '(\\\\end\{)' '\\\\\\\\\n\1'
        
        % handle/erase extra space at the beggining of the lines
        [indent '*- '] [indent '-']
        [indent '*-'] [indent '-']
        [indent ' *'] indent
        } ];
    if disp_mode >= 3
        sed = [ sed ; {
            '(\\\\\\\\)' ['\n' indent '\1']
            '(&)' ['\n' indent '\1\n' indent]
            
            % remove extra newline before \end{..}
            [indent '\\\\\\\\\n(\\\\end)'] '\1'
            } ];
    end
end

sed = [ sed ; sed_user ];

try
    A_latex = latex(A);
catch
    try
        A_latex = pcz_matrix2latex_3(A, prec);
    catch ex
        getReport(ex)
    end
end

% escaped = strrep(A_latex,'\', '\\');
% [cmdout,status] = sed_apply(escaped, sed);

[cmdout,status] = sed_apply(A_latex, sed);

nl_index = strfind(cmdout, newline);
if (disp_mode == 2) && (numel(nl_index)-1 == size(A,1))
    lines = cell(1,size(A,1));
    places = zeros(size(A,1),size(A,2));
    
    for i = 1:size(A,1)
        lines{i} = cmdout(nl_index(i)+1:nl_index(i+1)-1);
        places(i,1:end-1) = strfind(lines{i},'&');
        places(i,end) = strfind(lines{i}, '\\');
    end
    
    for j = 1:size(A,2)
        max_pos = max(places(:,j));
        for ii = 1:size(A,1)
            pos = places(ii,j);
            xspace = repmat(' ', [1 max_pos-pos]);
            lines{ii} = [lines{ii}(1:pos-1) xspace lines{ii}(pos:end)];
            places(ii, j+1:end) = places(ii, j+1:end) + max_pos-pos;
        end
    end
    
    cmdout = [ cmdout(1:nl_index(1)) strjoin(lines,newline) cmdout(nl_index(end):end) ];
end

if ~isscalar(A)
    cmdout = [ '\left[' cmdout '\right]' ];
end

if ~isempty(varname)
    name = [varname ' = '];
else
    name = '';
end

cmdout = [name cmdout];

if status
    fprintf(['\nreturn_value = ' num2str(status) '\n\n'])
end

if nargout > 0
    ret = cmdout;
else
    if disp_mode >= 1
        disp ' '
    end
    disp(cmdout)
end

end
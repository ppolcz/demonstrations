function [ret] = pcz_latex_vpa(A,disp_mode,sed_user,prec)
%% 
%  
%  file:   pcz_latex_vpa.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.04.02. Saturday, 09:51:45
%
%  Examples:
%  pcz_latex_vpa(M,2, { 'Dd_' '\\\\dot\{\\\\delta\}_' ; 'd_' '\\\\delta_'})

if nargin < 2 || isempty(disp_mode), disp_mode = 0; end
if nargin < 3 || ~iscell(sed_user), sed_user = {}; end
if nargin < 4 || isempty(prec), prec = 4; end;

if iscell(disp_mode)
    sed_user = disp_mode;
    disp_mode = 0;
end

assert(isscalar(disp_mode), 'Arguments are wrong: display mode should be scalar')

%%

% N = [-x1 -0.1213*x2 d1 ; -1 0 1]
% 
% prec = 4;
% sed_user = [];
% disp_mode = 2;

[q,p] = size(A);

str = evalc('disp(vpa(A,prec))');
str = sed_apply(str, [
    sed_platex_from_sym 
    { ',' ' \& ' }
    { '\[' '' }
    { '\]' ' \\\\\\\\' }
    { '\-1\.0\*' '-' }
    { ' (\-{0,1})1\.0 ' ' \11 '}
    { '\*' ' ' }
    ]);
str = [
    sprintf('\\begin{array}{%s} ', repmat('c', [1,p])) ...
    str ...
    ' \end{array}'
    ];

str = regexp(str, '\s*', 'split');
str = strjoin(str, ' ');
str = strrep(str, '\\ \end', '\end');

%%

indent = '    ';
newline = sprintf('\n');

sed = [];
if disp_mode >= 1
    sed = {
        
        % newline+indent after \begin{..} or \begin{..}{..}, 
        % after \\, before \end{..}
        '(\\\\begin\{[^\}]*\}(\{[^\}]*\})*)\\s*' ['\1\n' indent]
        '(\\\\\\\\)' ['\1\n' indent]
        '(\\\\end\{)' '\\\\\\\\\n\1'
        
        % handle/erase extra space at the beggining of the lines
        [indent '*- '] [indent '-']
        [indent '*-'] [indent '-']
        [indent ' *'] indent
        };
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

escaped = strrep(str,'\', '\\');
if isempty(sed)
    cmdout = str;
    status = 0;
else
    [cmdout,status] = sed_apply(escaped, sed);
end

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
        for ii = 1:size(A,1);
            pos = places(ii,j);
            xspace = repmat(' ', [1 max_pos-pos]);
            lines{ii} = [lines{ii}(1:pos-1) xspace lines{ii}(pos:end)];
            places(ii, j+1:end) = places(ii, j+1:end) + max_pos-pos;
        end
    end
    
    cmdout = [ cmdout(1:nl_index(1)) strjoin(lines,newline) cmdout(nl_index(end):end) ];
end

cmdout = [ '\left[' cmdout '\right]' ];

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
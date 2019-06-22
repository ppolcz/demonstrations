function [ret] = pcz_latex_v7(A, varargin)
%% pcz_dispFunctionLatex
%  
%  File: pcz_dispFunctionLatex.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. May 30.
%

%%

label = inputname(1);

str = '';

if ~isnumeric(A)
    str = pcz_latex_v6(A, 'disp_mode', 2, 'label', [ label ' = '], varargin{:});
    
    if size(A,2) <= 10
        cccccc = repmat('c',[1 size(A,2)]);        
        str = strrep(str, ['\left(\begin{array}{' cccccc '}'], '\pmqty{');
        str = strrep(str, '\end{array}\right)', '}');
    end
    
elseif isnumeric(A)
    str = pcz_num2str_latex([A], varargin{:});
end

disp(str)

end

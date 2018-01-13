function [ret] = pcz_num2str_latex_output(A,varargin)
%% Script pcz_num2str_latex_output
%  
%  File: pcz_num2str_latex_output.m
%  Directory: projects/3_outsel/2018_01_10_LPV_inversion
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. January 14.
%
%%

o.label = '';
o.format = '%g';
o.del1 = ' & ';
o.del2 = ' \\\\\n';
o.pref = '        ';
o.round = 4;
o = parsepropval(o,varargin{:});

tol = 10^(-o.round);
A( A < tol & A > -tol ) = 0;
o.A = A;

if isempty(o.label) && ~isempty(inputname(1))
    o.label = [ inputname(1) ' = ' ];
end
b = ['    ' o.label '\\left(\\begin{array}{' repmat('c',[1,size(A,2)]) '}\n'];

disp '\begin{equation}'



pcz_num2str_latex(o.A, 'format', o.format, ...
    'beginning', b, ...
    'ending', '\n    \\end{array}\\right)', ...
    'del1', o.del1, 'del2', o.del2, 'pref', o.pref, 'round', o.round)

disp '\end{equation}'


end
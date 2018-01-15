function [ret] = pcz_latex_output(A, varargin)
%% Script pcz_latex_output
%  
%  File: pcz_latex_output.m
%  Directory: projects/3_outsel/2018_01_10_LPV_inversion
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. January 13.
%
%%

global LATEX_EQNR
LATEX_EQNR = LATEX_EQNR + 1;

o.label = '';
o.sed_user = {};
o.disp_mode = 0;
o.prec = 0;
o.vline = [];
o.hline = [];
o.A = A;
o = parsepropval(o,varargin{:});

fprintf('\n\\begin{equation} {\\LARGE(%d) \\quad}', LATEX_EQNR)
if isempty(o.label)
    pcz_latex_v6(o.A, 'label', ['\n' inputname(1) ' = '], varargin{:});
else
    pcz_latex_v6(o.A, varargin{:});
end
fprintf('\\end{equation}\n')


end
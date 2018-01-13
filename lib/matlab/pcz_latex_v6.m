function [ret] = pcz_latex_v6(A, varargin)
%% Script pcz_latex_v6
%  
%  File: pcz_latex_v6.m
%  Directory: projects/3_outsel/2018_01_10_LPV_inversion
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. January 13.
%
%%

o.label = '';
o.sed_user = {};
o.disp_mode = 0;
o.prec = 0;
o.A = A;
o = parsepropval(o,varargin{:});


fprintf(o.label);
pcz_latex(o.A, o.disp_mode, o.sed_user, o.prec);


end
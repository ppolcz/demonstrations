function [ret] = pcz_num2str_multiline(A,varargin)
%% Script pcz_num2str_multiline
%  
%  file:   pcz_num2str_multiline.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.06. Thursday, 20:37:16
%
%%

pcz_num2str(A, 'del1', ' ', 'del2', '\n', ...
    'pref', '    ', 'beg', '[\n', ...
    'label', [inputname(1) ' = '], ... '{inputname} = ', ...
    'end', '\n    ];', varargin{:})

end
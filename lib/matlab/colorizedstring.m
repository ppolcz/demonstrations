function [colorizedstring] = colorizedstring(color, stringtocolorize)
%% 
%  
%  file:   colorizedstring.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.06. Friday, 13:58:22
%
%  Colorizestring wraps the given string in html that colors that text.

    colorizedstring = ['<font color="', color, '">', stringtocolorize, '</font>'];
end
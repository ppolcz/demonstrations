function [ret] = pcz_pretty(label, var)
%% Script pcz_pretty
%  
%  file:   pcz_pretty.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.04. Friday, 09:36:32
%
%%

if nargin == 1 && ~ischar(label) && ~isempty(inputname(1))
    var = label;
    label = inputname(1);
end

fprintf('%s = \n', label);
pretty(var)
    
end
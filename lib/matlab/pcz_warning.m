function [ret] = pcz_warning(bool, varargin)
%% 
%  
%  file:   pcz_warning.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.06. Friday, 13:02:42
%

if ~bool
    warning(varargin{:})
end

end
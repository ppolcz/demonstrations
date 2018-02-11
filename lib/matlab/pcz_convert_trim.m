function [ret] = pcz_convert_trim(src, dst, varargin)
%% Script pcz_convert_trim
%  
%  File: pcz_convert_trim.m
%  Directory: /1_projects/2_sta/2017_12_10_gradient_Rosenbrock
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. February 11.
%

%%

props.Border = 10;
props.BorderColor = 'White';
props = parsepropval(props,varargin{:});

command = sprintf('convert %s -trim -bordercolor %s -border %dx%d %s',...
    src, props.BorderColor, props.Border, props.Border, dst);

ret = system(command);

end
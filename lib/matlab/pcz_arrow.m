function [ret] = pcz_arrow(x1, y1, x2, y2,varargin)
%% Script pcz_arrow
%  
%  file:   pcz_arrow.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.02. Sunday, 02:06:47
%
%%

% http://matlab.izmiran.ru/help/techdoc/ref/annotationarrowproperties.html

% none
% plain
% ellipse
% vback1
% vback2 (Default)
% vback3
% cback1
% cback2
% cback3
% star4
% rectangle
% diamond
% rose
% hypocycloid
% astroid
% deltoid

ah = annotation(...
    'arrow','headStyle','vback2','HeadLength',8,'HeadWidth',8, varargin{:});
set(ah,'parent',gca);
set(ah,'position',[x1 y1 x2-x1 y2-y1]);

end
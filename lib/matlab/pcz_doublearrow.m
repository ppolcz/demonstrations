function [ret] = pcz_doublearrow(x1, y1, x2, y2,varargin)
%% pcz_doublearrow
%  
%  File: pcz_doublearrow.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. May 11.
%

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
    'doublearrow','headStyle','vback2', varargin{:});
set(ah,'parent',gca);
set(ah,'position',[x1 y1 x2-x1 y2-y1]);

end
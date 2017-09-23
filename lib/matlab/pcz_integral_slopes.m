function [ret] = pcz_integral_slopes(x1, x2, dx1, dx2, length, varargin)
%% Script pcz_integral_slopes
%
%  file:   pcz_integral_slopes.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.07.02. Sunday, 00:08:23
%
% Examples:
%  pcz_integral_slopes(x1,x2,dx1,dx2,0.1,'r')
%  pcz_integral_slopes(x1,x2,dx1,dx2,'b')
%  pcz_integral_slopes(x1,x2,dx1,dx2,'Color','green')
%  pcz_integral_slopes(x1,x2,dx1,dx2,0.6,'Color',[0 1 1])

%%

if nargin > 4 && ischar(length)
    varargin = [length varargin]; 
end

if nargin == 4 || ischar(length)
    length = 0.5;
end

varargin = [length/2 varargin 'ShowArrowHead' 'off'];

%% 

r = (dx1.^2 + dx2.^2).^0.5;
f1 = dx1./r;
f2 = dx2./r;

if ishold
    hold_status = 'on';
else
    hold_status = 'off';
end

q = quiver(x1,x2,f1,f2,varargin{:}); hold on
qColor = get(q,'Color');
quiver(x1,x2,-f1,-f2,varargin{:},'Color',qColor)

hold(hold_status)

end
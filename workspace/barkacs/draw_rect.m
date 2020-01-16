function [ret] = draw_rect(x1,y1,x2,y2,args)
%% draw_rect
%  
%  File: draw_rect.m
%  Directory: 2_demonstrations/workspace/barkacs
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. December 25. (2019b)
%

%%

if nargin < 5
    args = {};
end
if nargin < 4
    y1 = x1(2);
    x1 = x1(1);
    y2 = y1(2);
    x2 = y1(1);
    if nargin < 3
        args = {};
    else
        args = x2;
    end
end

plot([x1 x1 x2 x2 x1], [y1 y2 y2 y1 y1], '-', args{:})

end
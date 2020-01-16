function draw_circle(a,b,c,d,e)
%% draw_circle
%  
%  File: draw_circle.m
%  Directory: 2_demonstrations/workspace/barkacs
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. December 25. (2019b)
%

%%

narginchk(2,Inf)

x = 0;
y = 0;
z = [];
args = {};
if 2 == numel(a) || 3 == numel(a)
    x = a(1);
    y = a(2);
    if numel(a) > 2
        z = a(3)
    end
    r = b;
    if nargin > 2
        args = c;
    end
elseif isscalar(a) && isscalar(b) && nargin >= 4 && isscalar(d)
    x = a;
    y = b;
    z = c;
    r = d;
    if nargin > 4
        args = e;
    end
elseif isscalar(a) && isscalar(b)
    x = a;
    y = b;
    r = c;
    if nargin > 3
        args = d;
    end
end

t = linspace(0,2*pi,100);

xx = r*cos(t) + x;
yy = r*sin(t) + y;

xx(end+1) = xx(1);
yy(end+1) = yy(1);

plot(xx,yy,'-',args{:})
plot(x,y,'.',args{:})

% if ~isempty(z)
%     zz = 


end

%%

function test1
%%
    draw_circle(3,4,1)
end

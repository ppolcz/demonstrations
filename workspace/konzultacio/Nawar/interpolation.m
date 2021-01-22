%%
%  File: interpolation.m
%  Directory: 2_demonstrations/workspace/konzultacio/Nawar
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. January 22. (2020b)
%

rng(1)


T = 59;

% Time steps (in seconds)
t = 0:T;

% Data (60 points)
x = randn(2,numel(t))/4 + t;

% Dense time span
tt = 0:0.1:T;

xx = interp1(t',x',tt','spline');



fig = figure(1);
delete(fig.Children)

hold on
plot(t,x,'o')
plot(tt,xx,'r')

fig = figure(2);
delete(fig.Children)

hold on
plot(x(1,:),x(2,:),'o','LineWidth',4,'MarkerSize',20)
plot(xx(:,1),xx(:,2),'r.','LineWidth',4,'MarkerSize',20)


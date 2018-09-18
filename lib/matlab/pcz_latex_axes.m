function [fig,ax] = pcz_latex_axes
%% 
%  
%  file:   pcz_latex_axes.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.08. Thursday, 20:37:55
%

% Create figure
fig = figure('InvertHardcopy','off','Color',[1 1 1], ...
    'Units', 'normalized', 'Position', [0 0 0.6 1]);

% Create axes
ax = axes('Parent',fig,'LineWidth',2,'FontSize',14,...
    'FontName','TeX Gyre Schola Math',...
    'DataAspectRatio',[1 1 1]);
hold(ax, 'on');
axis(ax, 'equal', 'tight');

grid(ax,'on');

% Create xlabel
xlabel('$x_1$','FontSize',30,'Interpreter','latex');

% Create ylabel
ylabel('$x_2$','FontSize',30,'Interpreter','latex');

% Create zlabel
zlabel('$x_3$','FontSize',30,'Interpreter','latex');

end
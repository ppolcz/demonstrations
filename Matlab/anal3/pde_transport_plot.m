%% 
%  
%  file:   pde_transport_plot.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.12.16. Friday, 00:33:34
%

%%

syms x real
f_sym = exp(-x^2 / 2);

f = matlabFunction(f_sym);

c = 0.5;
u = @(x,t) f(x-c*t);

x = linspace(-3,12,200);

tlist = [0 3 6 9];

leg = {};

figure('Position', [668 575 924 398]), hold on
for t = tlist
    plot(x, u(x,t))
    text(c*t,1,['t = ' num2str(t)],'Interpreter','latex', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
    leg = [ leg {sprintf('$u(x,%g)$', t)} ];
end
axis([-3,12,0,1.2])
title('A transzport egyenlet megoldasa $u(x,t) = g(x-ct)$', 'Interpreter', 'latex')

leg{1} = sprintf('%s $= g(x) = %s$', leg{1}, latex(f_sym));

L = legend(leg{:});
L.Interpreter = 'latex';
L.FontSize = 13


%%

r = @rectangularPulse;
f = @(x) r(0,Inf,x) .* exp(-x);

c = 0.5;
u = @(x,t) f(x-c*t);

x = linspace(-1,12,400);

tlist = [0 3 6 9];

leg = {};

figure('Position', [668 762 1055 211]), hold on
for t = tlist
    plot(x, u(x,t))
    text(c*t,1,['t = ' num2str(t)],'Interpreter','latex', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
    leg = [ leg {sprintf('$u(x,%g)$', t)} ];
end
axis([-1,12,0,1.2])
title('A transzport egyenlet megoldasa $u(x,t) = g(x-ct)$', 'Interpreter', 'latex')

leg{1} = sprintf('%s $= g(x) = %s$', leg{1}, ...
    [
    '\left\{\begin{array}{l}' ...
    '    0, ~~ x < 0 \\' ...
    '    e^{-x}, ~~ x \ge 0' ...
    '\end{array}\right.'
    ]);

L = legend(leg{:});
L.Interpreter = 'latex';
L.FontSize = 13
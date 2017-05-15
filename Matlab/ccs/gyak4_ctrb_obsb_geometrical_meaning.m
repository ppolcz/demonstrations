%% 
%  
%  file:   gyak4_ctrb_obsb_geometrical_meaning.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.09. Thursday, 22:41:56
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_bAXcwxJvFVeUoUfCDgCw = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%% Unobservable subspace - seminary example
% 
% Starting the system from any initial condition within the
% unobservability subspace, the output will be the same.

A = [ 1 2 ; -2 -3 ];
C = [ 1 1 ];

O2 = obsv(A,C);
unobsv = null(O2);
x0 = [ 1 ; 1 ];

figure('Position', [ 668 698 837 275 ], 'Color', [1 1 1]), 
subplot(121), hold on, grid on, ptitle 'Output of the system'
plabel x 'time: $t$'
plabel y 'output: $y(t)$'
subplot(122), hold on, grid on, ptitle 'System trajectories $x(t)$ - phase diagram'
plabel x 'state variable $x_1(t)$'
plabel y 'state variable $x_2(t)$'

x_from = x0 + unobsv*(-7);
x_to = x0 + unobsv*5;
plot([x_from(1) x_to(1)], [x_from(2) x_to(2)], '--')

for i = 1:10
    x_init = x0 + unobsv*randn(size(unobsv,2)) * 3;
    [t,x] = ode45(@(t,x) A*x, [0, 10], x_init);
    
    subplot(121)
    Pl = plot(t,rand*0.02 +(C*x')');

    subplot(122)
    plot(x(:,1),x(:,2), 'Color', Pl.Color);
    plot(x(1,1),x(1,2),'.', 'Color', Pl.Color);
end

%% Controllable subspace - seminary example
% 
% Starting the system from any initial condition within the
% unobservability subspace, the output will be the same.

% T = round(2*randn(3,3),0), inv(T)
% pcz_num2str(T)
T = [ -0 , 2 , 2 ; 2 , 0 , 2 ; 0 , -1 , 2 ];

A = [-6 -4 2 ; 2 0 1 ; 0 0 -2];
B = [4 ; 0 ; 0];

A = T*A/T
B = T*B

C3 = ctrb(A,B)
contrl = orth(C3);
KerC3 = null(C3);

u = @(t) randn + sin(t);

[tt,xx] = ode45(@(t,x) A*x + B*u(t), [0,10], 2*null(contrl') + contrl * randn(size(contrl,2),1));

t_interp = linspace(0,10,3000);
xx = interp1(tt,xx,t_interp);

[x1,x2] = meshgrid(linspace(-1,1,10));

figure, hold on
plot3(xx(:,1),xx(:,2),xx(:,3));
plot3(xx(1,1),xx(1,2),xx(1,3),'.');
syms u v real
vekanal_plot_sym_surface(contrl * [u;v], u,v,[-2 2], [-2 2], 'resolution', 2, 'args', ...
    {'facealpha', 0.5, 'FaceColor',[1 0 0]}),
shading interp, grid on
plot3(0,0,0, 'ok', 'Markersize', 5, 'LineWidth', 2)

axis equal
ptitle 'System trajectories $x(t)$ - phase diagram'
plabel x '$x_1(t)$'
plabel y '$x_2(t)$'
plabel z '$x_3(t)$'

% pcz_latex(sym(A))
% pcz_latex(sym(B))
% pcz_latex(sym(C3))
% pcz_num2str_latex(contrl(:,1), contrl(:,2))

%% 
% Controllability staircase form

S = [orth(C3) null(C3)];
A_ = S\A*S
B_ = S\B

%% 
pcz_dispFunctionEnd(TMP_bAXcwxJvFVeUoUfCDgCw);
clear TMP_bAXcwxJvFVeUoUfCDgCw
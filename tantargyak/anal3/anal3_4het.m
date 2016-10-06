%% 
%  
%  file:   anal3_4het.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 12:57:39
%

%% Brachistocrone

q0_num = 1;
C_num = 1;

L = @(F) diff(F,q)

syms t u v q0 C real
q = sym('q(t)', 'real');
dq = diff(q);

F = sqrt(1 + v^2) / sqrt(u - q0);

F_q = subs(F, [u,v], [q,dq]);
pretty(F_q)

disp 'EULER EGYENLET: '
Euler_eq_q = simplify( subs(diff(F,u), [u,v], [q,dq]) - diff( subs(diff(F,v), [u,v], [q,dq]) ) );
pretty(Euler_eq_q)

disp 'ALTERNATIVE: '
Euler_alt_q = simplify( F_q - dq * subs(diff(F,v), [u,v], [q,dq]) );
pretty(Euler_alt_q)

Euler_alt = subs(Euler_alt_q, [q,dq], [u,v]);

assume([q0 >= u , in(q0, 'real'), in(u, 'real')])
sol = solve(Euler_alt-1/C, v);

% Nincs implicit megoldasa
% dsolve(Euler_alt == C)

%%

figure, hold on, axis equal tight

x0 = 0;
y0 = 1;

x1 = 5;
y1 = 0;

obj = @(theta) theta - sin(theta) - x1 / (y0 - y1) * (1 - cos(theta));

plot([x0 x1], [y0 y1])
theta1 = fsolve(obj, pi);
k = 2*x1 / (theta1 - sin(theta1));

theta = linspace(0,theta1,100);
x = k/2 * (theta - sin(theta));
y = y0 - k/2 * (1 - cos(theta));
plot(x,y, 'r', x(end), y(end), 'ro')

%%

figure, hold on, axis equal tight


g = 10;
m = 2;

x0 = 0;
y0 = 1;
x1 = 5;
y1 = 0;

syms k b theta1 theta2 v0

E0 = m*v0^2/2 + m*g*y0;
obj_sym = [
    b + k/2 * (theta1 - sin(theta1)) - x0
    E0/(m*g) - k/2 * (1 - cos(theta1)) - y0
    b + k/2 * (theta2 - sin(theta2)) - x1
    E0/(m*g) - k/2 * (1 - cos(theta2)) - y1
    ];

obj = @(v) matlabFunction(subs(obj_sym,v0,v), 'vars', {[k ; b ; theta1 ; theta2]});

for v_init = 1:2:8
    
    sol = fsolve(obj(v_init), [x1-x0 ; 0 ; 0 ; pi]);
    
    k = sol(1);
    b = sol(2);
    theta1 = sol(3);
    theta2 = sol(4);
    
    plot([x0 x1], [y0 y1])
    theta = linspace(theta1,theta2,100);
    x = b + k/2 * (theta - sin(theta));
    y = subs(E0,v0,v_init)/(m*g) - k/2 * (1 - cos(theta));
    plot(x,y, 'r', x(end), y(end), 'ro')
    
end

title 'kulonbozo kezdeti sebessegek mellett'

%%

theta = linspace(pi,2*pi,100);

plot(theta + sin(theta), 1 + cos(theta))


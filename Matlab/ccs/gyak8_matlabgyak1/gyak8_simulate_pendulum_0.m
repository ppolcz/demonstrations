function gyak8_simulate_pendulum_0(t,x,u)
%% 
%
%  file:   gyak7_simulate_pendulum_0.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.03.27. Monday, 13:46:12
%

dim = min(size(x));

% Frames per second
fps = 20;
Ts = 1/fps;

% Resampling x(t) using the interp1 function (`_rs` stands for `resampled`)
t_rs = t(1):Ts:t(end);
x_rs = interp1(t,x,t_rs);

% Split the state vector
r_rs = x_rs(:,1);
if dim == 4
    phi_rs = x_rs(:,3);
    plot_1_data = x(:,1:2);
    plot_2_data = x(:,3:4);
elseif dim == 2
    phi_rs = x_rs(:,2);
    plot_1_data = x(:,1);
    plot_2_data = x(:,2);
else
    error 'The dimension of x must be 2 or 4'
end

% Figure dimensions
l = 1;
cl = 1;
cw = 0.1;

r_init = r_rs;
x1 = r_init + l*sin(phi_rs);
y1 = l*cos(phi_rs);

fig = figure(19);
set(fig,'Position', [ 174 63 1229 407 ], 'Color', [1 1 1])

if nargin == 2
    subplot(221), hold off;
    plot(t, plot_1_data), setxlim
    title('Chart''s position and velocity'), grid on;
    
    subplot(222), hold off;
    plot(t, plot_2_data), setxlim
    title('Angle and angular velocity'), grid on;
elseif nargin == 3
    subplot(231), hold off;
    plot(t, plot_1_data), setxlim
    title('Chart''s position and velocity'), grid on;
    
    subplot(232), hold off;
    plot(t, plot_2_data), setxlim
    title('Angle and angular velocity'), grid on;

    subplot(233), hold off;
    if isa(u,'function_handle')
        plot(t,u(t))
    else
        plot(t,u)
    end, setxlim
    title('Input'), grid on;
end
    
pause(0.1)
subplot(2,2,[3 4]), hold off
plot_pendulum(1);
pause(0.5)

tic;
for kk = 1:length(t_rs)
    plot_pendulum(kk)
    pause(Ts - toc)
    tic
end

    function plot_pendulum(kk)
        plot([r_init(kk)-cl/2, r_init(kk)-cl/2, r_init(kk)+cl/2, r_init(kk)+cl/2, r_init(kk)-cl/2], [-cw/2, cw/2, cw/2, -cw/2, -cw/2])
        hold on;
        plot([r_init(kk); x1(kk)],[0; y1(kk)],'b-'),
        plot(x1(kk), y1(kk), 'o')
        axis([-13 13 -2 2]), grid on;
        hold off;
    end

    function setxlim
        xlim(t([1,end]))
    end
end

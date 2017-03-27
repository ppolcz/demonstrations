function gyak7_simulate_pendulum_0(t,x)
%% 
%
%  file:   gyak7_simulate_pendulum_0.m
%  author: Peter Polcz <ppolcz@gmail.com>
%
%  Created on 2017.03.27. Monday, 13:46:12
%

l = 1;

% Frame per second
fps = 1/20;

% Resampling x(t) using the interp1 function (`_rs` stands for `resampled`)
t_rs = t(1):fps:t(end);
x_rs = interp1(t,x,t_rs);

% Split the state vector
pos_rs = x_rs(:,1);
vel_rs = x_rs(:,2);
fi_rs = x_rs(:,3);
omega_rs = x_rs(:,4);

cl = 1;
cw = 0.1;

x_init = pos_rs;
x1 = x_init + l*sin(fi_rs);
y1 = l*cos(fi_rs);

figure('Position', [ 174 63 1229 407 ], 'Color', [1 1 1])

subplot(221), hold on;
plot(t_rs, [ fi_rs omega_rs ]),
title('Angle and angular velocity'), grid on;

subplot(222), hold on;
plot(t_rs, [ pos_rs vel_rs ]),
title('Chart''s position and velocity'), grid on;

subplot(2,2,[3 4])
tic;
for kk = 1:length(t_rs)
    plot([x_init(kk)-cl/2, x_init(kk)-cl/2, x_init(kk)+cl/2, x_init(kk)+cl/2, x_init(kk)-cl/2], [-cw/2, cw/2, cw/2, -cw/2, -cw/2])
    hold on;
    plot([x_init(kk); x1(kk)],[0; y1(kk)],'b-'),
    plot(x1(kk), y1(kk), 'o')
    axis([-13 13 -2 2]), grid on;
    hold off;
    pause(fps - toc)
    tic
end

end
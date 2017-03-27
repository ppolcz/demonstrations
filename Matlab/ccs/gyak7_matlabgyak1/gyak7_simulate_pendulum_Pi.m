function gyak7_simulate_pendulum_Pi(t,x)
%% 
%  
%  file:   gyak7_simulate_pendulum_Pi.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.27. Monday, 14:53:36
%

x(:,3) = x(:,3) + pi;
gyak7_simulate_pendulum_0(t,x)

end
function gyak8_simulate_pendulum_Pi(t,x,varargin)
%% 
%  
%  file:   gyak8_simulate_pendulum_Pi.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.27. Monday, 14:53:36
%

dim = min(size(x));

if dim == 4
    x(:,3) = x(:,3) + pi;
elseif dim == 2
    x(:,2) = x(:,2) + pi;
end    
gyak8_simulate_pendulum_0(t,x,varargin{:})

end
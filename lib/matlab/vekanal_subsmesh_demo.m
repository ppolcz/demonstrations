function vekanal_subsmesh_demo
%% vekanal_subsmesh_demo
%  
%  File: vekanal_subsmesh_demo.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. July 27.
%

%% Requires
% <script 2_demonstrations/lib/matlab/vekanal_subsmesh.m>

%% Example 1
syms t x1 x2 real
x = [ x1 ; x2 ];
h = sin(x1+x2^2)^2 + x2^2;
[x1_num,x2_num] = meshgrid(linspace(-0.5,1.5,31), linspace(-1,1,31));
h_num = vekanal_subsmesh(h, x, {x1_num, x2_num});
surf(x1_num, x2_num, h_num)

%% Example 2
syms t real
t_num = linspace(0,40,100);
g = [
    t
    5*sin(t/4)
    0
    ];
[v1,v2,v3] = vekanal_subsmesh(g,t,t_num);
plot3(v1,v2,v3)

%% Example 3 
syms x theta real
S = [
    x
    x * cos(theta)
    x * sin(theta)
    ];
[x_mesh,theta_mesh] = meshgrid(linspace(1,2,30),linspace(0,2*pi,30));
[s1,s2,s3] = vekanal_subsmesh(S, [x, theta], {x_mesh , theta_mesh});
surf(s1,s2,s3)


end
function [ret] = polcz(magnitude,angle_degrees)
%%
% POLar form of a Complex Z value (POL. C. Z).
% Angle must be given in degrees.
% 
%  File: polcz.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. November 26.
%

angle = angle_degrees * pi / 180;

ret = magnitude * (cos(angle) + 1j * sin(angle));

end
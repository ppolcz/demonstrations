%% Quiver of a symbolic vector field
%  
%  File: vekanal_quiver_sym_demo.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. July 27.
%

%% Requires
% # <script 2_demonstrations/lib/matlab/vekanal_subsmesh.m>
% # <script 2_demonstrations/lib/matlab/vekanal_quiver_sym.m>

function [ret] = vekanal_quiver_sym_demo

syms x y real

r = [x;y];

f = [
    -y
    x
    ];

g = [
    x
    y
    ] / sqrt(x^2 + y^2);

vekanal_quiver_sym(f, r, {-1,1,20}, {-1,1,20})

end
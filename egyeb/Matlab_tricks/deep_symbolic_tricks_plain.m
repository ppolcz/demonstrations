%% Deep symbolic tricks
% File: deep_symbolic_tricks.m
% 
% Author: Peter Polcz <ppolcz@gmail.com> 
% 
% Created on 2017. November 08.
% 
% Declare some symbolic scalar valued function
%%
syms t x y z real

n = 2;
m = 3;

V = sym(zeros(2,3));
for i = 1:n
    for j = 1:m
        V(i,j) = str2sym(sprintf('V%d%d(t,x,y)',i,j));
    end
end
%% 
% Array of symbolic scalar valued functions (indexable):

V, V(1,2)
%% 
% Array valued symbolic function (not indexable)

V(t,x,y) = V, V(3,1,2)
%% 
% Convert back into an array of symbolic functions

V = V(t,x,y), V(1,3), dV = diff(V,x,y)
%% 
% Array valued symbolic function (not indexable), but the argument is other 
% than previously

V(t,y,z) = V, V(1,2,3)
%% 
% Substritute a concrete function into $V$ and $\frac{\partial^2 V}{\partial 
% x \partial y}$
%%
V12(t,x,y) = sin(x) * exp(-y)
V = subs(V), dV = subs(dV)
%% 
% <https://www.mathworks.com/help/symbolic/solve-differential-algebraic-equations.html 
% Solve Differential Algebraic Equations (DAE) in Matlab>
%% Differenciálok
% <html><p class="lead">Gradiens, divergencia, rotáció, Jacobi mátrix kiszámítása szimbolikusan</p></html>
%  
%  File: anal3_differencialok.m
%  Directory: 2_demonstrations/oktatas/anal3/1_vekanal
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. September 23.
%

%% 

% Szimbolikus valtozok bevezetese
x = sym('x', 'real');
y = sym('y', 'real');
z = sym('y', 'real');

% Vagy egyetlen sorban
syms x y z real

r = [ x ; y ; z ];

% Skalarmezo
f = x^2*sin(x*y) + exp(x*z^2);

% Vektormezo
F = [
    x/y - z/x
    y/z - x/y
    z/x - y/z
    ];

% Gradiens r = (x,y,z) szerint
grad_f = jacobian(f,r)

% Divergencia r = (x,y,z) szerint
div_F = divergence(F,r)

% Rotacio r = (x,y,z) szerint
rot_F = curl(F,r)

% Jacobi matrix r = (x,y,x) szerint
Jacobian_F = jacobian(F,r)

function [ret] = Function_arguments_2(x,y,z,t)
%%
%  File: probafuggveny.m
%  Directory: /home/ppolcz/_
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. April 29. (2020b)
%

arguments
    % Hiaba opcionalis, a Repeating miatt ezeket is meg kell adnom
    % fuggvenyhivaskor.
    x (1,:) {mustBeNumeric} = 1
    y (:,1) {mustBeNumeric} = 2
    z string = 'Nincs ertek megadva'
    t char = 'Ez egy char, nincs ertek megadva'
end

x
y
z
t

end

function test
%%

% Nem az elvart mukodest produkalja
Function_arguments_2(1:3,1:3)


end
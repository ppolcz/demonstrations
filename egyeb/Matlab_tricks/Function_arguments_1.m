function [ret] = Function_arguments_1(x,y,z,t,a,b,s)
%%
%  File: probafuggveny.m
%  Directory: /home/ppolcz/_
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2021. April 29. (2020b)
%

arguments
    % Hiaba opcionalis, a Repeating miatt ezeket is meg kell adnom
    % fuggvenyhivaskor, kiveve ha nincs Repeating.
    x (1,:) {mustBeNumeric} = -Inf      % Optional
    y (:,1) {mustBeNumeric} = Inf       % Optional
    z string = 'Nincs ertek megadva'    % Optional
    t char = 'Ez egy char'              % Optional
end 

arguments (Repeating)
    a
    b
end

arguments
    s.Kutya    % Mandatory
    s.Buta = 2 % Optional
end

x
y
z
t
a
b
s

end

function test
%%

% Nem az elvart mukodest produkalja
Function_arguments_1(1:3,1:3,1,2,3,4,'Kutya',1)

% Az elvart mukodest produkalja
Function_arguments_1(1:3,1:3,'Meg van adva ertek','Ez egy char ertek',1,2,3,4,'Kutya',1)

% Az elvart mukodest produkalja (de nincs s.Kutya)
Function_arguments_1(1:3,1:3,'Meg van adva ertek','Ez egy char ertek',1,2,3,4)

% Az elvart mukodest produkalja (de nincs s.Kutya)
Function_arguments_1(1:3,1:3,'Meg van adva ertek','Ez egy char ertek')

% Az elvart mukodest produkalja (de nincs s.Kutya)
Function_arguments_1()

% Az elvart mukodest produkalja
Function_arguments_1('Kutya',1)

s.Kutya = 1;
s.Buta = 2;

Function_arguments_1(s)


end
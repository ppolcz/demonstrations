function [s] = integerSet(x)
% construct a set object from a vector x
s.elements = x;
s = class(s,'integerSet');

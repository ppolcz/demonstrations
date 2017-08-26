function [ret] = pif(bool, iftrue, iffalse)
%% Script pif
%  
%  file:   pif.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. August 25.
%
%%

if isscalar(iftrue)
    ret = iftrue(ones(size(bool)));
else
    assert(all(size(bool) == size(iftrue)), 'Size of the arguments must match')
    ret = iffalse;
end

if isscalar(iffalse)
    ret(~bool) = iffalse;
else
    assert(all(size(bool) == size(iffalse)), 'Size of the arguments must match')
    ret(bool) = iftrue(bool);
end

end
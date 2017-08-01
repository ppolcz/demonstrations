function [indices,maxdiff,perc] = pcz_symeq_perc(a, b, varargin)
%% Script pcz_symeq_perc
%  
%  file:   pcz_symeq_perc.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 01:40:33
%
%%

[indices,maxdiff,perc] = pcz_symzero_perc(a-b,varargin{:});

end
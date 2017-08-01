function [varargout] = pcz_symeq_report(a, b, varargin)
%% Script pcz_symeq_perc
%  
%  file:   pcz_symeq_perc.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.01. Tuesday, 01:40:33
%
%%

if nargout == 0
    pcz_symzero_report(a-b,varargin{:});
else
    [varargout{:}] = pcz_symzero_report(a-b,varargin{:});
end
    
end
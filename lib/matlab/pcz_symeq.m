function [ret] = pcz_symeq(a,b,varargin)
%% Script pcz_symeq
%  
%  file:   pcz_symeq.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.20. Thursday, 09:46:28
%
%%

if nargout > 0
    ret = pcz_symzero(simplify(a-b),varargin{:});
else
    pcz_symzero(simplify(a-b),varargin{:})
end

end
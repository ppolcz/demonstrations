function [varargout] = pcz_deal(var)
%% 
%  
%  file:   pcz_deal.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.02. Thursday, 12:16:16
%

assert(nargout <= numel(var), 'nargout [%d] > numel(var) [%d]', nargout, numel(var))

for i = 1:nargout
    varargout{i} = var(i);
end

end
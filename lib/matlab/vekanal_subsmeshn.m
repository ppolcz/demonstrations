function [varargout] = vekanal_subsmeshn(symbolic, r_sym, r_num)
%% 
%  
%  file:   vekanal_subsmeshn.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:58:58
%

if nargout > numel(symbolic)
    error('A kimenetek szama (%d) nagyobb mint a fuggveny koordinatainak szama (%d)',...
        nargout, numel(symbolic))
end
varargout = cell(nargout);
for i = 1:nargout
    varargout{i} = vekanal_subsmesh(symbolic(i), r_sym, r_num);
end

end
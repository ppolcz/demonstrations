function [varargout] = vekanal_subsmeshn(symbolic, r_sym, r_num, varargin)
%% 
%  
%  file:   vekanal_subsmeshn.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:58:58
%

% args.normalize = false;
% args = parsepropval(args, varargin{:});
% 
% if nargout > numel(symbolic)
%     error('A kimenetek szama (%d) nagyobb mint a fuggveny koordinatainak szama (%d)',...
%         nargout, numel(symbolic))
% end
% varargout = cell(nargout,1);
% for i = 1:nargout
%     varargout{i} = vekanal_subsmesh(symbolic(i), r_sym, r_num);
% end
% 
% if args.normalize
%     S = size(varargout{1});
%     N = numel(varargout{1});
%     
%     size(varargout)
%     varargout = cellfun(@(a) {reshape(a, [N 1])}, varargout);
%     disp(varargout)
%     
%     X = [ varargout{:} ];
%     
%     R = sqrt(sum(X.^2, 2));
%     
%     X = X ./ R(:,ones(1,nargout));
%     
%     varargout = cellfun(@(a) {reshape(a, S)}, num2cell(X,1));
% end

end
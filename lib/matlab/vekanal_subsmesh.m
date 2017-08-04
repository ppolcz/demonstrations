function [varargout] = vekanal_subsmesh(symbolic, r_sym, r_num, varargin)
%% 
%  
%  file:   vekanal_subsmesh.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.30. Friday, 11:57:13
%

args.normalize = false;
args = parsepropval(args, varargin{:});

if isscalar(symbolic)
    if ~iscell(r_num)
        % pl. vekanal_subsmesh(..., r_sym = x, r_num = linspace)
        assert(numel(r_sym) == 1, ...
            'r_num csak akkor lehet tomb, ha a fuggveny csak egy valtozos')
        r_num = {r_num};
    else
        % pl. vekanal_subsmesh(..., r_sym = {x y}, r_num = {linspace, linspace})
        r_sym = r_sym(:);
        for i = 2:numel(r_num)
            assert(all(size(r_num{1}) == size(r_num{i})),...
                ['Az egyes valtozok numerikus reprezentaciojaban a numerikus matrixok merete meg kell egyezzen.\n'...
                'HIBA: r_num{%d}.size = [%d,%d], mig: r_num{%d}.size = [%d,%d]'], ...
                1, size(r_num{1}), i, size(r_num{i}))
        end
    end
    
    if numel(r_sym) ~= numel(r_num)
        error(['A szimbolikus valtozok szama [r_sym: %d], '...
            'meg kell egyezzen a numerikus helyettesitesi valtozok szamaval [r_num: %d]'],...
            numel(r_sym), numel(r_num))
    end
    
    % Ez azért kell, hogy biztos legyen benne szimbolikus változó
    t = sym('ZIGOTA_VIGYAZZ','real');
    fh = matlabFunction(symbolic + t, 'vars', [num2cell(r_sym); t]);
    
    if nargout > 0
        varargout{1} = fh(r_num{:}, r_num{1}*0);
    end
    
    if nargout > 1
        varargout{2} = fh;
    end
    return
end

% Ide csak akkor lép, ha több dimenziós a szimbolikus függvény (pl.
% vektormező).

assert(nargout <= numel(symbolic), ...
    'A kimenetek szama (%d) nagyobb mint a fuggveny koordinatainak szama (%d)',...
    nargout, numel(symbolic))

varargout = cell(nargout,1);
for i = 1:nargout
    varargout{i} = vekanal_subsmesh(symbolic(i), r_sym, r_num);
end

if args.normalize
    S = size(varargout{1});
    N = numel(varargout{1});
    
    size(varargout)
    varargout = cellfun(@(a) {reshape(a, [N 1])}, varargout);
    disp(varargout)
    
    X = [ varargout{:} ];
    
    R = sqrt(sum(X.^2, 2));
    
    X = X ./ R(:,ones(1,nargout));
    
    varargout = cellfun(@(a) {reshape(a, S)}, num2cell(X,1));
end

end
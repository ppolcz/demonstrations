function [varargout] = vekanal_subsmesh(symbolic, r_sym, r_num, varargin)
%% 
%  
%  File: vekanal_subsmesh.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
% 
%  Created on 2016.09.30. Friday, 11:57:13
%  Modified on 2018. July 27.
% 
% Examples
%{

%% Example 1
syms t x1 x2 real
x = [ x1 ; x2 ];
h = sin(x1+x2^2)^2 + x2^2;
[x1_num,x2_num] = meshgrid(linspace(-0.5,1.5,31), linspace(-1,1,31));
h_num = vekanal_subsmesh(h, x, {x1_num, x2_num});
surf(x1_num, x2_num, h_num)

%% Example 2
syms t real
t_num = linspace(0,40,100);
g = [
    t
    5*sin(t/4)
    0
    ];
[v1,v2,v3] = vekanal_subsmesh(g,t,t_num);
plot3(v1,v2,v3)

%% Example 3 
syms x theta real
S = [
    x
    x * cos(theta)
    x * sin(theta)
    ];
[x_mesh,theta_mesh] = meshgrid(linspace(1,2,30),linspace(0,2*pi,30));
[s1,s2,s3] = vekanal_subsmesh(S, [x, theta], {x_mesh , theta_mesh});
surf(s1,s2,s3)

%}

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
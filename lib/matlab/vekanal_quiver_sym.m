function [handle,X,Y,f1,f2] = vekanal_quiver_sym(f,vars,xm,ym,varargin)
%% vekanal_quiver_sym
%  
%  File: vekanal_quiver_sym.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. July 27.
%

%%

% f_fh = matlabFunction(f, 'vars', vars);

if iscell(xm) && iscell(ym)

    [X,Y] = meshgrid(linspace(xm{:}),linspace(ym{:}));
    [f1,f2] = vekanal_subsmesh(f, vars, {X, Y});
    
    r = sqrt(f1.^2 + f2.^2);
    
    f1 = f1 ./ r;
    f2 = f2 ./ r;
    
    handle = quiver(X,Y,f1,f2, varargin{:});
else
    % TODO, egyeb esetek kezelese
end

end

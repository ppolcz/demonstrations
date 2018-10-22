function [ret,variables,new_vars] = pcz_sdpvar2sym(name, var, assumption)
%% pcz_sdpvar2sym
%  
%  File: pcz_sdpvar2sym.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. September 17.
%

%%

if nargin <= 2
    assumption = 'real';
end

svar = sym(var);

variables = symvar(svar);

new_vars = sym(name, size(variables), assumption);

ret = subs(svar, variables, new_vars);

end
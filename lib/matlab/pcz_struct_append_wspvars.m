function [str] = pcz_struct_append_wspvars(str,varargin)
%% 
%  
%  file:   pcz_struct_append_wspvars.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.01. Wednesday, 20:14:21
%
% Examples:
%  str = pcz_struct_append_wspvars;
%  str = pcz_struct_append_wspvars(str);
%  str = pcz_struct_append_wspvars('rewrite',false);

opts.exclude = {
    'TMP_*'
    };
opts = parsepropval(opts, varargin{:});

vars = evalin('caller', 'who');

if nargin == 0 || ~isstruct(str)
    str = struct;
    strname = '';
    
    if nargin > 0 ; varargin = [str varargin]; end
else
    strname = inputname(1);
end

for i = 1:numel(vars)
    var = vars{i};
    % disp(var)
    % disp(evalin('caller',var))
    
    % do not append itself
    if ~strcmp(strname,var)
        str = pcz_struct_append(str, evalin('caller',var), 'name', var, varargin{:});
    end
end

end
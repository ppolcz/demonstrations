function [str] = pcz_struct_append(str, varargin)
%% 
%  
%  file:   pcz_struct_append.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.01.24. Tuesday, 14:25:01
%


opts_start = nargin;
for i = 2:nargin
    var = varargin{i-1};
    name = inputname(i);
    if isempty(name) && ischar(var) && ~isempty(var)
        opts_start = i - 1;
        break
    end
end

opts.rewrite = false;
opts = parsepropval(opts, varargin{opts_start:end});

for i = 2:opts_start
    var = varargin{i-1};
    name = inputname(i);

    % fprintf('name = %s\n', name)
    % pcz_info(isempty(name), 'isempty(name)')
    % pcz_info(opts.rewrite, 'opts.rewrite')
    % pcz_info(isfield(str,name), 'isfield(str,name)')
    % pcz_info(~isempty(name) && (opts.rewrite || ~isfield(str,name)), '~isempty(name) && (opts.rewrite || ~isfield(str,name))')
    
    if ~isempty(name) && (opts.rewrite || ~isfield(str,name))
        str.(name) = var;
    end
    
end

end
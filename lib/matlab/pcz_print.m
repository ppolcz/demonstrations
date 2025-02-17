function [ret] = pcz_print(fname, varargin)
%% Script pcz_print
%  
%  file:   pcz_print.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.07.02. Sunday, 23:41:18
%
%%

border = [3 3];

[dir,~,ext] = fileparts(fname);

print(fname,['-d' ext(2:end)],varargin{:});

system(sprintf('convert %s -trim %s', fname, fname));

system(sprintf('convert %s -bordercolor White -border %dx%d %s', ...
    fname, border(1:2), fname));

pcz_dispFunction('File saved to:\n%s', fname);

fn = pcz_resolvePath(matlab.desktop.editor.getActive().Filename);
command = sprintf('krusader --left %s --right %s', fn.dir, dir);
clipboard('copy', command);


end
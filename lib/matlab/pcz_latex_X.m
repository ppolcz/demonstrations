function [ret] = pcz_latex_X(X, l, s)
%% 
%  
%  file:   pcz_latex_X.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.03.21. Monday, 18:16:44
%

if nargin < 2 || isempty(l)
    l = 8;
end

if nargin < 3 || isempty(s)
    s = 1;
end

[Nr, ~] = size(X);

scalebox_begin = '';
scalebox_end = '';
if s ~= 1
    scalebox_begin = '\scalebox{0.9}{$';
    scalebox_end = '$}';
end
    
i = 0;
if Nr <= l
    fprintf('%s%s%s\n', ...
        scalebox_begin, pcz_latex(X',2), scalebox_end);
    return
end

if Nr >= i
    
    fprintf('%s%s%s \\\\ \n', ...
        scalebox_begin, strrep(pcz_latex(X(1+i:min(l+i,Nr),:)',2),'\\', '& \ldots \\'), scalebox_end);
    i = i + l;
end

nt = sprintf('\n    ');
while Nr > i
    
    fprintf('%s%s%s\n', ...
        scalebox_begin, ...
        strrep(pcz_latex(X(1+i:min(l+i,Nr),:)',2), nt, [ nt '\ldots & ']), ...
        scalebox_end);
    i = i + l;
end

end
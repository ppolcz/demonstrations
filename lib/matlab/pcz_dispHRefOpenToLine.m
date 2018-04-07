function [ret] = pcz_dispHRefOpenToLine(file, line)
%% pcz_dispHRefOpenToLine
%  
%  File: pcz_dispHRefOpenToLine.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. April 06.
%

%%

filepath = which(file);

if exist(filepath,'file') == 0
    warning('No such file: %s -> %s', file, filepath)
end

line = num2str(line);
cmd_line = [ 'opentoline(''' filepath ''',' line ')' ];

text = pcz_dispHRefMatlab([ file ':' line ], cmd_line);

if nargout > 0
    ret = text;
else
    disp(text);
end

end
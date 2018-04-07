function [ret] = pcz_dispFunctionStackTrace(varargin)
%% pcz_dispFunctionStackTrace
%  
%  File: pcz_dispFunctionStackTrace.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. April 06.
%

%%

if isempty(varargin)
    varargin{1} = 'Stack trace:';
end

s = dbstack;
pcz_dispFunctionSubtitle(varargin{:})
for ii = 2:numel(s)
    link = pcz_dispHRefOpenToLine(s(ii).file, s(ii).line);
    pcz_dispFunction2(link)    
end


end
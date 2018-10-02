function [ret] = pcz_conv(varargin)
%% pcz_conv
%  
%  File: pcz_conv.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. October 02.
%

%%

narginchk(2,1000);

while numel(varargin) > 1
    varargin{end-1} = conv(varargin{end-1}, varargin{end});
    varargin(end) = [];
end

ret = varargin{1};

end
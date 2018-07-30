function [ret] = pcz_align(varargin)
%% pcz_align
%  
%  File: pcz_align.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. July 30.
%

%%

if nargin == 1
    str = varargin{1};
else
    str = sprintf(varargin{:});
end

ret_ = sprintf('%s%s%s', '\begin{align}', str, '\end{align}');

if nargout >= 1
    ret = ret_;
else
    disp(ret_)
end

end
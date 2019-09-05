function [ret] = pcz_fontSize(size)
%% pcz_fontSize
%  
%  File: pcz_fontSize.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2019. September 04. (2019a)
%

%%

if nargin < 1
    size = 13;
elseif ischar(size)
    size = str2num(size);
end

com.mathworks.services.FontPrefs.setCodeFont(java.awt.Font('Monospaced',java.awt.Font.PLAIN,size))

com.mathworks.services.FontPrefs.getCodeFont()

end
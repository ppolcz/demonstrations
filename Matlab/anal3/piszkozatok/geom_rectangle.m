function [x,y]=geom_rectangle(bs,s)
%% 
%  
%  file:   geom_rectangle.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.03. Saturday, 15:34:03
%

nbs = 4; % Number of boundary segments

d = [
    0 0 0 0   % Start parameter value
    1 1 1 1   % End parameter value
    1 1 1 1   % Left hand region
    0 0 0 0   % Right hand region
    ];

% start_angles = [0;pi/2;pi;3*pi/2];
start_angles = [ pi/4 ; 3*pi/4 ; 5*pi/4 ; 7*pi/4 ];
switch nargin
    case 0
        x=nbs; 
    case 1    
        x=d(:,bs);
    case 2
        if isscalar(bs)
            bs = repmat(bs,size(s));
        end
        x = zeros(size(s));
        y = zeros(size(s));
        for i = 1:numel(s)
           segment = bs(i);
           offset = pi/2*s(i);
           angle = start_angles(segment)+offset;
           
           x(i) = sign(cos(angle));
           y(i) = sign(sin(angle));            
        end
end

end
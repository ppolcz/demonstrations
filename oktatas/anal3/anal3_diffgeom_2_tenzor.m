%% Script anal3_diffgeom_2_tenzor
%  
%  file:   anal3_diffgeom_2_tenzor.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.08.07. Monday, 17:30:51
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

clc            % clear the command window
clear all      % clear all variables
format compact % condense command window output
format long g  % +, bank, hex, long, rat, short, short g, short eng

% This is a MATLAB document to compute Christoffel symbols and geodesic equations, using a given metric gαβ.
% Justification for the method is found in various texts on general relativity, and is not duplicated here. By working
% through Lagrange's equations for the line element of a given metric, such as the wormhole metric,
% ds^2 = -dt^2 +dr^2 + (b^2 + r^2) * (dΘ^2 + sin^2 (Θ) dΦ^2)
% a general expression for the Christoffel symbols of the metric and its derivatives is obtained.
% Though this illustrates the use of MATLAB, it is more educational than functional. 
% Nonetheless, Gamma /is/ the MDA of Christoffel symbols for this metric, and the geodesic, however plainly displayed,
% is complete.
% This script contains comments for those coming to MATLAB from other platforms.
% I refer to sets of equations, for example, geodesic, in the singular, 'geodesic'.

syms xa t r theta phi g b Gamma % b is used in the wormhole metric

xa (1) = t;     % t : xa are the dimension labels for x
xa (2) = r;     % r
xa (3) = theta; % theta
xa (4) = phi;   % phi

strxa = [ 't    '; 'r    '; 'theta'; 'phi  ' ]; % MATLAB char arrays must use the same length for all locations
cellxa = cellstr (strxa);                       % but converting to cells trims the padding on the right

n = 4; % dimensions

% metric initialization, from the wormhole expression above
g (1, 1) = -1;
g (2, 2) =  1;
g (3, 3) =  b^2 + r^2;
g (4, 4) =  (b^2 + r^2) * (sin (theta))^2;

gi = inv (g);

% In MATLAB, a vector is a one-dimensional array and a matrix is a two-dimensional array.
% MDAa are created by extending 2D arrays; e.g., [:, :, n]. Execute the next two lines for an example.
% M = [ 1 2; 3 4 ];
% M (:, :, 2) = [ 5 6; 7 8 ]

% Generate Christoffel symbols
% Gamma = zeros (n, n, n); Can't use zeros directly because the array is symbolic, and would be initialized as double
for gamma = 1:n
  for beta = 1:n
    for alpha = 1:n
      Gamma (alpha, beta, gamma) = 0;
    end
  end
end

% See "Gravity - An Introduction to Einstein's General Relativity", Hartle, 2003, Ch 8.1
for delta = 1:n % delta spans the variable labels over which symbols will be calculated
  for gamma = 1:n
    for beta = 1:n
      for alpha = 1:n
        Gamma (beta, gamma, delta) = Gamma (beta, gamma, delta) + ...
          0.5 * gi (alpha, delta) * ...
            (diff (g (alpha, beta),  xa (gamma)) + ...
             diff (g (alpha, gamma), xa (beta))  - ...
             diff (g (beta, gamma),  xa (alpha)));
      end
    end
  end
  Gamma (:, :, delta) % display for verification
end

% Generating geodesic string equations; conversion from sym array to character cell array { } strGamma
% Note that this could be combined with the routine following, but is here for clarification
for gamma = 1:n
  for beta = 1:n
    for alpha = 1:n
      strGamma (alpha, beta, gamma) = {char(Gamma (alpha, beta, gamma))}; % must be char( NOT char (
    end
  end
end
strGamma % display for verification

% The cell array geodesic contains the geodesic equation for the coordinates t, r, theta, phi
for gamma = 1:n
  empty = true;
  strEq = strcat ('D2', cellxa {gamma}, '=');
  for beta = 1:n
    for alpha = 1:n
      if ~(Gamma (alpha, beta, gamma) == 0) % Only include terms for which there is a non-vanishing Christoffel symbol
        empty = false;
        strEq = strcat (strEq, ' +(', strGamma (alpha, beta, gamma), ')*D', cellxa {alpha}, '*D', cellxa {beta});
      end 
    end
  end
  if empty
    strEq = ''; % Don't display equation terms for which there are no Christoffel symbols
  end
  geodesic (gamma) = {strEq};
end

% Note that off-diagonal terms are not combined for this sample program
g1 = cell2mat (geodesic {1})
g2 = cell2mat (geodesic {2})
g3 = cell2mat (geodesic {3})
g4 = cell2mat (geodesic {4})

% Results using MATLAB R2011a
% ans =
% [ 0, 0, 0, 0]
% [ 0, 0, 0, 0]
% [ 0, 0, 0, 0]
% [ 0, 0, 0, 0]
% ans =
% [ 0, 0,  0,               0]
% [ 0, 0,  0,               0]
% [ 0, 0, -r,               0]
% [ 0, 0,  0, -r*sin(theta)^2]
% ans =
% [ 0,             0,             0,                      0]
% [ 0,             0, r/(b^2 + r^2),                      0]
% [ 0, r/(b^2 + r^2),             0,                      0]
% [ 0,             0,             0, -cos(theta)*sin(theta)]
% ans =
% [ 0,             0,                     0,                     0]
% [ 0,             0,                     0,         r/(b^2 + r^2)]
% [ 0,             0,                     0, cos(theta)/sin(theta)]
% [ 0, r/(b^2 + r^2), cos(theta)/sin(theta),                     0]
% 
% strGamma(:,:,1) = 
%     '0'    '0'    '0'    '0'
%     '0'    '0'    '0'    '0'
%     '0'    '0'    '0'    '0'
%     '0'    '0'    '0'    '0'
% strGamma(:,:,2) = 
%     '0'    '0'    '0'     '0'              
%     '0'    '0'    '0'     '0'              
%     '0'    '0'    '-r'    '0'              
%     '0'    '0'    '0'     '-r*sin(theta)^2'
% strGamma(:,:,3) = 
%     '0'    '0'                '0'                '0'                     
%     '0'    '0'                'r/(b^2 + r^2)'    '0'                     
%     '0'    'r/(b^2 + r^2)'    '0'                '0'                     
%     '0'    '0'                '0'                '-cos(theta)*sin(theta)'
% strGamma(:,:,4) = 
%     '0'    '0'                '0'                        '0'                    
%     '0'    '0'                '0'                        'r/(b^2 + r^2)'        
%     '0'    '0'                '0'                        'cos(theta)/sin(theta)'
%     '0'    'r/(b^2 + r^2)'    'cos(theta)/sin(theta)'    '0'                    
% 
% g1 = []
% g2 = D2r= +(-r)*Dtheta*Dtheta +(-r*sin(theta)^2)*Dphi*Dphi
% g3 = D2theta= +(r/(b^2 + r^2))*Dtheta*Dr +(r/(b^2 + r^2))*Dr*Dtheta +(-cos(theta)*sin(theta))*Dphi*Dphi
% g4 = D2phi= +(r/(b^2 + r^2))*Dphi*Dr +(cos(theta)/sin(theta))*Dphi*Dtheta +(r/(b^2 + r^2))*Dr*Dphi +(cos(theta)/sin

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
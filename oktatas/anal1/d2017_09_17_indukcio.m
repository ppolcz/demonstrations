%% Matematikai indukció
%  
%  file:   d2017_09_17_indukcio.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017. September 17.
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

%% Faktoriálisos feladat
%
% $$
% \prod_{i = 1}^n (2 k)! < [(n+1)!]^n
% $$

n = 10;
for i = 1:n
    faktorialisok = cumprod(1:2*n);
    baloldal = prod(faktorialisok(2:2:2*n));
    jobboldal = factorial(n+1)^n;
    
    if baloldal < jobboldal
        disp 'baloldal < jobboldal';
    elseif baloldal == jobboldal
        disp 'baloldal = jobboldal';
    else
        disp 'baloldal > jobboldal';
    end
end


%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
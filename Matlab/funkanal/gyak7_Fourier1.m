%% Script gyak7_Fourier1
%  
%  file:   gyak7_Fourier1.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.30. Thursday, 19:47:38
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

%% Gram-Smidt orthogonalization

syms x real

Dot = @(f,g) int(f.*g,x,-1,1);
Norm = @(f) int(f.^2,x,-1,1);

N = 4;
phi = cell(1,N+1);
phi{1} = 1;

for i = 1:N
    f = x^i;
    dot = Dot(f,phi{i}); 
    
    fprintf('f_%g(x) = %s\n',i, char(f))
    fprintf('<f_%g,phi_%g> = %s\n',i,i-1,char(dot))
    phi{i+1} = f - dot*phi{i};
    phi{i+1} = phi{i+1} / Norm(phi{i+1});
end

phi{:}

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
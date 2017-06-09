%% Script analyse_properties_of_svd
%  
%  file:   analyse_properties_of_svd.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.06.09. Friday, 22:43:13
%
%%

% Automatically generated stuff
global SCOPE_DEPTH
SCOPE_DEPTH = 0;

TMP_kzOUaGOyFoGAkcaGKdUB = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

A = [
    1 2 3
    4 5 6
    ];

[U,S,Vh] = svd(A)

S*Vh'
%%

A = [
    1 2 3 4 5 6 7 8
    3 4 5 6 7 8 2 1
    ];

[U,S,Vh] = svd(A)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_kzOUaGOyFoGAkcaGKdUB);
clear TMP_kzOUaGOyFoGAkcaGKdUB
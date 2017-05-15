%% Script gyak8_lepcsos_alak
%  
%  file:   gyak8_lepcsos_alak.m
%  author: Peter Polcz <ppolcz@gmail.com> 
%  
%  Created on 2017.03.28. Tuesday, 11:20:59
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

%% Irányíthatósági lépcsős alak

n = 5;
r_exp = 3;

r = 0;
while r ~= r_exp
    A = round(randn(n)*2);
    B = round(randn(n,1)*2);
    C = round(randn(1,n)*2);

    Cn = ctrb(A,B);
    r = rank(Cn);
end

A,B,C,D,Cn
rank(obsv(A,C))

%%

S = [ orth(Cn) null(Cn) ];
T = inv(S);
A_ = T*A/T

%%

Ao = A';
Bo = C';
Co = B';
On = obsv(Ao,Co)

S = [ orth(On) null(On) ];
T = inv(S)

Ao_ = T*Ao/T

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
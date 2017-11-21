%% LMI tricks
%  
%  File:   LMI_tricks.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2017. November 21.
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

%% Preserve a full matrix to have very large values

C = sdpvar(2,3);

sdpopts = sdpsettings('verbose', 0);

mu = 10000;

optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , sum(C(:)) , sdpopts);
val_C = value(C)

%%
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , -sum(C(:)) , sdpopts);
val_C = value(C)

%%
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , C(1) , sdpopts);
val_C = value(C)

%% 
optimize( [ mu*eye(2) C ; C' eye(3) ] >= 0 , C(1)+C(3) , sdpopts);
val_C = value(C)

%%
% End of the script.
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
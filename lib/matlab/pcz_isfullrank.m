function [ret] = pcz_isfullrank(A)
%% Script pcz_isfullrank
%  
%  File: pcz_isfullrank.m
%  Directory: 1_projects/3_outsel/2017_11_13_lpv_passivity
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. February 08.
%

%%

ret = rank(A) == min(size(A));


end
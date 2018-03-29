function [ret] = pcz_checkfieldAll(model,varargin)
%% Script pcz_checkfieldAll
%  
%  File: pcz_checkfieldAll.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. March 28.
%

%%

ret = all(cellfun(@(name) isfield(model,name), varargin));


end
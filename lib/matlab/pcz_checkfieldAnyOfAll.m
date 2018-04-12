function [index, ret] = pcz_checkfieldAnyOfAll(model,varargin)
%% Script pcz_checkfieldAnyOfAll
%  
%  File: pcz_checkfieldAnyOfAll.m
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. March 28.
%

%%

global VERBOSE

if isempty(VERBOSE)
    VERBOSE = 0;
end

index = find(cellfun(@(names) pcz_checkfieldAll(model,names{:}), varargin), 1);

if VERBOSE || nargout > 1

    ret{1} = ~isempty(index);

    if ret{1}
        ret{2} = 'One of the following tuples of fields must be contained: %s. Satisfied: %s.';
        ret{3} = char(join(cellfun(@(names) {['(' char(join(names, ' and ')) ')' ]} , varargin)', ' or '));
        ret{4} = ['(' char(join(varargin{index}, ' and ')) ')' ];
    else
        ret{2} = 'One of the following tuples of fields must be contained: %s. Not satisfied!';
        ret{3} = char(join(cellfun(@(names) {['(' char(join(names, ' and ')) ')' ]} , varargin)', ' or '));
    end
    
    if VERBOSE && nargout == 1
        pcz_info(ret{:})    
    end

end

end
function [ret] = pglobals_set(name, value)
%% pglobals_set
%  
%  File: pglobals_set.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. June 09.
%

%%

persistent Old_Values

eval(['global ' name ' ; ']);

if nargin > 1
    
    % Store old variables
    if ~isfield(Old_Values, name)
        Old_Values.(name) = { eval(name) };
    else
        Old_Values.(name) = [ Old_Values.(name) eval(name) ];
    end
    
    % Set variable
    if isnumeric(value) && isscalar(value)
        eval([name ' = ' num2str(value) ';']);
    end

else
    
    if isfield(Old_Values, name) && ~isempty(Old_Values.(name))
        
        values = Old_Values.(name);
        value = values{end};
        
        % Set variable
        if isnumeric(value) && isscalar(value)
            eval([name ' = ' num2str(value) ';']);
            Old_Values.(name) = values(1:end-1);
        end
    end
    
end

% display(Old_Values)
    

end
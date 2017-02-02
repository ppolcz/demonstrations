function pcz_struct_split(varargin)
%% 
%  
%  file:   pcz_struct_split.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.01. Wednesday, 20:46:41
%

for k = 1:numel(varargin)
    str = varargin{k};
    fn = fieldnames(str);

    for i = 1:numel(fn)
%         if evalin('caller', sprintf('exist(''%s'',''var'')', fn{i}))
%             warning(...
%                 'P:split_struct:overwrite', ...
%                 'Variabe `%s'' (which is a field in the input structure) exists, overwriting', ...
%                 fn{i})
%         end

        assignin('caller', fn{i}, str.(fn{i}))
    end
end

end
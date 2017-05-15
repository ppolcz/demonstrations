function [x] = subsref(s,a)
x = [];
if (a.type == '()')
    index = a.subs{:};
    if (max(index) >size(s) || (min(index) < 1))
        error('incorrect index to set');
    end
    x = s.elements(index);
end
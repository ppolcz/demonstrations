function s = mtimes(s1,s2)
% Find the intersection of two sets
s = integerSet([]);
for i =1:length(s1.elements)
    e = s1.elements(i);
    if (~isempty(find(s2.elements(:) == e)))
        s = insert(s,e);
    end
end

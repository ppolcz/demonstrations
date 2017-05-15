function s = minus(s1,s2)
% intersect two sets
s = integerSet([]);
for i =1:size(s1)
    if (isempty(find(s2(:) == s1.elements(i))))
        s = insert(s,s1.elements(i));
    end
end

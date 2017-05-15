function s = plus(s1,s2)
s = s1;
for i =1:size(s2)
    s = insert(s,s2.elements(i));
end

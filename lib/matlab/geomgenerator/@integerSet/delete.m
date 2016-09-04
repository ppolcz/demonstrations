function snew = delete(s,x)
snew  = integerSet([]);
index = find(s.elements(:) == x);
if (isempty(index))
    snew = s;
else
    snew.elements = s.elements([1:index-1 index+1:end]);
end
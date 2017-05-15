function s = insert(s,x)
index = find(s.elements(:) == x);
if (isempty(index))
    s.elements(end+1) = x;
else
    % do nothing
end
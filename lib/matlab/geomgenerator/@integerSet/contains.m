function [trueOrFalse] = contains(smallSet,largeSet)
if (length(smallSet) > length(largeSet))
    trueOrFalse = 0;
    return;
end

for e1 = elementsOf(smallSet)
    if (isempty(find(largeSet,e1)))
        trueOrFalse = 0;
        return;
    end 
end
trueOrFalse = 1;
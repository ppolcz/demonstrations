function    prunedComb = generateParentsCombination(pdeGeomPadded,currentParents,...
                        neighbors,medialPointParents, currentMP)

counter = 0;
prunedComb = [];

% if (length(currentParents) == 4)
%     parentTypes = pdeGeomPadded(1,currentParents);
%     nConcaveVertices = sum(parentTypes(:) == -1); 
%     if (nConcaveVertices == 2)
%         prunedComb(1,:) = currentParents(find(parentTypes(:) == -1));
%         prunedComb(2,:) = currentParents(find(parentTypes(:) ~= -1));
%         return;
%     end
% end
parentsCombination =  nchoosek(currentParents,2);

for select = 1:size(parentsCombination,1)
    medialEdgeParents = integerSet(parentsCombination(select,:));
    found = false;
    % skip if a neighbor along this edge already exists
    for nbr = elementsOf(neighbors{currentMP})
        common = medialPointParents{nbr}*medialEdgeParents;
        if (length(common) == 2)
            found = true;
            break;
        end
    end
    if (found)
        continue;
    end
    % if the parents contain a concave pt and an adjacent edge,  skip
    p1 = medialEdgeParents(1);
    p2 = medialEdgeParents(2);
    
    if (pdeGeomPadded(1,p1) == -1)
        e1 = pdeGeomPadded(4,p1);
        e2 = pdeGeomPadded(5,p1);
        if (e1 == p2) || (e2 == p2)
            continue;
        end
    elseif (pdeGeomPadded(1,p2) == -1)
        e1 = pdeGeomPadded(4,p2);
        e2 = pdeGeomPadded(5,p2);
        if (e1 == p1) || (e2 == p1)
            continue;
        end
    end 
    counter = counter+1;
    prunedComb(counter,:) = parentsCombination(select,:);
end

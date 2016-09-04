function printMedialPointData(nMedialPoints,medialPointParents,neighbors)
for i =1:nMedialPoints
    disp(['Medial point: '  num2str(i) '************']);
    mpParents = medialPointParents{i}
    mpNeighbors = neighbors{i}
end
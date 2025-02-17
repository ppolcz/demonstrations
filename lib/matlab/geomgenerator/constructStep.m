function [geomData] = constructStep(L1,L2,H1,H2,offset)

% various cases are modeled
if (offset <= 0)
    offset = 0;
    geomData = [2 0 L1 0 0 1 0 0 0 0 0 ; ...
            2 L1 L1+L2 offset offset 1 0 0 0 0 0 ; ...
            2 L1+L2 L1+L2 offset offset+H2 1 0 0 0 0 0 ; ...
            2 L1+L2 L1 offset+H2 offset+H2 1 0 0 0 0 0 ; ...
            2 L1 L1 offset+H2 H1 1 0 0 0 0 0 ; ...
            2 L1 0 H1 H1 1 0 0 0 0 0 ; ...
            2 0 0 H1 0 1 0 0 0 0 0 ]';
elseif (offset >= (H1-H2))
    offset = H1-H2;
    geomData = [2 0 L1 0 0 1 0 0 0 0 0 ; ...
            2 L1 L1 0 offset 1 0 0 0 0 0 ; ...
            2 L1 L1+L2 offset offset 1 0 0 0 0 0 ; ...
            2 L1+L2 L1+L2 offset offset+H2 1 0 0 0 0 0 ; ...
            2 L1+L2 L1 offset+H2 offset+H2 1 0 0 0 0 0 ; ...
            2 L1 0 H1 H1 1 0 0 0 0 0 ; ...
            2 0 0 H1 0 1 0 0 0 0 0 ]';
elseif (offset > 0) & (offset < (H1 - H2))
    geomData = [2 0 L1 0 0 1 0 0 0 0 0 ; ...
            2 L1 L1 0 offset 1 0 0 0 0 0 ; ...
            2 L1 L1+L2 offset offset 1 0 0 0 0 0 ; ...
            2 L1+L2 L1+L2 offset offset+H2 1 0 0 0 0 0 ; ...
            2 L1+L2 L1 offset+H2 offset+H2 1 0 0 0 0 0 ; ...
            2 L1 L1 offset+H2 H1 1 0 0 0 0 0 ; ...
            2 L1 0 H1 H1 1 0 0 0 0 0 ; ...
            2 0 0 H1 0 1 0 0 0 0 0 ]';
end
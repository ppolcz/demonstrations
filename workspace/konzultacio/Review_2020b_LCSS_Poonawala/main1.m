%%

pcz_generateSymStateVector(2)

% rng(1)
E = randn(2);

E = [
    -1 1
    4 -2
    ];


e = E*x;
et = E'*x;

e1_fh = matlabFunction(e(1),'vars',x);
e2_fh = matlabFunction(e(2),'vars',x);
E_fh = @(x1,x2) double((e1_fh(x1,x2) >= 0) & (e2_fh(x1,x2) >= 0));

et1_fh = matlabFunction(et(1),'vars',x);
et2_fh = matlabFunction(et(2),'vars',x);
Et_fh = @(x1,x2) double((et1_fh(x1,x2) >= 0) & (et2_fh(x1,x2) >= 0));

[x1,x2] = meshgrid(linspace(-4,4,50));

surf(x1,x2,E_fh(x1,x2) + 2*Et_fh(x1,x2))
view([0 -90])
axis equal

%% Example 1

pcz_generateSymStateVector(2)

A = [
    0  1
    -1 0
    ];

a1 = [0.3 -1]';
a2 = [1 0.9]';
a3 = [-1 1]';
a4 = [0 0]';



e = E*x;
et = E'*x;

e1_fh = matlabFunction(e(1),'vars',x);
e2_fh = matlabFunction(e(2),'vars',x);
E_fh = @(x1,x2) double((e1_fh(x1,x2) >= 0) & (e2_fh(x1,x2) >= 0));

et1_fh = matlabFunction(et(1),'vars',x);
et2_fh = matlabFunction(et(2),'vars',x);
Et_fh = @(x1,x2) double((et1_fh(x1,x2) >= 0) & (et2_fh(x1,x2) >= 0));

[x1,x2] = meshgrid(linspace(-4,4,50));

surf(x1,x2,E_fh(x1,x2) + 2*Et_fh(x1,x2))
view([0 -90])
axis equal


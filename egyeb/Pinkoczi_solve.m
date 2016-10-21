%%
%
%  file:   Pinkoczi_solve.m
%  author: Polcz Péter <ppolcz@gmail.com>
%
%  Created on 2016.10.21. Friday, 16:30:37
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_QVgVGfoCXYiYXzPhvVPX = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%%


syms x y z real
syms e1 e2 e3 real

assume(e1 ~= 0 & e2 ~= 0 & e3 ~= 0 & ...
    e1^2*e2^2 + 2*e1^2*e3^2 + e2^2*e3^2 + 8*e1^2*e2^2*e3^2 <= 4*e1*e2^2*e3^2 + 4*e1^2*e2^2*e3 + 2*e1*e2*e3^2 + 2*e1^2*e2*e3 & ...
    in(e1,'real') & in(e2,'real') & in(e3,'real') & in(x,'real') & in(y,'real') & in(z,'real') ...
    )

eq = solve([
    1/( (x-1)^2 + y^2 + z^2) - e1
    1/( x^2 + (y-1)^2 + z^2) - e2
    1/( (x+1)^2 + y^2 + z^2) - e3
    ], [x y z]);

eq.x
eq.y
eq.z

% ans =
%  (e1 - e3)/(4*e1*e3)
%  (e1 - e3)/(4*e1*e3)
% ans =
%  (e1*e2 - 2*e1*e3 + e2*e3)/(4*e1*e2*e3)
%  (e1*e2 - 2*e1*e3 + e2*e3)/(4*e1*e2*e3)
% ans =
%  -(- 4*e1^2*e2^2*e3^2 + 2*e1^2*e2^2*e3 - (e1^2*e2^2)/2 + e1^2*e2*e3 - e1^2*e3^2 + 2*e1*e2^2*e3^2 + e1*e2*e3^2 - (e2^2*e3^2)/2)^(1/2)/(2*e1*e2*e3)
%   (- 4*e1^2*e2^2*e3^2 + 2*e1^2*e2^2*e3 - (e1^2*e2^2)/2 + e1^2*e2*e3 - e1^2*e3^2 + 2*e1*e2^2*e3^2 + e1*e2*e3^2 - (e2^2*e3^2)/2)^(1/2)/(2*e1*e2*e3)

%% end of the scope
pcz_dispFunctionEnd(TMP_QVgVGfoCXYiYXzPhvVPX);
clear TMP_QVgVGfoCXYiYXzPhvVPX
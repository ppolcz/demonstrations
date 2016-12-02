%% 
%  
%  file:   gyak1_indukcio.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2016.09.09. Friday, 16:22:48
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_IbSWJNMuIiKbocfQKqXb = pcz_dispFunctionName;

% fname: full path of the actual file
pcz_cmd_fname('fname');
persist = pcz_persist(fname);
%persist.backup();

%%

syms n

% sum_item = @(n) 1 / ( n*(n+1)*(n+2) );
% sum_result = @(n) n*(n+3) / (4*(n+1)*(n+2));

sum_item = @(n) (n-1)*n^2;
sum_result = @(n) n*(n^2-1)*(3*n+2)/12;

pretty(sum_result(n)*12)

pretty(expand(sum_result(n+1) * 12))
pretty(expand((sum_result(n) + sum_item(n+1)) * 12))

n = 10;
SUM = 0;
for k = 1:n
    SUM = SUM + sum_item(k);
end

SUM
sum_result(n)



%% end of the scope
pcz_dispFunctionEnd(TMP_IbSWJNMuIiKbocfQKqXb);
clear TMP_IbSWJNMuIiKbocfQKqXb
function [ret] = pcz_feasible(CONS)
%% pcz_feasible
%  
%  File: pcz_feasible.m
%  Directory: 2_demonstrations/lib/matlab
%  Author: Peter Polcz (ppolcz@gmail.com) 
%  
%  Created on 2018. May 18.
%

%%

[Prim,Dual] = check(CONS);

mp = min(Prim);
md = min(Dual);

msg = 'The solution is strictly feasible. ';

if mp <= 0
    msg = [msg , sprintf(' Min(Primal) = %d.', mp)];
end

if md <= 0
    msg = [msg , sprintf(' Min(Dua) = %d.', md)];
end

pcz_info(mp > 0 && md > 0,msg);

end
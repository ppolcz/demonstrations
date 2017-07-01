%% 
%  
%  file:   gyak2_toltott_reszecske_mozgasa.m
%  author: Polcz Péter <ppolcz@gmail.com> 
%  
%  Created on 2017.02.23. Thursday, 16:28:55
%

global SCOPE_DEPTH
SCOPE_DEPTH = 0;

%% beginning of the scope
TMP_tNPjzxHKNoJIigzXrElN = pcz_dispFunctionName;

try c = evalin('caller','persist'); catch; c = []; end
persist = pcz_persist(mfilename('fullpath'), c); clear c; 
persist.backup();
%clear persist

%%

m = 1;
q = 1;

tipus = 11;
switch tipus
    case 1 % sima ciklois
        E = [ 1 0 0 ]';
        B = [ 0 0 1 ]';
        x0 = [ 0 0 0 ]';
        v0 = [ 0 0 0 ]';
    case 2 % kulso ciklois
        E = [ 1 0 0 ]';
        B = [ 0 0 1 ]';
        x0 = [ 0 0 0 ]';
        v0 = [ 0 0.4 0 ]';
    case 4 % belso ciklois
        E = [ 1 0 0 ]';
        B = [ 0 0 1 ]';
        x0 = [ 0 0 0 ]';
        v0 = [ 0 -0.5 0 ]';
    case 5 % elfajult egyenes
        E = [ 1 0 0 ]';
        B = [ 0 0 1 ]';
        x0 = [ 0 0 0 ]';
        v0 = [ 0 -1 0 ]';
    case 11 % 
        E = [ 1 0 0 ]';
        B = [ 0 0 1 ]';
        x0 = [ 0 0 0 ]';
        v0 = [ 2.3 -1.8 2.2 ]';
end
        
f = @(t,xi) [
    xi(4:6,:)
    q/m * E + q/m * cross(xi(4:6,:),B)
    ];
[t,xi] = ode45(f,[0 10],[ x0 ; v0]);

plot3(xi(:,1), xi(:,2), xi(:,3))
grid on
axis equal
% axis tight


%%

syms t real
x = sym('x', [3,1]);
v = sym('v', [3 1]);

f_sym = [
    v
    q/m * E + q/m * cross(v,B)
    ];

f_fh = matlabFunction(f_sym, 'vars', {t [x;v]});

[t,xi] = ode45(f,[0 10],[ x0 ; v0]);

plot3(xi(:,1), xi(:,2), xi(:,3))
grid on
axis equal


%% end of the scope
pcz_dispFunctionEnd(TMP_tNPjzxHKNoJIigzXrElN);
clear TMP_tNPjzxHKNoJIigzXrElN